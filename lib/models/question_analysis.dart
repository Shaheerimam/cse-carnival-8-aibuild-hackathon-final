/// Per-question analysis produced by Gemini.
class QuestionAnalysis {
  final String id;
  final String text;
  final int marks;
  final String topic;
  final String clo;
  final String difficulty; // 'easy' | 'medium' | 'hard'
  final String cognitiveLevel; // Bloom's taxonomy level
  final String type; // 'theory' | 'application'
  final String llmVulnerabilitySeverity; // 'low' | 'medium' | 'high'
  final String llmVulnerabilityReason;
  final String recommendation;

  const QuestionAnalysis({
    required this.id,
    required this.text,
    required this.marks,
    required this.topic,
    required this.clo,
    required this.difficulty,
    required this.cognitiveLevel,
    required this.type,
    required this.llmVulnerabilitySeverity,
    required this.llmVulnerabilityReason,
    required this.recommendation,
  });

  factory QuestionAnalysis.fromJson(Map<String, dynamic> j) =>
      QuestionAnalysis(
        id: j['id'] as String? ?? '',
        text: j['text'] as String? ?? '',
        marks: (j['marks'] as num?)?.toInt() ?? 0,
        topic: j['topic'] as String? ?? 'General',
        clo: j['clo'] as String? ?? '-',
        difficulty: j['difficulty'] as String? ?? 'medium',
        cognitiveLevel: j['cognitiveLevel'] as String? ?? 'Understand',
        type: j['type'] as String? ?? 'theory',
        llmVulnerabilitySeverity:
            j['llmVulnerabilitySeverity'] as String? ?? 'low',
        llmVulnerabilityReason:
            j['llmVulnerabilityReason'] as String? ?? '',
        recommendation: j['recommendation'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'marks': marks,
        'topic': topic,
        'clo': clo,
        'difficulty': difficulty,
        'cognitiveLevel': cognitiveLevel,
        'type': type,
        'llmVulnerabilitySeverity': llmVulnerabilitySeverity,
        'llmVulnerabilityReason': llmVulnerabilityReason,
        'recommendation': recommendation,
      };
}
