import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Efek ledakan bintang seperti buka kado surprise —
/// flash di tengah + bintang meledak ke segala arah + confetti kecil.
class StarBurstEffect extends StatelessWidget {
  final double progress; // 0.0 - 1.0

  const StarBurstEffect({super.key, required this.progress});

  static const int _starCount = 12;
  static const List<Color> _starColors = [
    AppColors.primaryYellow,
    AppColors.primaryPink,
    Colors.white,
    AppColors.primaryOrange,
    AppColors.primaryPurple,
  ];

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final flashOpacity = progress < 0.25
        ? (1.0 - progress / 0.25).clamp(0.0, 1.0)
        : 0.0;
    final flashScale = 0.5 + progress * 2.5;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Flash putih/kuning di tengah saat pertama kali ditekan
        Opacity(
          opacity: flashOpacity * 0.85,
          child: Transform.scale(
            scale: flashScale,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white,
                    AppColors.primaryYellow.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Bintang utama — meledak radial
        ...List.generate(_starCount, (i) {
          final angle = (2 * pi / _starCount) * i - pi / 2;
          final distance = 30 + (progress * 110);
          final dx = cos(angle) * distance;
          final dy = sin(angle) * distance;
          final starScale = 0.5 + (1.0 - progress) * 0.9;
          final rotation = progress * pi * 2 + angle;
          final color = _starColors[i % _starColors.length];
          final size = 18.0 + (i.isEven ? 8.0 : 0.0);

          return Transform.translate(
            offset: Offset(dx, dy),
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: rotation,
                child: Icon(
                  Icons.star_rounded,
                  color: color,
                  size: size * starScale,
                ),
              ),
            ),
          );
        }),

        // Confetti kecil — ring kedua, lebih cepat
        ...List.generate(8, (i) {
          final angle = (2 * pi / 8) * i + pi / 8;
          final distance = 20 + (progress * 80);
          final dx = cos(angle) * distance;
          final dy = sin(angle) * distance;
          final dotScale = 1.0 - progress;

          return Transform.translate(
            offset: Offset(dx, dy),
            child: Opacity(
              opacity: opacity * 0.9,
              child: Transform.rotate(
                angle: progress * pi * 3,
                child: Container(
                  width: 8 * dotScale,
                  height: 8 * dotScale,
                  decoration: BoxDecoration(
                    color: _starColors[(i + 2) % _starColors.length],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
