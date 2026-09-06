import 'package:flutter/material.dart';

import '../models/letter_item.dart';

/// The first complete piano row, matching the A-G learning board.
const pianoLetters = <LetterItem>[
  LetterItem(
    id: 'a', letter: 'A', word: 'AWAN', emoji: '☁️',
    illustrationAsset: 'assets/images/illus_a.png',
    voiceAsset: 'audio/letters/a.mp3', pianoAsset: 'audio/piano/a.wav',
    color: Color(0xFFFF7E73),
  ),
  LetterItem(
    id: 'b', letter: 'B', word: 'BOLA', emoji: '⚽',
    illustrationAsset: 'assets/images/illus_b.png',
    voiceAsset: 'audio/letters/b.mp3', pianoAsset: 'audio/piano/b.wav',
    color: Color(0xFFFFB83F),
  ),
  LetterItem(
    id: 'c', letter: 'C', word: 'CERI', emoji: '🍒',
    illustrationAsset: 'assets/images/illus_c.png',
    voiceAsset: 'audio/letters/c.mp3', pianoAsset: 'audio/piano/c.wav',
    color: Color(0xFF66C86F),
  ),
  LetterItem(
    id: 'd', letter: 'D', word: 'DASI', emoji: '👔',
    illustrationAsset: 'assets/images/illus_d.png',
    voiceAsset: 'audio/letters/d.mp3', pianoAsset: 'audio/piano/d.wav',
    color: Color(0xFF54B9ED),
  ),
  LetterItem(
    id: 'e', letter: 'E', word: 'ES KRIM', emoji: '🍦',
    illustrationAsset: 'assets/images/illus_e.png',
    voiceAsset: 'audio/letters/e.mp3', pianoAsset: 'audio/piano/e.wav',
    color: Color(0xFFAA83F0),
  ),
  LetterItem(
    id: 'f', letter: 'F', word: 'FOTO', emoji: '📷',
    illustrationAsset: 'assets/images/illus_f.png',
    voiceAsset: 'audio/letters/f.mp3', pianoAsset: 'audio/piano/f.wav',
    color: Color(0xFF9B75E8),
  ),
  LetterItem(
    id: 'g', letter: 'G', word: 'GAJAH', emoji: '🐘',
    illustrationAsset: 'assets/images/illus_g.png',
    voiceAsset: 'audio/letters/g.mp3', pianoAsset: 'audio/piano/g.wav',
    color: Color(0xFFE882BE),
  ),
];
