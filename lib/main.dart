import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'providers/audit_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lock to portrait for a focused mobile-first experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.ghostWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ExamAuditorApp());
}

class ExamAuditorApp extends StatelessWidget {
  const ExamAuditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuditProvider()..loadHistory(),
        ),
      ],
      child: MaterialApp(
        title: 'ExamAuditor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AppShell(),
        builder: (context, child) {
          // Clamp text scale to prevent layout overflows on large-font systems
          final data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
              textScaler: TextScaler.linear(
                data.textScaler.scale(1.0).clamp(0.85, 1.15),
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
