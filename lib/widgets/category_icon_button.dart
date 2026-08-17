import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import 'bounce_tap.dart';
import 'bubble_text.dart';
import 'star_burst_effect.dart';

/// Tombol kategori bergaya kartu.
/// Menampilkan efek "bounce" (memantul) dan ledakan bintang saat ditekan.
class CategoryIconButton extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const CategoryIconButton({
    super.key,
    required this.category,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  State<CategoryIconButton> createState() => _CategoryIconButtonState();
}

class _CategoryIconButtonState extends State<CategoryIconButton>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _starController;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: kBounceTapDuration,
    );

    // Animasi skala sama persis dengan tombol Play (button_play).
    _scaleAnimation = buildBounceScaleAnimation(_bounceController);

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _starController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isAnimating) return;
    _isAnimating = true;

    _bounceController.forward(from: 0);
    _starController.forward(from: 0);

    // Tunggu animasi bounce (sama seperti tombol Play) selesai sebelum navigasi
    await Future.delayed(kBounceTapActionDelay);
    if (!mounted) return;

    widget.onTap();
    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.category.color;
    final darkerColor = Color.lerp(color, Colors.black, 0.18)!;
    final lighterColor = Color.lerp(color, Colors.white, 0.25)!;
    final hasImage = widget.category.imageAsset != null;

    final boxWidth = widget.width ?? 260;
    final boxHeight = widget.height ?? 300;
    final imageWidth = boxWidth * 0.92;
    final imageHeight = boxHeight * 0.95;

    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _starController,
              builder: (context, _) => StarBurstEffect(
                progress: _starController.value,
              ),
            ),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
              child: hasImage
                  ? Image.asset(
                      widget.category.imageAsset!,
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    )
                  : _FallbackCard(
                      color: color,
                      darkerColor: darkerColor,
                      lighterColor: lighterColor,
                      category: widget.category,
                      width: imageWidth,
                      height: imageHeight,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackCard extends StatelessWidget {
  final Color color;
  final Color darkerColor;
  final Color lighterColor;
  final CategoryModel category;
  final double width;
  final double height;

  const _FallbackCard({
    required this.color,
    required this.darkerColor,
    required this.lighterColor,
    required this.category,
    this.width = 220,
    this.height = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: Colors.white, width: 6),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lighterColor, color, darkerColor],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: darkerColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 24),
              width: 70,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category.icon,
              color: Colors.white,
              size: 64,
            ),
          ),
          const SizedBox(height: 18),
          BubbleText(
            text: category.title,
            fontSize: 30,
            fillColor: Colors.white,
            strokeColor: darkerColor,
            strokeWidth: 5,
          ),
        ],
      ),
    );
  }
}
