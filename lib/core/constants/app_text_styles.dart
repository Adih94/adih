import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Kumpulan text style. Pakai font "Baloo 2" (playful, cocok untuk anak-anak).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading => GoogleFonts.baloo2(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryPink,
      );

  static TextStyle get sectionTitle => GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  static TextStyle get cardTitle => GoogleFonts.baloo2(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );

  static TextStyle get badgeText => GoogleFonts.baloo2(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );
}
