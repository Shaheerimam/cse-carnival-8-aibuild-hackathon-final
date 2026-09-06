import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/audit_provider.dart';
import '../report/report_screen.dart';
import '../home/home_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  static const _steps = [
    'Extracting document content…',
    'Parsing syllabus nodes & CLOs…',
    'Segmenting exam questions…',
    'Mapping coverage & gaps…',
    'Classifying cognitive levels…',
    'Scoring LLM vulnerability…',
    'Generating recommendations…',
    'Building your audit report…',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        // Navigate on completion or error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.status == AuditProviderStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ReportScreen()),
            );
          } else if (provider.status == AuditProviderStatus.error) {
            _showErrorAndPop(context, provider.errorMessage);
          }
        });

        return Scaffold(
          backgroundColor: AppColors.richBlack,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  _buildPulsingOrb(),
                  const SizedBox(height: 48),
                  Text(
                    'Analysing Exam',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gemini 1.5 Pro is reviewing your documents',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  _buildStepsList(provider.processingStep),
                  const Spacer(),
                  _buildCancelButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingOrb() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) {
        final scale = 0.9 + 0.1 * _pulseController.value;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.15),
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.25),
                ),
                child: Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepsList(int currentStep) {
    return Column(
      children: List.generate(_steps.length, (i) {
        final isDone = i < currentStep;
        final isActive = i == currentStep;
        final opacity = isDone || isActive ? 1.0 : 0.25;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppColors.success
                      : isActive
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.1),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          size: 13, color: Colors.white)
                      : isActive
                          ? SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            )
                          : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _steps[i],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate(delay: (i * 30).ms).fadeIn(duration: 300.ms);
      }),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      ),
      child: Text(
        'Cancel',
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white.withOpacity(0.4),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showErrorAndPop(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Audit Failed'),
        content: Text(
          message.length > 300
              ? '${message.substring(0, 300)}…'
              : message,
          style: GoogleFonts.inter(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (_) => false,
              );
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
