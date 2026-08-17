import 'package:flutter/material.dart';

/// ============================================================
/// Animasi tap standar untuk SELURUH elemen yang bisa ditekan
/// di aplikasi ini (tombol Play, kategori, kartu lesson, tombol
/// navigasi, tombol suara, dll).
///
/// Nilai-nilai berikut adalah animasi asli tombol Play di
/// WelcomeScreen (assets/images/button_play.png): skala mengecil
/// dulu lalu memantul melewati ukuran normal sebelum menetap.
/// Disimpan di sini supaya SEMUA tombol memakai animasi yang
/// benar-benar sama persis.
/// ============================================================
const Duration kBounceTapDuration = Duration(milliseconds: 450);
const Curve kBounceTapCurve = Curves.easeOut;

/// Delay sebelum [onTap] dijalankan, supaya efek bounce sempat
/// terlihat lebih dulu (sama seperti tombol Play).
const Duration kBounceTapActionDelay = Duration(milliseconds: 280);

Animation<double> buildBounceScaleAnimation(AnimationController controller) {
  return TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1.5),
  ]).animate(
    CurvedAnimation(parent: controller, curve: kBounceTapCurve),
  );
}

/// Wrapper interaksi: bungkus widget apa pun dengan [BounceTap] agar
/// mendapat animasi memantul yang seragam saat ditekan, sama seperti
/// tombol Play di halaman Welcome.
class BounceTap extends StatefulWidget {
  final Widget child;

  /// Aksi yang dijalankan setelah animasi bounce dimulai.
  final VoidCallback? onTap;

  /// Dipanggil tepat saat bounce mulai (sebelum delay), berguna kalau
  /// ada efek tambahan lain yang perlu mulai bersamaan (mis. ledakan
  /// bintang). Opsional.
  final VoidCallback? onTapStart;

  /// Jika false, tombol tidak merespon tap sama sekali (tanpa animasi).
  final bool enabled;

  /// Label aksesibilitas untuk pembaca layar.
  final String? semanticLabel;

  const BounceTap({
    super.key,
    required this.child,
    required this.onTap,
    this.onTapStart,
    this.enabled = true,
    this.semanticLabel,
  });

  @override
  State<BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<BounceTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kBounceTapDuration,
    );
    _scale = buildBounceScaleAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isAnimating || !widget.enabled || widget.onTap == null) return;
    _isAnimating = true;

    _controller.forward(from: 0);
    widget.onTapStart?.call();

    await Future.delayed(kBounceTapActionDelay);
    if (mounted) widget.onTap!();
    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      enabled: widget.enabled,
      child: GestureDetector(
        onTap: widget.enabled ? _handleTap : null,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) => Transform.scale(
            scale: _scale.value,
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
