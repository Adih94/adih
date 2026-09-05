import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../widgets/bounce_tap.dart';

/// Aktivitas pengenalan huruf A–Z.
/// Satu layout dipakai untuk semua huruf: latar sama, huruf besar & kecil,
/// serta ilustrasi contoh kata Bahasa Indonesia.
class LetterLessonScreen extends StatefulWidget {
  const LetterLessonScreen({super.key});

  @override
  State<LetterLessonScreen> createState() => _LetterLessonScreenState();
}

class _LetterLessonScreenState extends State<LetterLessonScreen> {
  late final FlutterTts _tts;
  int _letterIndex = 0;

  static const _letters = <_LetterActivity>[
    _LetterActivity(letter: 'A', word: 'Apel', imageAsset: 'assets/images/illus_a.png'),
    _LetterActivity(letter: 'B', word: 'Beruang', imageAsset: 'assets/images/illus_b.png'),
    _LetterActivity(letter: 'C', word: 'Cicak', imageAsset: 'assets/images/illus_c.png'),
    _LetterActivity(letter: 'D', word: 'Durian', imageAsset: 'assets/images/illus_d.png'),
    _LetterActivity(letter: 'E', word: 'Es Krim', imageAsset: 'assets/images/illus_e.png'),
    _LetterActivity(letter: 'F', word: 'Foto', imageAsset: 'assets/images/illus_f.png'),
    _LetterActivity(letter: 'G', word: 'Gajah', imageAsset: 'assets/images/illus_g.png'),
    _LetterActivity(letter: 'H', word: 'Harimau', imageAsset: 'assets/images/illus_h.png'),
    _LetterActivity(letter: 'I', word: 'Ikan', imageAsset: 'assets/images/illus_i.png'),
    _LetterActivity(letter: 'J', word: 'Jeruk', imageAsset: 'assets/images/illus_j.png'),
    _LetterActivity(letter: 'K', word: 'Kucing', imageAsset: 'assets/images/illus_k.png'),
    _LetterActivity(letter: 'L', word: 'Lampu', imageAsset: 'assets/images/illus_l.png'),
    _LetterActivity(letter: 'M', word: 'Mangga', imageAsset: 'assets/images/illus_m.png'),
    _LetterActivity(letter: 'N', word: 'Nanas', imageAsset: 'assets/images/illus_n.png'),
    _LetterActivity(letter: 'O', word: 'Orang', imageAsset: 'assets/images/illus_o.png'),
    _LetterActivity(letter: 'P', word: 'Pisang', imageAsset: 'assets/images/illus_p.png'),
    _LetterActivity(letter: 'Q', word: 'Queen', imageAsset: 'assets/images/illus_q.png'),
    _LetterActivity(letter: 'R', word: 'Roti', imageAsset: 'assets/images/illus_r.png'),
    _LetterActivity(letter: 'S', word: 'Sapi', imageAsset: 'assets/images/illus_s.png'),
    _LetterActivity(letter: 'T', word: 'Topi', imageAsset: 'assets/images/illus_t.png'),
    _LetterActivity(letter: 'U', word: 'Ular', imageAsset: 'assets/images/illus_u.png'),
    _LetterActivity(letter: 'V', word: 'Vas', imageAsset: 'assets/images/illus_v.png'),
    _LetterActivity(letter: 'W', word: 'Wortel', imageAsset: 'assets/images/illus_w.png'),
    _LetterActivity(letter: 'X', word: 'Xilofon', imageAsset: 'assets/images/illus_x.png'),
    _LetterActivity(letter: 'Y', word: 'Yoyo', imageAsset: 'assets/images/illus_y.png'),
    _LetterActivity(letter: 'Z', word: 'Zebra', imageAsset: 'assets/images/illus_z.png'),
  ];

  _LetterActivity get _currentLetter => _letters[_letterIndex];
  bool get _isFirst => _letterIndex == 0;
  bool get _isLast => _letterIndex >= _letters.length - 1;

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / 1600;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/bg_letter_generic.png',
                fit: BoxFit.cover,
              ),

              // Kartu utama: huruf besar-kecil + ilustrasi kata.
              Positioned(
                left: 220 * scale,
                right: 220 * scale,
                top: 250 * scale,
                bottom: 120 * scale,
                child: _LetterCard(
                  key: ValueKey(_currentLetter.letter),
                  activity: _currentLetter,
                  scale: scale,
                  onTap: _speakCurrentLetter,
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

class _LetterCard extends StatelessWidget {
  final _LetterActivity activity;
  final double scale;
  final VoidCallback onTap;

  const _LetterCard({
    super.key,
    required this.activity,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      semanticLabel: 'Huruf ${activity.letter}, ${activity.word}',
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 60 * scale,
          vertical: 40 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(48 * scale),
          border: Border.all(color: const Color(0xFFFFE08A), width: 8 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 26 * scale,
              offset: Offset(0, 12 * scale),
            ),
          ],
        ),
        child: Row(
          children: [
            // Huruf besar & kecil.
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: activity.letter,
                          style: TextStyle(
                            fontSize: 300 * scale,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF7452E8),
                            height: 1,
                          ),
                        ),
                        TextSpan(
                          text: activity.letter.toLowerCase(),
                          style: TextStyle(
                            fontSize: 300 * scale,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFF7EB3),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Garis pemisah.
            Container(
              width: 4 * scale,
              margin: EdgeInsets.symmetric(vertical: 20 * scale),
              color: const Color(0xFFFFE08A),
            ),

            // Ilustrasi + nama kata.
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8 * scale),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28 * scale),
                        child: Image.asset(
                          activity.imageAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18 * scale),
                  Text(
                    activity.word,
                    style: TextStyle(
                      fontSize: 74 * scale,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5A3EC8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
