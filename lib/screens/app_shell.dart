import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import 'home/home_screen.dart';
import 'ingestion/ingestion_screen.dart';
import 'history/history_screen.dart';
import 'settings/settings_screen.dart';

/// Root scaffold with a glassmorphic bottom navigation bar.
/// Uses IndexedStack to preserve page state across tab switches.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    IngestionScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBlack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isActive: _currentIndex == 0,
                onTap: () => _switchTab(0),
              ),
              _NavItem(
                icon: Icons.add_circle_outline_rounded,
                label: 'New Audit',
                isActive: _currentIndex == 1,
                onTap: () => _switchTab(1),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'History',
                isActive: _currentIndex == 2,
                onTap: () => _switchTab(2),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: _currentIndex == 3,
                onTap: () => _switchTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.richBlack.withOpacity(0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 22,
                color: isActive ? AppColors.richBlack : AppColors.grey400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.richBlack : AppColors.grey400,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
