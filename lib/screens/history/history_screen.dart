import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/audit_session.dart';
import '../../providers/audit_provider.dart';
import '../../widgets/glass_card.dart';
import '../report/report_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        title: const Text('Audit History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AuditProvider>(
        builder: (context, provider, _) {
          final filtered = provider.history
              .where((s) => s.courseTitle
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty()
                    : _buildList(filtered, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.inter(fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search audits…',
          prefixIcon: Icon(Icons.search_rounded, size: 20),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.history_rounded,
                color: AppColors.grey300, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No audit history' : 'No results found',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.richBlack,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _searchQuery.isEmpty
                ? 'Your past audits will appear here'
                : 'Try a different search term',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<AuditSession> sessions, AuditProvider provider) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      itemCount: sessions.length,
      itemBuilder: (context, i) {
        final session = sessions[i];
        return Dismissible(
          key: Key(session.id),
          direction: DismissDirection.endToStart,
          background: _DismissBackground(),
          confirmDismiss: (_) => _confirmDelete(context),
          onDismissed: (_) => provider.deleteSession(session.id),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _HistoryCard(
              session: session,
              index: i,
              onTap: () {
                if (session.status == AuditStatus.complete) {
                  provider.setCurrentSession(session);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportScreen()),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Audit'),
        content: const Text('Are you sure you want to delete this audit session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_rounded, color: AppColors.danger),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.session,
    required this.index,
    required this.onTap,
  });
  final AuditSession session;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final score = session.report?.overallScore;
    final isComplete = session.status == AuditStatus.complete;
    final isError = session.status == AuditStatus.error;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          // Score/status badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isError
                  ? AppColors.dangerLight
                  : score != null
                      ? _scoreColor(score).withOpacity(0.1)
                      : AppColors.grey100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: isError
                  ? const Icon(Icons.error_rounded,
                      color: AppColors.danger, size: 22)
                  : score != null
                      ? Text(
                          '$score',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _scoreColor(score),
                          ),
                        )
                      : const Icon(Icons.hourglass_top_rounded,
                          color: AppColors.warning, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.courseTitle,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.richBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(session.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _StatusBadge(status: session.status),
                  ],
                ),
              ],
            ),
          ),
          if (isComplete)
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.grey300, size: 20),
        ],
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 350.ms)
        .slideX(begin: 0.03, duration: 350.ms);
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final AuditStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case AuditStatus.complete:
        bg = AppColors.successLight;
        fg = AppColors.success;
        label = 'Complete';
        break;
      case AuditStatus.error:
        bg = AppColors.dangerLight;
        fg = AppColors.danger;
        label = 'Error';
        break;
      case AuditStatus.processing:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        label = 'Processing';
        break;
      default:
        bg = AppColors.grey100;
        fg = AppColors.grey500;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
