import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/audit_provider.dart';
import '../../widgets/document_upload_card.dart';
import '../processing/processing_screen.dart';

class IngestionScreen extends StatefulWidget {
  const IngestionScreen({super.key});

  @override
  State<IngestionScreen> createState() => _IngestionScreenState();
}

class _IngestionScreenState extends State<IngestionScreen> {
  String _syllabusText = '';
  String _examText = '';
  final _titleController = TextEditingController();

  bool get _canRun => _syllabusText.isNotEmpty && _examText.isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        title: const Text('Document Hub'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeader(),
            const SizedBox(height: 24),
            _buildCourseTitleField(),
            const SizedBox(height: 20),
            DocumentUploadCard(
              title: 'Course Outline / Syllabus',
              subtitle: 'Pick a PDF or paste your CLOs and topics',
              icon: Icons.menu_book_outlined,
              onTextReady: (text) => setState(() => _syllabusText = text),
            ),
            const SizedBox(height: 14),
            DocumentUploadCard(
              title: 'Previous Question Paper',
              subtitle: 'Pick a PDF or paste the questions to evaluate',
              icon: Icons.quiz_outlined,
              onTextReady: (text) => setState(() => _examText = text),
            ),
            const SizedBox(height: 32),
            _buildRunButton(),
            const SizedBox(height: 16),
            _buildInfoNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload your documents',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.richBlack,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Provide a course outline and draft exam.\nThe AI will audit coverage, cognitive balance & more.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.grey500,
            height: 1.5,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCourseTitleField() {
    return TextField(
      controller: _titleController,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: const InputDecoration(
        labelText: 'Course Title (optional)',
        hintText: 'e.g. Data Structures — Spring 2026',
        prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 400.ms);
  }

  Widget _buildRunButton() {
    return AnimatedOpacity(
      opacity: _canRun ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _canRun ? _runAudit : null,
          icon: const Icon(Icons.auto_awesome_rounded, size: 18),
          label: Text(
            'Run AI Audit',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.richBlack,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Both documents are required to run the audit. '
              'Richer content = better analysis.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.accentDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }

  void _runAudit() {
    context.read<AuditProvider>().startAudit(
      courseTitle: _titleController.text.trim(),
      syllabusText: _syllabusText,
      examText: _examText,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProcessingScreen()),
    );
  }
}
