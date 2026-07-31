import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../animated_clouds.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/landscape_layout.dart';
import '../../core/utils/number_to_words_id.dart';
import '../../widgets/app_header.dart';

/// Halaman belajar angka: swipe kiri/kanan untuk pindah angka,
/// tap tombol suara (atau otomatis saat pindah halaman) untuk
/// membacakan angka dalam Bahasa Indonesia lewat Text-to-Speech.
class NumberLessonScreen extends StatefulWidget {
  final String title;
  final int startNumber;
  final int endNumber;

  const NumberLessonScreen({
    super.key,
    required this.title,
    required this.startNumber,
    required this.endNumber,
  });

  @override
  State<NumberLessonScreen> createState() => _NumberLessonScreenState();
}

class _NumberLessonScreenState extends State<NumberLessonScreen> {
  late final FlutterTts _tts;
  late final PageController _pageController;
  late int _currentNumber;

  @override
  void initState() {
    super.initState();
    _currentNumber = widget.startNumber;
    _pageController = PageController();

    _tts = FlutterTts();
    _tts.setLanguage('id-ID');
    _tts.setSpeechRate(0.4); // lebih lambat, lebih jelas untuk anak

    // Otomatis bacakan angka pertama saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrentNumber());
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _speakCurrentNumber() async {
    final words = NumberToWordsId.convert(_currentNumber);
    await _tts.stop();
    await _tts.speak(words);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentNumber = widget.startNumber + index;
    });
    _speakCurrentNumber();
  }

  @override
  Widget build(BuildContext context) {
    final totalNumbers = widget.endNumber - widget.startNumber + 1;
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
          // Indikator progres kecil di atas (bulatan-bulatan)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalNumbers, (index) {
                final isActive = index == (_currentNumber - widget.startNumber);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 10 : 6,
                  height: isActive ? 10 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryPink
                        : AppColors.primaryPink.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),

          // Konten utama: swipe angka
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalNumbers,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final number = widget.startNumber + index;
                return _NumberPage(
                  number: number,
                  words: NumberToWordsId.convert(number),
                  onTapSpeak: _speakCurrentNumber,
                );
              },
            ),
          ),

          // Tombol navigasi manual (opsional, selain swipe)
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(
                  icon: Icons.arrow_back_ios_new,
                  enabled: _currentNumber > widget.startNumber,
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
                  onTap: _speakCurrentNumber,
                ),
                _NavButton(
                  icon: Icons.arrow_forward_ios,
                  enabled: _currentNumber < widget.endNumber,
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

class _NumberPage extends StatelessWidget {
  final int number;
  final String words;
  final VoidCallback onTapSpeak;

  const _NumberPage({
    required this.number,
    required this.words,
    required this.onTapSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapSpeak,
      child: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Batasi ukuran lingkaran berdasarkan tinggi layar yang tersedia,
              // supaya di landscape (layar pendek) tetap muat tanpa terpotong.
              final screenHeight = LandscapeLayout.screenHeight(context);
              final circleSize = (screenHeight * 0.42).clamp(100.0, 200.0);
              final numberFontSize = circleSize * 0.42;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$number',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: numberFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    words,
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '(Tap angka atau tombol speaker untuk dengar suara)',
                    style: AppTextStyles.badgeText.copyWith(
                      color: AppColors.textDark.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            },
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
