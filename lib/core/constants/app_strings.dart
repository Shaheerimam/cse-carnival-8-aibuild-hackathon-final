abstract final class AppStrings {
  // ── App ───────────────────────────────────────────────────────────────────
  static const appName = 'ExamAuditor';
  static const appTagline = 'AI-powered assessment intelligence';

  // ── Home ──────────────────────────────────────────────────────────────────
  static const homeGreeting = 'Good morning,';
  static const homeSubtitle = 'Faculty';
  static const homeRecentAudits = 'Recent Audits';
  static const homeNoAudits = 'No audits yet';
  static const homeNoAuditsSubtitle = 'Upload your first exam to get started';
  static const homeNewAudit = 'New Audit';

  // ── Ingestion ─────────────────────────────────────────────────────────────
  static const ingestionTitle = 'Document Hub';
  static const ingestionSubtitle = 'Upload your course outline & draft exam';
  static const ingestionSyllabus = 'Course Outline / Syllabus';
  static const ingestionSyllabusHint = 'Add your syllabus or CLOs';
  static const ingestionExam = 'Draft Exam Paper';
  static const ingestionExamHint = 'Add your draft exam questions';
  static const ingestionPickFile = 'Pick File (PDF)';
  static const ingestionPasteText = 'Paste Text';
  static const ingestionRunAudit = 'Run AI Audit';
  static const ingestionBothRequired = 'Please provide both documents to run the audit.';
  static const ingestionCourseTitle = 'Course Title (optional)';
  static const ingestionCourseTitleHint = 'e.g. Data Structures — Spring 2026';

  // ── Processing ────────────────────────────────────────────────────────────
  static const processingTitle = 'Analysing Exam';
  static const processingStep1 = 'Extracting document content…';
  static const processingStep2 = 'Parsing syllabus nodes & CLOs…';
  static const processingStep3 = 'Segmenting exam questions…';
  static const processingStep4 = 'Mapping coverage & gaps…';
  static const processingStep5 = 'Classifying cognitive levels…';
  static const processingStep6 = 'Scoring LLM vulnerability…';
  static const processingStep7 = 'Generating recommendations…';
  static const processingStep8 = 'Building your audit report…';

  // ── Report ────────────────────────────────────────────────────────────────
  static const reportTitle = 'Audit Report';
  static const reportScore = 'Quality Score';
  static const reportCloCoverage = 'CLO Coverage';
  static const reportTopicCoverage = 'Topic Coverage';
  static const reportCognitive = 'Cognitive Distribution';
  static const reportMarkWeighted = 'Mark-Weighted Ratio';
  static const reportVulnerability = 'LLM Vulnerability';
  static const reportRecommendations = 'Recommendations';
  static const reportQuestions = 'Question Analysis';
  static const reportShareReport = 'Share Report';

  // ── Question Detail ────────────────────────────────────────────────────────
  static const questionDetailTitle = 'Question Detail';
  static const questionDetailReskinner = 'Reskinner — Generate Variant';
  static const questionDetailMarks = 'Marks';
  static const questionDetailTopic = 'Topic';
  static const questionDetailClo = 'CLO';
  static const questionDetailDifficulty = 'Difficulty';
  static const questionDetailCogLevel = 'Cognitive Level';
  static const questionDetailType = 'Type';
  static const questionDetailVulnerability = 'LLM Vulnerability';

  // ── Reskinner ─────────────────────────────────────────────────────────────
  static const reskinnerTitle = 'Semantic Reskinner';
  static const reskinnerSubtitle = 'AI-generated question variants';
  static const reskinnerOriginal = 'Original Question';
  static const reskinnerGenerating = 'Generating variants…';
  static const reskinnerVariant = 'Variant';
  static const reskinnerUseThis = 'Use This Variant';
  static const reskinnerSwipeHint = 'Swipe to browse variants';
  static const reskinnerError = 'Could not generate variants. Please try again.';

  // ── History ───────────────────────────────────────────────────────────────
  static const historyTitle = 'Audit History';
  static const historySearchHint = 'Search audits…';
  static const historyEmpty = 'No audit history';
  static const historyDeleteConfirm = 'Delete this audit session?';
  static const historyDeleteAction = 'Delete';
  static const historyCancelAction = 'Cancel';

  // ── Common ────────────────────────────────────────────────────────────────
  static const loading = 'Loading…';
  static const error = 'Something went wrong';
  static const retry = 'Retry';
  static const close = 'Close';
  static const cancel = 'Cancel';
  static const done = 'Done';
  static const viewAll = 'View all';
  static const theory = 'Theory';
  static const application = 'Application';

  // ── Cognitive Levels ──────────────────────────────────────────────────────
  static const remember = 'Remember';
  static const understand = 'Understand';
  static const apply = 'Apply';
  static const analyze = 'Analyze';
  static const evaluate = 'Evaluate';
  static const create = 'Create';

  // ── Difficulty ────────────────────────────────────────────────────────────
  static const easy = 'Easy';
  static const medium = 'Medium';
  static const hard = 'Hard';

  // ── Vulnerability ─────────────────────────────────────────────────────────
  static const vulnLow = 'Low';
  static const vulnMedium = 'Medium';
  static const vulnHigh = 'High';
}
