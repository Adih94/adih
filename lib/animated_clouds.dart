import 'dart:math';
import 'package:flutter/material.dart';

/// Widget latar langit dengan awan yang bergerak terus-menerus (looping).
/// Cara pakai:
///
/// Scaffold(
///   body: AnimatedCloudSky(
///     child: YourContent(), // opsional, konten di atas awan
///   ),
/// )
class AnimatedCloudSky extends StatefulWidget {
  final Widget? child;
  final Color skyColorTop;
  final Color skyColorBottom;

  /// Path asset gambar background, misal 'assets/images/bg_classroom.png'.
  /// Kalau diisi, gambar ini dipakai sebagai latar (gradasi warna diabaikan),
  /// dan lapisan awan animasi digambar transparan di atasnya.
  final String? backgroundImageAsset;

  const AnimatedCloudSky({
    super.key,
    this.child,
    this.skyColorTop = const Color(0xFF7EC8E3),
    this.skyColorBottom = const Color(0xFFC2E9FB),
    this.backgroundImageAsset,
  });

  @override
  State<AnimatedCloudSky> createState() => _AnimatedCloudSkyState();
}

class _AnimatedCloudSkyState extends State<AnimatedCloudSky>
    with TickerProviderStateMixin {
  late final List<_CloudLayerData> _layers;
  late final List<_BirdLayerData> _birdLayers;
  late final AnimationController _wingController;

  @override
  void initState() {
    super.initState();

    _wingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..repeat();

    // Beberapa lapisan awan dengan kecepatan & ukuran berbeda
    // agar terlihat efek kedalaman (parallax).
    _layers = [
      _CloudLayerData(
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 70),
        )..repeat(),
        cloudCount: 2,
        minScale: 0.5,
        maxScale: 0.7,
        minOpacity: 0.35,
        maxOpacity: 0.55,
        // Area langit di gambar ada di bagian atas (kira-kira 0 - 30% tinggi layar)
        minY: 0.03,
        maxY: 0.14,
        seed: 1,
      ),
      _CloudLayerData(
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 45),
        )..repeat(),
        cloudCount: 2,
        minScale: 0.6,
        maxScale: 0.85,
        minOpacity: 0.5,
        maxOpacity: 0.7,
        minY: 0.1,
        maxY: 0.22,
        seed: 2,
      ),
      _CloudLayerData(
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 90),
        )..repeat(),
        cloudCount: 1,
        minScale: 0.45,
        maxScale: 0.55,
        minOpacity: 0.25,
        maxOpacity: 0.4,
        minY: 0.02,
        maxY: 0.08,
        seed: 3,
      ),
    ];

    _birdLayers = [
      _BirdLayerData(
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 22),
        )..repeat(),
        birdCount: 2,
        minScale: 0.55,
        maxScale: 0.8,
        minY: 0.07,
        maxY: 0.16,
        seed: 11,
        direction: 1,
      ),
      _BirdLayerData(
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 32),
        )..repeat(),
        birdCount: 2,
        minScale: 0.45,
        maxScale: 0.65,
        minY: 0.12,
        maxY: 0.24,
        seed: 22,
        direction: -1,
      ),
      _BirdLayerData(
        controller: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 18),
        )..repeat(),
        birdCount: 1,
        minScale: 0.4,
        maxScale: 0.5,
        minY: 0.05,
        maxY: 0.1,
        seed: 33,
        direction: 1,
      ),
    ];
  }

  @override
  void dispose() {
    _wingController.dispose();
    for (final layer in _layers) {
      layer.controller.dispose();
    }
    for (final layer in _birdLayers) {
      layer.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Latar: gambar background kalau ada, kalau tidak pakai gradasi
        if (widget.backgroundImageAsset != null)
          Image.asset(
            widget.backgroundImageAsset!,
            fit: BoxFit.cover,
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [widget.skyColorTop, widget.skyColorBottom],
              ),
            ),
          ),

        // Lapisan-lapisan awan
        for (final layer in _layers)
          AnimatedBuilder(
            animation: layer.controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _CloudLayerPainter(
                  progress: layer.controller.value,
                  layer: layer,
                ),
              );
            },
          ),

        // Burung kecil terbang dengan sayap berkibar
        for (final layer in _birdLayers)
          AnimatedBuilder(
            animation: Listenable.merge([layer.controller, _wingController]),
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _BirdLayerPainter(
                  progress: layer.controller.value,
                  wingPhase: _wingController.value,
                  layer: layer,
                ),
              );
            },
          ),

        // Konten tambahan di atas awan (opsional)
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _CloudLayerData {
  final AnimationController controller;
  final int cloudCount;
  final double minScale;
  final double maxScale;
  final double minOpacity;
  final double maxOpacity;
  final double minY;
  final double maxY;
  final int seed;

  _CloudLayerData({
    required this.controller,
    required this.cloudCount,
    required this.minScale,
    required this.maxScale,
    required this.minOpacity,
    required this.maxOpacity,
    required this.minY,
    required this.maxY,
    required this.seed,
  });
}

