import 'package:flutter/material.dart';

/// One playable piano key. Keeping this data outside the UI makes A-Z and
/// additional languages easy to add later.
class LetterItem {
  final String id;
  final String letter;
  final String word;
  final String emoji;
  final String letterAsset;
  final String illustrationAsset;
  final String voiceAsset;
  final String pianoAsset;
  final Color color;

  const LetterItem({
    required this.id,
    required this.letter,
    required this.word,
    required this.emoji,
    required this.letterAsset,
    required this.illustrationAsset,
    required this.voiceAsset,
    required this.pianoAsset,
    required this.color,
  });
}
