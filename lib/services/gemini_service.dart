import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/audit_report.dart';
import '../models/question_analysis.dart';

/// Wrapper around the Gemini 1.5 Pro API.
/// API key is injected at compile time via --dart-define=GEMINI_API_KEY=<key>.
class GeminiService {
  GeminiService._();
  static final GeminiService instance = GeminiService._();

  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.2,
      responseMimeType: 'application/json',
    ),
  );

  bool get isConfigured => _apiKey.isNotEmpty;

  // ─── Audit Prompt ─────────────────────────────────────────────────────────

  static const String _auditSystemPrompt = '''
You are an expert academic assessment analyst. Your task is to audit a university exam draft against the provided course outline.

Analyse BOTH documents carefully and return a STRICT JSON object matching this schema:
{
  "overallScore": <integer 0-100>,
  "executiveSummary": "<2-3 sentence professional summary>",
  "cloCoverage": [
    {
      "cloId": "<string>",
      "description": "<string>",
      "coveragePercent": <number 0-100>,
      "status": "<'good'|'warning'|'missing'>"
    }
  ],
  "topicCoverage": [
    {
      "topic": "<string>",
      "coveragePercent": <number 0-100>,
      "syllabusWeightHint": "<'High'|'Medium'|'Low'>"
    }
  ],
  "questions": [
    {
      "id": "<Q1, Q2, ...>",
      "text": "<full question text>",
      "marks": <integer>,
      "topic": "<string>",
      "clo": "<string or '-'>",
      "difficulty": "<'easy'|'medium'|'hard'>",
      "cognitiveLevel": "<'Remember'|'Understand'|'Apply'|'Analyze'|'Evaluate'|'Create'>",
      "type": "<'theory'|'application'>",
      "llmVulnerabilitySeverity": "<'low'|'medium'|'high'>",
      "llmVulnerabilityReason": "<string>",
      "recommendation": "<string>"
    }
  ],
  "cognitiveDistribution": {
    "remember": <percent>,
    "understand": <percent>,
    "apply": <percent>,
    "analyze": <percent>,
    "evaluate": <percent>,
    "create": <percent>
  },
  "markWeightedRatio": {
    "theoryPercent": <number>,
    "applicationPercent": <number>
  },
  "llmVulnerabilityFlags": [
    {
      "questionId": "<string>",
      "questionText": "<string>",
      "severity": "<'low'|'medium'|'high'>",
      "reason": "<why an AI can trivially solve this>",
      "suggestion": "<how to constrain or improve it>"
    }
  ],
  "recommendations": [
    {
      "type": "<'missing_clo'|'topic_gap'|'cognitive_imbalance'|'llm_risk'|'general'>",
      "severity": "<'high'|'medium'|'low'>",
      "description": "<specific issue identified>",
      "action": "<concrete actionable recommendation>"
    }
  ]
}

RULES:
- cognitiveDistribution values must sum to 100 (by question count percentage).
- markWeightedRatio values must sum to 100 (based on marks, not question count).
- LLM vulnerability: 'high' = trivially solved by any LLM in seconds, 'medium' = partially, 'low' = requires domain-specific knowledge.
- Be a supportive reviewer, not a harsh critic. Use phrasing like "may benefit from" not "is wrong".
- Return ONLY the JSON. No markdown fences. No commentary outside the JSON.
''';

  /// Send syllabus + exam text to Gemini and return a structured [AuditReport].
  Future<AuditReport> auditExam({
    required String syllabusText,
    required String examText,
  }) async {
    if (!isConfigured) {
      throw Exception(
          'Gemini API key not configured. Run with --dart-define=GEMINI_API_KEY=<key>');
    }

    final prompt = '''
=== COURSE OUTLINE / SYLLABUS ===
$syllabusText

=== DRAFT EXAM PAPER ===
$examText
''';

    final response = await _model.generateContent([
      Content.system(_auditSystemPrompt),
      Content.text(prompt),
    ]);

    final rawJson = response.text ?? '';
    if (rawJson.isEmpty) {
      throw Exception('Gemini returned an empty response.');
    }

    try {
      // Strip potential markdown fences if model ignores mime-type hint
      final cleaned = rawJson
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
      return AuditReport.fromJson(decoded);
    } catch (e) {
      throw Exception('Failed to parse Gemini response: $e\n\nRaw: $rawJson');
    }
  }

  // ─── Reskinner Prompt ─────────────────────────────────────────────────────

  static const String _reskinnerSystemPrompt = '''
You are an expert exam question designer specialising in academic integrity.
Given an exam question, generate 3 semantically equivalent variant questions.
Each variant must:
- Test the SAME cognitive skill and learning outcome.
- Use a DIFFERENT scenario, domain context, or data set.
- Maintain the same difficulty level and marks weight.
- Be substantially different in surface wording to prevent direct AI reuse.

Return ONLY a JSON array of 3 strings. Example:
["Variant question 1 text.", "Variant question 2 text.", "Variant question 3 text."]
No markdown. No commentary.
''';

  /// Generate 3 semantically-equivalent but surface-level-different question variants.
  Future<List<String>> reskinQuestion(QuestionAnalysis question) async {
    if (!isConfigured) {
      throw Exception('Gemini API key not configured.');
    }

    final prompt = '''
Original question (${question.marks} marks, ${question.cognitiveLevel} level, ${question.topic} topic):
"${question.text}"

Generate 3 variants.
''';

    final response = await _model.generateContent([
      Content.system(_reskinnerSystemPrompt),
      Content.text(prompt),
    ]);

    final rawJson = response.text ?? '[]';
    final cleaned = rawJson
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    try {
      final decoded = jsonDecode(cleaned) as List;
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      throw Exception('Failed to parse reskinner response: $e');
    }
  }
}
