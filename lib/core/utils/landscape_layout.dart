import 'package:flutter/material.dart';

/// Helper ukuran & grid untuk mode landscape (layar lebar, tinggi terbatas).
class LandscapeLayout {
  LandscapeLayout._();

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static bool isCompactHeight(BuildContext context) =>
      screenHeight(context) < 420;

  /// Jumlah kolom grid lesson berdasarkan lebar layar.
  static int lessonGridCrossAxisCount(double width) {
    if (width >= 960) return 6;
    if (width >= 760) return 5;
    if (width >= 560) return 4;
    return 3;
  }

  /// Rasio lebar:tinggi kartu lesson di landscape.
  static double lessonCardAspectRatio(BuildContext context) {
    final height = screenHeight(context);
    if (height < 360) return 1.35;
    if (height < 420) return 1.2;
    return 1.05;
  }

  /// Ukuran kartu kategori di home — muat tinggi body yang tersedia.
  static Size categoryCardSize(BoxConstraints constraints) {
    final height = (constraints.maxHeight * 0.88).clamp(130.0, 240.0);
    final width = (height * 0.86).clamp(110.0, 210.0);
    return Size(width, height);
  }

  /// Skala elemen UI di layar pendek (HP landscape).
  static double contentScale(BuildContext context) {
    final height = screenHeight(context);
    if (height < 340) return 0.72;
    if (height < 380) return 0.82;
    if (height < 420) return 0.9;
    return 1.0;
  }
}