class _CloudLayerPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final _CloudLayerData layer;

  _CloudLayerPainter({required this.progress, required this.layer});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(layer.seed);

    for (int i = 0; i < layer.cloudCount; i++) {
      // Setiap awan punya offset awal & kecepatan sedikit berbeda
      final randomOffset = random.nextDouble();
      final scale = layer.minScale +
          random.nextDouble() * (layer.maxScale - layer.minScale);
      final opacity = layer.minOpacity +
          random.nextDouble() * (layer.maxOpacity - layer.minOpacity);
      final relativeY = layer.minY +
          random.nextDouble() * (layer.maxY - layer.minY);

      // Posisi X bergerak dari kanan ke kiri, looping mulus
      final cloudWidth = 220.0 * scale;
      final totalTravel = size.width + cloudWidth * 2;
      final t = (progress + randomOffset) % 1.0;
      final dx = size.width + cloudWidth - t * totalTravel;
      final dy = size.height * relativeY;

      _drawCloud(
        canvas,
        Offset(dx, dy),
        scale,
        opacity,
      );
    }
  }

  void _drawCloud(Canvas canvas, Offset position, double scale, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    // Awan digambar dari beberapa lingkaran yang saling tumpuk
    final circles = [
      _CircleSpec(dx: 0, dy: 0, radius: 40),
      _CircleSpec(dx: 35, dy: -15, radius: 32),
      _CircleSpec(dx: -35, dy: -10, radius: 30),
      _CircleSpec(dx: 65, dy: 5, radius: 24),
      _CircleSpec(dx: -65, dy: 8, radius: 22),
      _CircleSpec(dx: 0, dy: -25, radius: 26),
    ];

    for (final c in circles) {
      canvas.drawCircle(
        Offset(
          position.dx + c.dx * scale,
          position.dy + c.dy * scale,
        ),
        c.radius * scale,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CloudLayerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _CircleSpec {
  final double dx;
  final double dy;
  final double radius;

  _CircleSpec({required this.dx, required this.dy, required this.radius});
}

class _BirdLayerData {
  final AnimationController controller;
  final int birdCount;
  final double minScale;
  final double maxScale;
  final double minY;
  final double maxY;
  final int seed;
  final int direction;

  _BirdLayerData({
    required this.controller,
    required this.birdCount,
    required this.minScale,
    required this.maxScale,
    required this.minY,
    required this.maxY,
    required this.seed,
    required this.direction,
  });
}

class _BirdLayerPainter extends CustomPainter {
  final double progress;
  final double wingPhase;
  final _BirdLayerData layer;

  _BirdLayerPainter({
    required this.progress,
    required this.wingPhase,
    required this.layer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(layer.seed);

    for (int i = 0; i < layer.birdCount; i++) {
      final randomOffset = random.nextDouble();
      final scale = layer.minScale +
          random.nextDouble() * (layer.maxScale - layer.minScale);
      final relativeY =
          layer.minY + random.nextDouble() * (layer.maxY - layer.minY);
      final flapOffset = random.nextDouble();

      final birdWidth = 28.0 * scale;
      final totalTravel = size.width + birdWidth * 2;
      final t = (progress + randomOffset) % 1.0;

      final dx = layer.direction > 0
          ? -birdWidth + t * totalTravel
          : size.width + birdWidth - t * totalTravel;
      final dy = size.height * relativeY;

      _drawBird(
        canvas,
        Offset(dx, dy),
        scale,
        wingPhase + flapOffset,
        layer.direction,
      );
    }
  }

  void _drawBird(
    Canvas canvas,
    Offset center,
    double scale,
    double phase,
    int direction,
  ) {
    final flap = sin(phase * 2 * pi);
    final wingLift = (4 + flap * 5) * scale;
    final dir = direction.toDouble();

    final wingPaint = Paint()
      ..color = const Color(0xFF455A64).withOpacity(0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * scale
      ..strokeCap = StrokeCap.round;

    final bodyPaint = Paint()
      ..color = const Color(0xFF37474F).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final wingSpan = 11 * scale;
    final path = Path();
    path.moveTo(center.dx - wingSpan * dir, center.dy + wingLift * 0.4);
    path.quadraticBezierTo(
      center.dx - wingSpan * 0.35 * dir,
      center.dy - wingLift,
      center.dx,
      center.dy - 1.5 * scale,
    );
    path.quadraticBezierTo(
      center.dx + wingSpan * 0.35 * dir,
      center.dy - wingLift,
      center.dx + wingSpan * dir,
      center.dy + wingLift * 0.4,
    );
    canvas.drawPath(path, wingPaint);
    canvas.drawCircle(center, 2.2 * scale, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant _BirdLayerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.wingPhase != wingPhase;
  }
}

/// Contoh penggunaan langsung sebagai halaman.
class CloudDemoPage extends StatelessWidget {
  const CloudDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCloudSky(
        child: Center(
          child: Text(
            'Awan Bergerak ☁️',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
