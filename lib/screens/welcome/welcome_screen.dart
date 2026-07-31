import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/welcome_to_home_route.dart';
import '../../core/utils/landscape_layout.dart';

/// Halaman paling depan aplikasi: karakter menyapa + tombol "Mulai".
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Karakter goyang pelan (idle sway), tanpa efek melayang
  late final AnimationController _waveController;

  // Gelembung ucapan muncul dengan efek "pop"
  late final AnimationController _bubbleController;

  // Bintang-bintang kecil berkelip di sekitar layar
  late final AnimationController _sparkleController;

  // Tombol "Mulai" memantul saat ditekan
  late final AnimationController _buttonBounceController;
  late final Animation<double> _buttonScale;

  // Fade-out konten welcome sebelum transisi ke menu
  late final AnimationController _exitController;
  late final Animation<double> _exitFade;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _buttonBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _buttonScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1.5),
    ]).animate(
      CurvedAnimation(parent: _buttonBounceController, curve: Curves.easeOut),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _exitFade = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _bubbleController.forward();
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
    _sparkleController.dispose();
    _buttonBounceController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  Future<void> _goToHome() async {
    if (_isNavigating) return;
    _isNavigating = true;

    _buttonBounceController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    await _exitController.forward();
    if (!mounted) return;

    await Navigator.of(context).push(WelcomeToHomeRoute());
    if (mounted) {
      _isNavigating = false;
      _exitController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = LandscapeLayout.contentScale(context);
    final characterHeight = (LandscapeLayout.screenHeight(context) * 0.62)
        .clamp(110.0, 180.0);
    final buttonHeight = (64 * scale).clamp(52.0, 72.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg_library.png',
            fit: BoxFit.cover,
          ),

          ..._buildSparkles(),

          SafeArea(
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_exitFade),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _StandingCharacter(
                                waveController: _waveController,
                                height: characterHeight,
                              ),
                              SizedBox(width: 12 * scale),
                              AnimatedBuilder(
                                animation: _buttonScale,
                                builder: (context, child) => Transform.scale(
                                  scale: _buttonScale.value,
                                  child: child,
                                ),
                                child: GestureDetector(
                                  onTap: _goToHome,
                                  child: Image.asset(
                                    'assets/images/button_mulai.png',
                                    height: buttonHeight,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * scale),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _bubbleController,
                          builder: (context, child) {
                            final bubbleScale = Curves.elasticOut
                                .transform(_bubbleController.value);
                            return Opacity(
                              opacity: _bubbleController.value.clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: bubbleScale,
                                child: child,
                              ),
                            );
                          },
                          child: _SpeechBubble(
                            text:
                                'Hallo teman-teman, selamat datang di dunia belajarku, '
                                'mari belajar bersama dan semangat! 🎉',
                            fontSize: (15 * scale).clamp(12.0, 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSparkles() {
    const positions = [
      Offset(0.12, 0.15),
      Offset(0.85, 0.12),
      Offset(0.08, 0.55),
      Offset(0.9, 0.5),
      Offset(0.2, 0.8),
      Offset(0.78, 0.78),
    ];

    return List.generate(positions.length, (i) {
      final pos = positions[i];
      return Positioned(
        left: MediaQuery.of(context).size.width * pos.dx,
        top: MediaQuery.of(context).size.height * pos.dy,
        child: AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, _) {
            final phase = (i / positions.length);
            final t = (_sparkleController.value + phase) % 1.0;
            final opacity = (sin(t * pi)).clamp(0.0, 1.0);
            final scale = 0.6 + (sin(t * pi) * 0.5);
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryYellow,
                  size: 22,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

/// Karakter berdiri di lantai dengan bayangan kaki — goyang halus, tanpa melayang.
class _StandingCharacter extends StatelessWidget {
  final AnimationController waveController;
  final double height;

  const _StandingCharacter({
    required this.waveController,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, child) {
        // Hanya goyang kiri-kanan ringan, tanpa naik-turun
        final angle = (waveController.value - 0.5) * 0.06;
        return Transform.rotate(angle: angle, child: child);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/character_girl.png',
            height: height,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          // Bayangan oval di bawah kaki supaya terlihat berdiri di lantai
          Transform.translate(
            offset: const Offset(0, -6),
            child: Container(
              width: height * 0.36,
              height: height * 0.07,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gelembung ucapan putih dengan ekor kecil di bawah, berisi teks sapaan.
class _SpeechBubble extends StatelessWidget {
  final String text;
  final double fontSize;

  const _SpeechBubble({
    required this.text,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.primaryPink, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              height: 1.3,
            ),
          ),
        ),
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primaryPink, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}
