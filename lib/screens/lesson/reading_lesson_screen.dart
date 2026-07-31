import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../animated_clouds.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/landscape_layout.dart';
import '../../data/models/reading_word_model.dart';
import '../../widgets/app_header.dart';

/// Halaman belajar membaca: tampilkan suku kata terpisah (mis. "bo" "la"),
/// tap tiap suku kata untuk dengar suaranya, lalu tap kata gabungan
/// ("bola") untuk dengar kata utuhnya.
class ReadingLessonScreen extends StatefulWidget {
  final String title;
  final List<ReadingWordModel> words;

  const ReadingLessonScreen({
    super.key,
    required this.title,
    required this.words,
  });

  @override
  State<ReadingLessonScreen> createState() => _ReadingLessonScreenState();
}

class _ReadingLessonScreenState extends State<ReadingLessonScreen> {
  late final FlutterTts _tts;
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tts = FlutterTts();
    _tts.setLanguage('id-ID');
    _tts.setSpeechRate(0.4);
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final compact = LandscapeLayout.isCompactHeight(context);
    final bottomPadding = compact ? 12.0 : 20.0;
    final navRadius = compact ? 22.0 : 28.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppHeader(
        title: widget.title,
        showVipButton: false,
        onBack: () => Navigator.of(context).maybePop(),
        onVipTap: () {
          // TODO: navigasi ke halaman VIP Offer.
        },
      ),
      body: AnimatedCloudSky(
        backgroundImageAsset: 'assets/images/bg_menu.png',
        child: Padding(
          padding: const EdgeInsets.only(top: 58),
          child: Column(
            children: [
          // Indikator progres
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.words.length, (index) {
                final isActive = index == _currentIndex;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 10 : 6,
                  height: isActive ? 10 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryGreen
                        : AppColors.primaryGreen.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.words.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return _ReadingWordPage(
                  wordData: widget.words[index],
                  onSpeak: _speak,
                );
              },
            ),
          ),

          // Navigasi manual
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(
                  icon: Icons.arrow_back_ios_new,
                  enabled: _currentIndex > 0,
                  radius: navRadius,
                  onTap: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                _NavButton(
                  icon: Icons.volume_up,
                  enabled: true,
                  color: AppColors.primaryGreen,
                  radius: navRadius,
                  onTap: () => _speak(widget.words[_currentIndex].word),
                ),
                _NavButton(
                  icon: Icons.arrow_forward_ios,
                  enabled: _currentIndex < widget.words.length - 1,
                  radius: navRadius,
                  onTap: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingWordPage extends StatelessWidget {
  final ReadingWordModel wordData;
  final void Function(String text) onSpeak;

  const _ReadingWordPage({required this.wordData, required this.onSpeak});

  @override
  Widget build(BuildContext context) {
    final screenHeight = LandscapeLayout.screenHeight(context);
    final isCompact = LandscapeLayout.isCompactHeight(context);

    final iconSize = isCompact ? 44.0 : 72.0;
    final syllableBoxSize = isCompact ? 64.0 : 90.0;
    final syllableFontSize = isCompact ? 24.0 : 32.0;
    final wordFontSize = isCompact ? 28.0 : 40.0;
    final spacingSmall = isCompact ? 8.0 : 16.0;
    final spacingMedium = isCompact ? 10.0 : 20.0;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon yang mewakili arti kata
            Icon(wordData.icon, size: iconSize, color: AppColors.primaryBlue),
            SizedBox(height: spacingSmall),

            // Suku kata terpisah, tiap kotak bisa di-tap sendiri
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < wordData.syllables.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  _SyllableBox(
                    text: wordData.syllables[i],
                    color: i.isEven
                        ? AppColors.primaryPink
                        : AppColors.primaryOrange,
                    boxSize: syllableBoxSize,
                    fontSize: syllableFontSize,
                    onTap: () => onSpeak(wordData.syllables[i]),
                  ),
                ],
              ],
            ),

            SizedBox(height: spacingMedium),
            Icon(Icons.arrow_downward,
                color: AppColors.textDark, size: isCompact ? 20 : 28),
            SizedBox(height: spacingMedium),

            // Kata gabungan (hasil akhir)
            GestureDetector(
              onTap: () => onSpeak(wordData.word),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 20 : 32,
                  vertical: isCompact ? 10 : 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  wordData.word,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: wordFontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: spacingSmall * 0.5),
            Text(
              '(Tap tiap suku kata, lalu tap kata untuk dengar semuanya)',
              textAlign: TextAlign.center,
              style: AppTextStyles.badgeText.copyWith(
                color: AppColors.textDark.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyllableBox extends StatelessWidget {
  final String text;
  final Color color;
  final double boxSize;
  final double fontSize;
  final VoidCallback onTap;

  const _SyllableBox({
    required this.text,
    required this.color,
    required this.onTap,
    this.boxSize = 90,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.heading.copyWith(
              fontSize: fontSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color? color;
  final VoidCallback onTap;
  final double radius;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.color,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: enabled
            ? (color ?? AppColors.primaryPink)
            : Colors.grey.shade300,
        child: Icon(icon, color: Colors.white, size: radius * 0.85),
      ),
    );
  }
}
