import 'package:flutter/material.dart';

/// Tingkatan lock untuk tiap lesson/card.
enum VipTier { none, vip, platinum }

/// Model untuk satu card lesson di dalam Category Screen.
/// Contoh: "Belajar Angka 30 sampai 39".
class LessonModel {
  final String id;
  final String categoryId;
  final String title;
  final Color backgroundColor;
  final String? fileSizeLabel; // opsional, kosmetik seperti di contoh gambar
  final VipTier vipTier;
  final String? thumbnailAsset;
  final bool showAnimatedLetters;

  // Khusus lesson kategori "angka": rentang angka yang dipelajari.
  // Null kalau lesson ini bukan tipe rentang angka (mis. angka ratusan/ribuan).
  final int? numberRangeStart;
  final int? numberRangeEnd;

  const LessonModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.backgroundColor,
    this.fileSizeLabel,
    this.vipTier = VipTier.none,
    this.thumbnailAsset,
    this.showAnimatedLetters = false,
    this.numberRangeStart,
    this.numberRangeEnd,
  });
}
