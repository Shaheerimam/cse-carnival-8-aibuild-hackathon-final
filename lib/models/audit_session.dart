import 'audit_report.dart';

/// Status of an audit session.
enum AuditStatus { pending, processing, complete, error }

/// Top-level container for one audit run.
class AuditSession {
  final String id;
  final String courseTitle;
  final String syllabusText;
  final String examText;
  final DateTime createdAt;
  final AuditStatus status;
  final AuditReport? report;
  final String? errorMessage;

  const AuditSession({
    required this.id,
    required this.courseTitle,
    required this.syllabusText,
    required this.examText,
    required this.createdAt,
    this.status = AuditStatus.pending,
    this.report,
    this.errorMessage,
  });

  AuditSession copyWith({
    AuditStatus? status,
    AuditReport? report,
    String? errorMessage,
  }) {
    return AuditSession(
      id: id,
      courseTitle: courseTitle,
      syllabusText: syllabusText,
      examText: examText,
      createdAt: createdAt,
      status: status ?? this.status,
      report: report ?? this.report,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseTitle': courseTitle,
        'syllabusText': syllabusText,
        'examText': examText,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'report': report?.toJson(),
        'errorMessage': errorMessage,
      };

  factory AuditSession.fromJson(Map<String, dynamic> json) {
    return AuditSession(
      id: json['id'] as String,
      courseTitle: json['courseTitle'] as String,
      syllabusText: json['syllabusText'] as String,
      examText: json['examText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: AuditStatus.values.byName(json['status'] as String),
      report: json['report'] != null
          ? AuditReport.fromJson(json['report'] as Map<String, dynamic>)
          : null,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}
