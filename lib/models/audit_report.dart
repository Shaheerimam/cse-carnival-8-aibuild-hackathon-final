import 'question_analysis.dart';

// ─── Sub-models ───────────────────────────────────────────────────────────────

class CloCoverageItem {
  final String cloId;
  final String description;
  final double coveragePercent;
  final String status; // 'good' | 'warning' | 'missing'

  const CloCoverageItem({
    required this.cloId,
    required this.description,
    required this.coveragePercent,
    required this.status,
  });

  factory CloCoverageItem.fromJson(Map<String, dynamic> j) => CloCoverageItem(
        cloId: j['cloId'] as String? ?? '',
        description: j['description'] as String? ?? '',
        coveragePercent: (j['coveragePercent'] as num?)?.toDouble() ?? 0,
        status: j['status'] as String? ?? 'warning',
      );

  Map<String, dynamic> toJson() => {
        'cloId': cloId,
        'description': description,
        'coveragePercent': coveragePercent,
        'status': status,
      };
}

class TopicCoverageItem {
  final String topic;
  final double coveragePercent;
  final String syllabusWeightHint; // e.g. "High", "Medium", "Low"

  const TopicCoverageItem({
    required this.topic,
    required this.coveragePercent,
    required this.syllabusWeightHint,
  });

  factory TopicCoverageItem.fromJson(Map<String, dynamic> j) =>
      TopicCoverageItem(
        topic: j['topic'] as String? ?? '',
        coveragePercent: (j['coveragePercent'] as num?)?.toDouble() ?? 0,
        syllabusWeightHint: j['syllabusWeightHint'] as String? ?? 'Medium',
      );

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'coveragePercent': coveragePercent,
        'syllabusWeightHint': syllabusWeightHint,
      };
}

class CognitiveDistribution {
  final double remember;
  final double understand;
  final double apply;
  final double analyze;
  final double evaluate;
  final double create;

  const CognitiveDistribution({
    this.remember = 0,
    this.understand = 0,
    this.apply = 0,
    this.analyze = 0,
    this.evaluate = 0,
    this.create = 0,
  });

  factory CognitiveDistribution.fromJson(Map<String, dynamic> j) =>
      CognitiveDistribution(
        remember: (j['remember'] as num?)?.toDouble() ?? 0,
        understand: (j['understand'] as num?)?.toDouble() ?? 0,
        apply: (j['apply'] as num?)?.toDouble() ?? 0,
        analyze: (j['analyze'] as num?)?.toDouble() ?? 0,
        evaluate: (j['evaluate'] as num?)?.toDouble() ?? 0,
        create: (j['create'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'remember': remember,
        'understand': understand,
        'apply': apply,
        'analyze': analyze,
        'evaluate': evaluate,
        'create': create,
      };
}

class MarkWeightedRatio {
  /// Percentage of total marks assigned to theory-based questions.
  final double theoryPercent;

  /// Percentage of total marks assigned to application-based questions.
  final double applicationPercent;

  const MarkWeightedRatio({
    required this.theoryPercent,
    required this.applicationPercent,
  });

  factory MarkWeightedRatio.fromJson(Map<String, dynamic> j) =>
      MarkWeightedRatio(
        theoryPercent: (j['theoryPercent'] as num?)?.toDouble() ?? 50,
        applicationPercent:
            (j['applicationPercent'] as num?)?.toDouble() ?? 50,
      );

  Map<String, dynamic> toJson() => {
        'theoryPercent': theoryPercent,
        'applicationPercent': applicationPercent,
      };
}

class LlmVulnerabilityFlag {
  final String questionId;
  final String questionText;
  final String severity; // 'low' | 'medium' | 'high'
  final String reason;
  final String suggestion;

  const LlmVulnerabilityFlag({
    required this.questionId,
    required this.questionText,
    required this.severity,
    required this.reason,
    required this.suggestion,
  });

  factory LlmVulnerabilityFlag.fromJson(Map<String, dynamic> j) =>
      LlmVulnerabilityFlag(
        questionId: j['questionId'] as String? ?? '',
        questionText: j['questionText'] as String? ?? '',
        severity: j['severity'] as String? ?? 'medium',
        reason: j['reason'] as String? ?? '',
        suggestion: j['suggestion'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'questionText': questionText,
        'severity': severity,
        'reason': reason,
        'suggestion': suggestion,
      };
}

class Recommendation {
  final String type;
  final String severity; // 'high' | 'medium' | 'low'
  final String description;
  final String action;

  const Recommendation({
    required this.type,
    required this.severity,
    required this.description,
    required this.action,
  });

  factory Recommendation.fromJson(Map<String, dynamic> j) => Recommendation(
        type: j['type'] as String? ?? '',
        severity: j['severity'] as String? ?? 'medium',
        description: j['description'] as String? ?? '',
        action: j['action'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'severity': severity,
        'description': description,
        'action': action,
      };
}

// ─── Root Report Model ────────────────────────────────────────────────────────

class AuditReport {
  final int overallScore; // 0-100
  final List<CloCoverageItem> cloCoverage;
  final List<TopicCoverageItem> topicCoverage;
  final List<QuestionAnalysis> questions;
  final CognitiveDistribution cognitiveDistribution;
  final MarkWeightedRatio markWeightedRatio;
  final List<LlmVulnerabilityFlag> llmVulnerabilityFlags;
  final List<Recommendation> recommendations;
  final String executiveSummary;

  const AuditReport({
    required this.overallScore,
    required this.cloCoverage,
    required this.topicCoverage,
    required this.questions,
    required this.cognitiveDistribution,
    required this.markWeightedRatio,
    required this.llmVulnerabilityFlags,
    required this.recommendations,
    required this.executiveSummary,
  });

  factory AuditReport.fromJson(Map<String, dynamic> j) {
    List<T> parseList<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson,
    ) {
      final raw = j[key];
      if (raw == null) return [];
      return (raw as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return AuditReport(
      overallScore: (j['overallScore'] as num?)?.toInt() ?? 0,
      cloCoverage: parseList('cloCoverage', CloCoverageItem.fromJson),
      topicCoverage: parseList('topicCoverage', TopicCoverageItem.fromJson),
      questions: parseList('questions', QuestionAnalysis.fromJson),
      cognitiveDistribution: j['cognitiveDistribution'] != null
          ? CognitiveDistribution.fromJson(
              j['cognitiveDistribution'] as Map<String, dynamic>)
          : const CognitiveDistribution(),
      markWeightedRatio: j['markWeightedRatio'] != null
          ? MarkWeightedRatio.fromJson(
              j['markWeightedRatio'] as Map<String, dynamic>)
          : const MarkWeightedRatio(
              theoryPercent: 50, applicationPercent: 50),
      llmVulnerabilityFlags:
          parseList('llmVulnerabilityFlags', LlmVulnerabilityFlag.fromJson),
      recommendations: parseList('recommendations', Recommendation.fromJson),
      executiveSummary: j['executiveSummary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'overallScore': overallScore,
        'cloCoverage': cloCoverage.map((e) => e.toJson()).toList(),
        'topicCoverage': topicCoverage.map((e) => e.toJson()).toList(),
        'questions': questions.map((e) => e.toJson()).toList(),
        'cognitiveDistribution': cognitiveDistribution.toJson(),
        'markWeightedRatio': markWeightedRatio.toJson(),
        'llmVulnerabilityFlags':
            llmVulnerabilityFlags.map((e) => e.toJson()).toList(),
        'recommendations': recommendations.map((e) => e.toJson()).toList(),
        'executiveSummary': executiveSummary,
      };
}
