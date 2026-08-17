import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/welcome_to_home_route.dart';
import '../../core/utils/landscape_layout.dart';
import '../../widgets/bounce_tap.dart';

/// Halaman paling depan aplikasi: karakter menyapa + tombol play.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Karakter goyang pelan (idle sway), tanpa efek melayang
  late final AnimationController _waveController;

  // Bintang-bintang kecil berkelip di sekitar layar
  late final AnimationController _sparkleController;

  // Tombol play membesar-mengecil terus-menerus
  late final AnimationController _buttonPulseController;
  late final Animation<double> _buttonPulse;

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

    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _buttonPulse = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _buttonPulseController, curve: Curves.easeInOut),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _exitFade = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _sparkleController.dispose();
    _buttonPulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  Future<void> _goToHome() async {
    if (_isNavigating) return;
    _isNavigating = true;

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
    final characterHeight =
        (LandscapeLayout.screenHeight(context) * 0.62).clamp(110.0, 180.0);
    final buttonSize = (380 * scale).clamp(300.0, 440.0);

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                              Transform.translate(
                                offset: Offset(-150 * scale, 0),
                                child: _StandingCharacter(
                                  waveController: _waveController,
                                  height: characterHeight,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * scale),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol play berada mandiri di tengah bagian bawah layar.
          Positioned(
            left: 0,
            right: 0,
            bottom: -120 * scale,
            child: SafeArea(
              top: false,
              child: Center(
                child: AnimatedBuilder(
                  animation: _buttonPulse,
                  builder: (context, child) => Transform.scale(
                    scale: _buttonPulse.value,
                    child: child,
                  ),
                  child: BounceTap(
                    onTap: _goToHome,
                    semanticLabel: 'Mulai',
                    child: SvgPicture.asset(
                      'assets/images/button_play.svg',
                      width: buttonSize,
                      height: buttonSize,
                      fit: BoxFit.contain,
                    ),
                  ),
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
