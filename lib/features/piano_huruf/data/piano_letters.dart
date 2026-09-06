import 'package:flutter/material.dart';

import '../models/letter_item.dart';

const _words = <String>[
  'APEL', 'BOLA', 'CERI', 'DASI', 'ES KRIM', 'FOTO', 'GAJAH',
  'HARIMAU', 'IKAN', 'JERUK', 'KUCING', 'LAMPU', 'MANGGA', 'NANAS',
  'ORANG', 'PISANG', 'QUEEN', 'ROTI', 'SAPI', 'TOPI', 'ULAR', 'VAS',
  'WORTEL', 'XILOFON', 'YOYO', 'ZEBRA',
];

const _emojis = <String>[
  '🍎', '⚽', '🍒', '👔', '🍦', '📷', '🐘', '🐯', '🐟', '🍊', '🐱',
  '💡', '🥭', '🍍', '🧑', '🍌', '👑', '🍞', '🐄', '🎩', '🐍', '🏺',
  '🥕', '🎹', '🪀', '🦓',
];

const _colors = <Color>[
  Color(0xFFFF7E73), Color(0xFFFFB83F), Color(0xFFFFDF45),
  Color(0xFF74C95C), Color(0xFF56BDEB), Color(0xFF9B75E8),
  Color(0xFFE882BE),
];

/// Complete A-Z data. Each letter uses the bundled matching `letter_x.png`.
final pianoLetters = List<LetterItem>.generate(26, (index) {
  final key = String.fromCharCode(97 + index);
  return LetterItem(
    id: key,
    letter: key.toUpperCase(),
    word: _words[index],
    emoji: _emojis[index],
    letterAsset: 'assets/images/letter_$key.png',
    illustrationAsset: 'assets/images/illus_$key.png',
    voiceAsset: 'audio/letters/$key.mp3',
    pianoAsset: 'audio/piano/$key.wav',
    color: _colors[index % _colors.length],
  );
});
