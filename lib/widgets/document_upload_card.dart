import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../services/pdf_extraction_service.dart';

/// A two-action upload card for picking a PDF or pasting text.
/// Calls [onTextReady] with the extracted/pasted text.
class DocumentUploadCard extends StatefulWidget {
  const DocumentUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTextReady,
    this.icon = Icons.description_outlined,
  });

  final String title;
  final String subtitle;
  final ValueChanged<String> onTextReady;
  final IconData icon;

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  String? _fileName;
  bool _isLoaded = false;
  bool _isPicking = false;
  final _textController = TextEditingController();
  bool _showPasteField = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() => _isPicking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final name = result.files.single.name;
        final extracted = PdfExtractionService.instance.extractText(bytes);

        if (extracted.isNotEmpty) {
          setState(() {
            _fileName = name;
            _isLoaded = true;
            _showPasteField = false;
          });
          widget.onTextReady(extracted);
        } else {
          // Fallback: ask user to paste text
          if (mounted) {
            setState(() => _showPasteField = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Could not extract text from PDF. Please paste content manually.'),
              ),
            );
          }
        }
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _onPasteSubmit() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _fileName = 'Pasted text';
      _isLoaded = true;
      _showPasteField = false;
    });
    widget.onTextReady(text);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: _isLoaded ? AppColors.accentLight : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isLoaded ? AppColors.accent : AppColors.grey200,
          width: _isLoaded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isLoaded
                        ? AppColors.accent.withOpacity(0.15)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isLoaded ? Icons.check_circle_rounded : widget.icon,
                    color:
                        _isLoaded ? AppColors.accent : AppColors.grey400,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.richBlack,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isLoaded ? _fileName! : widget.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: _isLoaded
                              ? AppColors.accent
                              : AppColors.grey500,
                          fontWeight: _isLoaded
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (_isLoaded)
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.grey400),
                    onPressed: () {
                      setState(() {
                        _isLoaded = false;
                        _fileName = null;
                        _textController.clear();
                      });
                      widget.onTextReady('');
                    },
                  ),
              ],
            ),
            if (!_isLoaded) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Pick PDF',
                      icon: Icons.upload_file_outlined,
                      onTap: _isPicking ? null : _pickFile,
                      isLoading: _isPicking,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      label: 'Paste Text',
                      icon: Icons.content_paste_rounded,
                      onTap: () =>
                          setState(() => _showPasteField = !_showPasteField),
                      isOutlined: true,
                    ),
                  ),
                ],
              ),
              if (_showPasteField) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _textController,
                  maxLines: 6,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Paste document content here…',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onPasteSubmit,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.richBlack,
          borderRadius: BorderRadius.circular(12),
          border: isOutlined
              ? Border.all(color: AppColors.grey300)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(icon,
                  size: 16,
                  color: isOutlined
                      ? AppColors.richBlack
                      : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isOutlined ? AppColors.richBlack : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
