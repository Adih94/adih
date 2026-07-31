import 'package:flutter/material.dart';

/// Model untuk satu contoh kata di modul "Belajar Membaca".
/// Contoh: syllables = ["bo", "la"], word = "bola".
class ReadingWordModel {
  final String word;
  final List<String> syllables;
  final IconData icon; // ikon sederhana yang mewakili arti kata

  const ReadingWordModel({
    required this.word,
    required this.syllables,
    required this.icon,
  });
}
