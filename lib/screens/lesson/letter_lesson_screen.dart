import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/bounce_tap.dart';

/// Aktivitas pengenalan huruf A–Z.
/// Layout & latar identik untuk semua huruf (mengikuti halaman A),
/// hanya warna huruf dan ilustrasi kata yang berbeda.
class LetterLessonScreen extends StatefulWidget {
  const LetterLessonScreen({super.key});

  @override
  State<LetterLessonScreen> createState() => _LetterLessonScreenState();
}

class _LetterLessonScreenState extends State<LetterLessonScreen> {
  final AudioPlayer _player = AudioPlayer();
  int _letterIndex = 0;
  int _playToken = 0;

  static const _words = <String>[
    'Apel', 'Beruang', 'Cicak', 'Durian', 'Es Krim', 'Foto', 'Gajah',
    'Harimau', 'Ikan', 'Jeruk', 'Kucing', 'Lampu', 'Mangga', 'Nanas',
    'Orang', 'Pisang', 'Queen', 'Roti', 'Sapi', 'Topi', 'Ular', 'Vas',
    'Wortel', 'Xilofon', 'Yoyo', 'Zebra',
  ];

  static final _letters = List<_LetterActivity>.generate(26, (i) {
    final lower = String.fromCharCode(97 + i);
    return _LetterActivity(
      key: lower,
      letter: lower.toUpperCase(),
      word: _words[i],
      letterAsset: 'assets/images/letter_$lower.png',
      imageAsset: 'assets/images/illus_$lower.png',
    );
  });

  _LetterActivity get _currentLetter => _letters[_letterIndex];
  bool get _isFirst => _letterIndex == 0;
  bool get _isLast => _letterIndex >= _letters.length - 1;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playClips(List<String> assets) async {
    final token = ++_playToken;
    await _player.stop();
    for (final asset in assets) {
      if (token != _playToken || !mounted) return;
      final done = _player.onPlayerComplete.first;
      await _player.play(AssetSource(asset));
      await done.timeout(const Duration(seconds: 4), onTimeout: () {});
    }
  }

  Future<void> _speakLetter() =>
      _playClips(['audio/letters/${_currentLetter.key}.mp3']);

  Future<void> _speakWord() =>
      _playClips(['audio/words/${_currentLetter.key}.mp3']);

  Future<void> _speakCurrentLetter() => _playClips([
        'audio/letters/${_currentLetter.key}.mp3',
        'audio/words/${_currentLetter.key}.mp3',
      ]);

  void _showPreviousLetter() {
    if (_isFirst) return;
    setState(() => _letterIndex--);
    _speakCurrentLetter();
  }

  void _showNextLetter() {
    if (_isLast) return;
    setState(() => _letterIndex++);
    _speakCurrentLetter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _LetterStage.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / 1600;
          final stageScale = [
            constraints.maxWidth / _LetterStage.stageWidth,
            constraints.maxHeight / _LetterStage.stageHeight,
          ].reduce((a, b) => a > b ? a : b);

          return Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: SizedBox(
                    width: _LetterStage.stageWidth * stageScale,
                    height: _LetterStage.stageHeight * stageScale,
                    child: _LetterStage(
                      key: ValueKey(_currentLetter.letter),
                      activity: _currentLetter,
                      onLetterTap: _speakLetter,
                      onWordTap: _speakWord,
                    ),
                  ),
                ),
              ),

              // Tombol Home (kiri atas).
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

              // Tombol suara (kanan atas).
              Positioned(
                right: 48 * scale,
                top: 49 * scale,
                child: BounceTap(
                  semanticLabel: 'Dengarkan huruf ${_currentLetter.letter}',
                  onTap: _speakCurrentLetter,
                  child: _SoundButton(scale: scale),
                ),
              ),

              // Tombol huruf sebelumnya.
              Positioned(
                left: 50 * scale,
                top: constraints.maxHeight / 2 - 56 * scale,
                child: BounceTap(
                  semanticLabel: 'Huruf sebelumnya',
                  onTap: _showPreviousLetter,
                  child: Opacity(
                    opacity: _isFirst ? 0.4 : 1,
                    child: _RoundActionButton(
                      size: 112 * scale,
                      color: const Color(0xFFFFB82E),
                      icon: Icons.arrow_back_rounded,
                    ),
                  ),
                ),
              ),

              // Tombol huruf berikutnya.
              Positioned(
                right: 48 * scale,
                top: constraints.maxHeight / 2 - 56 * scale,
                child: BounceTap(
                  semanticLabel: 'Huruf berikutnya',
                  onTap: _showNextLetter,
                  child: Opacity(
                    opacity: _isLast ? 0.4 : 1,
                    child: _RoundActionButton(
                      size: 112 * scale,
                      color: const Color(0xFFFFB82E),
                      icon: Icons.arrow_forward_rounded,
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

/// Panggung berukuran tetap (mengikuti gambar latar 1809x869) sehingga
/// posisi huruf, tanda "=", ilustrasi, dan label selalu sama di semua huruf.
class _LetterStage extends StatelessWidget {
  static const double stageWidth = 1809;
  static const double stageHeight = 869;
  static const Color backgroundColor = Color(0xFFF6F4FC);

  final _LetterActivity activity;
  final VoidCallback onLetterTap;
  final VoidCallback onWordTap;

  const _LetterStage({
    super.key,
    required this.activity,
    required this.onLetterTap,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = constraints.maxWidth / stageWidth;

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/bg_letter_base.png', fit: BoxFit.fill),

            // Huruf besar (kiri).
            Positioned(
              left: 360 * s,
              top: 225 * s,
              width: 390 * s,
              height: 410 * s,
              child: BounceTap(
                semanticLabel: 'Huruf ${activity.letter}',
                onTap: onLetterTap,
                child: Image.asset(activity.letterAsset, fit: BoxFit.contain),
              ),
            ),

            // Ilustrasi kata (kanan).
            Positioned(
              left: 1040 * s,
              top: 165 * s,
              width: 450 * s,
              height: 450 * s,
              child: BounceTap(
                semanticLabel: activity.word,
                onTap: onWordTap,
                child: Image.asset(activity.imageAsset, fit: BoxFit.contain),
              ),
            ),

            // Label nama kata.
            Positioned(
              left: 1040 * s,
              width: 450 * s,
              top: 618 * s,
              child: Center(
                child: BounceTap(
                  semanticLabel: 'Kata ${activity.word}',
                  onTap: onWordTap,
                  child: _WordLabel(word: activity.word, scale: s),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WordLabel extends StatelessWidget {
  final String word;
  final double scale;

  const _WordLabel({required this.word, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 330 * scale),
      padding: EdgeInsets.symmetric(horizontal: 48 * scale, vertical: 18 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(60 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB7A8D9).withOpacity(0.45),
            blurRadius: 14 * scale,
            offset: Offset(0, 6 * scale),
          ),
        ],
      ),
      child: Text(
        word,
        textAlign: TextAlign.center,
        style: GoogleFonts.baloo2(
          fontSize: 66 * scale,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF3B2B2B),
          height: 1.1,
        ),
      ),
    );
  }
}

class _LetterActivity {
  final String key;
  final String letter;
  final String word;
  final String letterAsset;
  final String imageAsset;

  const _LetterActivity({
    required this.key,
    required this.letter,
    required this.word,
    required this.letterAsset,
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
