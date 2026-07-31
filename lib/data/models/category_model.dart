import 'package:flutter/material.dart';

/// Model untuk kategori besar di Home Screen: Huruf, Piano, Menulis.
class CategoryModel {
  final String id;
  final String title;
  final IconData icon; // fallback kalau imageAsset belum ada
  final Color color;
  /// Path asset kartu kategori penuh (sudah berisi ikon + label).
  final String? imageAsset;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.imageAsset,
  });
}
