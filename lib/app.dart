import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/lesson/letter_lesson_screen.dart';

class AplikasiBelajarApp extends StatelessWidget {
  const AplikasiBelajarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Belajar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Uri.base.queryParameters['screen'] == 'huruf'
          ? const LetterLessonScreen()
          : const SplashScreen(),
    );
  }
}
