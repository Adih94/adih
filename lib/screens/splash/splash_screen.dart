import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../welcome/welcome_screen.dart';

/// Halaman animasi loading yang tampil sesaat saat app pertama dibuka.
/// Murni animasi kode (tidak butuh file video/gambar), jadi bisa langsung
/// jalan meski aset asli belum ada.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToHomeAfterDelay();
  }

  Future<void> _goToHomeAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            // Logo bulat sederhana, muncul dengan efek pop + bounce
            Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                )
                .animate()
                .scale(
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1, 1),
                )
                .then()
                .shake(duration: 400.ms, hz: 2),

            const SizedBox(height: 24),

            // Judul app, muncul fade + geser naik sedikit lebih lambat dari logo
            Text('BelajarKu', style: AppTextStyles.heading.copyWith(fontSize: 32))
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.3, end: 0, delay: 300.ms, duration: 500.ms),

            const SizedBox(height: 32),

            // Baris ikon kategori kecil, muncul satu-satu (staggered)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MiniIcon(icon: Icons.abc, color: AppColors.primaryYellow, delayMs: 600),
                const SizedBox(width: 12),
                _MiniIcon(icon: Icons.piano, color: AppColors.primaryPink, delayMs: 750),
                const SizedBox(width: 12),
                _MiniIcon(icon: Icons.edit, color: AppColors.primaryBlue, delayMs: 900),
                const SizedBox(width: 12),
                _MiniIcon(icon: Icons.menu_book, color: AppColors.primaryPurple, delayMs: 1050),
              ],
            ),

            const SizedBox(height: 40),

            // Loading indicator kecil di bawah
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryPink),
              ),
            ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int delayMs;

  const _MiniIcon({
    required this.icon,
    required this.color,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 300.ms)
        .scale(
          delay: Duration(milliseconds: delayMs),
          duration: 300.ms,
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
        );
  }
}
