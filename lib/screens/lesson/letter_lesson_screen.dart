import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../widgets/bounce_tap.dart';

/// Aktivitas pengenalan huruf dengan contoh kata yang sesuai.
class LetterLessonScreen extends StatefulWidget {
  const LetterLessonScreen({super.key});

  @override
  State<LetterLessonScreen> createState() => _LetterLessonScreenState();
}

class _LetterLessonScreenState extends State<LetterLessonScreen> {
  late final FlutterTts _tts;
  int _letterIndex = 0;

  static const _letters = [
    _LetterActivity(
      letter: 'A',
      word: 'apel',
      imageAsset: 'assets/images/letter_a_activity.png',
    ),
    _LetterActivity(
      letter: 'B',
      word: 'beruang',
      imageAsset: 'assets/images/letter_b_activity.png',
    ),
  ];

  _LetterActivity get _currentLetter => _letters[_letterIndex];

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.setLanguage('id-ID');
    _tts.setSpeechRate(0.35);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakCurrentLetter() async {
    await _tts.stop();
    await _tts.speak(
      '${_currentLetter.letter}. '
      '${_currentLetter.letter} seperti ${_currentLetter.word}',
    );
  }

  void _showPreviousLetter() {
    if (_letterIndex == 0) return;
    setState(() => _letterIndex--);
  }

  void _showNextLetter() {
    if (_letterIndex >= _letters.length - 1) return;
    setState(() => _letterIndex++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / 1600;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _currentLetter.imageAsset,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 42 * scale,
                top: 48 * scale,
                child: BounceTap(
                  semanticLabel: 'Kembali',
                  onTap: () => Navigator.of(context).maybePop(),
                  child: _RoundActionButton(
                    size: 106 * scale,
                    color: const Color(0xFF7452E8),
                    icon: Icons.home_rounded,
                  ),
                ),
              ),
              Positioned(
                right: 170 * scale,
                top: 49 * scale,
                child: BounceTap(
                  semanticLabel: 'Dengarkan huruf ${_currentLetter.letter}',
                  onTap: _speakCurrentLetter,
                  child: _SoundButton(scale: scale),
                ),
              ),
              Positioned(
                left: 50 * scale,
                top: 378 * scale,
                child: BounceTap(
                  semanticLabel: 'Huruf sebelumnya',
                  onTap: _showPreviousLetter,
                  child: _RoundActionButton(
                    size: 112 * scale,
                    color: const Color(0xFFFFB82E),
                    icon: Icons.arrow_back_rounded,
                  ),
                ),
              ),
              Positioned(
                right: 48 * scale,
                top: 378 * scale,
                child: BounceTap(
                  semanticLabel: 'Huruf berikutnya',
                  onTap: _showNextLetter,
                  child: _RoundActionButton(
                    size: 112 * scale,
                    color: const Color(0xFFFFB82E),
                    icon: Icons.arrow_forward_rounded,
                  ),
                ),
              ),
              Positioned(
                left: 290 * scale,
                top: 165 * scale,
                width: 400 * scale,
                height: 430 * scale,
                child: BounceTap(
                  semanticLabel: 'Huruf ${_currentLetter.letter}',
                  onTap: _speakCurrentLetter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8BC93B).withOpacity(0.16),
                          blurRadius: 22 * scale,
                          spreadRadius: 4 * scale,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LetterActivity {
  final String letter;
  final String word;
  final String imageAsset;

  const _LetterActivity({
    required this.letter,
    required this.word,
    required this.imageAsset,
  });
}

class _RoundActionButton extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;

  const _RoundActionButton({
    required this.size,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: size * 0.06),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}

class _SoundButton extends StatelessWidget {
  final double scale;

  const _SoundButton({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112 * scale,
      height: 98 * scale,
      decoration: BoxDecoration(
        color: const Color(0xFF9ACA3C),
        borderRadius: BorderRadius.circular(22 * scale),
        border: Border.all(color: Colors.white, width: 4 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10 * scale,
            offset: Offset(0, 5 * scale),
          ),
        ],
      ),
      child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 52 * scale),
    );
  }
}
