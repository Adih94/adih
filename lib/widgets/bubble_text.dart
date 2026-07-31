import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Teks bergaya "gembung" (bubble text) chunky dengan outline putih tebal
/// dan bayangan lembut, meniru gaya tombol-tombol permainan anak
/// (mis. tombol "Mulai", "Belajar", "Bermain").
class BubbleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const BubbleText({
    super.key,
    required this.text,
    this.fontSize = 32,
    this.fillColor = Colors.white,
    this.strokeColor = Colors.white,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.baloo2(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      height: 1.0,
      letterSpacing: 0.5,
    );

    return Stack(
      children: [
        // Bayangan lembut di bawah teks
        Positioned(
          top: 3,
          left: 0,
          right: 0,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(
              color: Colors.black.withOpacity(0.18),
            ),
          ),
        ),
        // Lapisan outline (stroke) putih tebal di belakang
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Lapisan isi warna di depan
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(color: fillColor),
        ),
      ],
    );
  }
}
