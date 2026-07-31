import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../data/models/lesson_model.dart';
import 'vip_badge.dart';

/// Card lesson dengan thumbnail opsional, animasi huruf, dan efek bounce.
class LessonCard extends StatefulWidget {
  final LessonModel lesson;
  final bool isUnlocked;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceScale;
  late final AnimationController _letterController;
  bool _isOpening = false;

  bool get _isLocked =>
      widget.lesson.vipTier != VipTier.none && !widget.isUnlocked;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1.5),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOutCubic),
    );
    _letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.lesson.showAnimatedLetters) {
      _letterController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isOpening) return;
    _isOpening = true;

    await _bounceController.forward(from: 0);
    if (!mounted) return;

    widget.onTap();
    _isOpening = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) => Transform.scale(
          scale: _bounceScale.value,
          child: child,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.lesson.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildThumbnail()),
                  _buildTitle(),
                ],
              ),
            ),
            if (widget.lesson.fileSizeLabel != null)
              Positioned(
                bottom: 46,
                right: 8,
                child: _FileSizeLabel(label: widget.lesson.fileSizeLabel!),
              ),
            if (widget.lesson.vipTier != VipTier.none)
              Positioned(
                top: 8,
                right: 8,
                child: _DownloadBadge(),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: VipBadge(tier: widget.lesson.vipTier),
            ),
            if (_isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lockOverlay,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock, color: Colors.white, size: 32),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.lesson.thumbnailAsset != null)
            Image.asset(widget.lesson.thumbnailAsset!, fit: BoxFit.cover)
          else
            Center(
              child: Icon(
                Icons.image_outlined,
                size: 48,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          if (widget.lesson.showAnimatedLetters)
            AnimatedBuilder(
              animation: _letterController,
              builder: (context, _) => Stack(
                children: [
                  _MovingLetter(
                    letter: 'A',
                    alignment: const Alignment(-0.7, -0.55),
                    progress: _letterController.value,
                    color: AppColors.primaryPink,
                    phase: 0,
                  ),
                  _MovingLetter(
                    letter: 'B',
                    alignment: const Alignment(0.62, -0.3),
                    progress: _letterController.value,
                    color: AppColors.primaryBlue,
                    phase: 1,
                  ),
                  _MovingLetter(
                    letter: 'C',
                    alignment: const Alignment(0.0, 0.54),
                    progress: _letterController.value,
                    color: AppColors.primaryYellow,
                    phase: 2,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Text(
        widget.lesson.title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.cardTitle,
      ),
    );
  }
}

class _MovingLetter extends StatelessWidget {
  final String letter;
  final Alignment alignment;
  final double progress;
  final Color color;
  final int phase;

  const _MovingLetter({
    required this.letter,
    required this.alignment,
    required this.progress,
    required this.color,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final direction = phase.isEven ? 1.0 : -1.0;
    final travel = (progress * 10 - 5) * direction;
    final turn = (progress - 0.5) * 0.16 * direction;

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(0, travel),
        child: Transform.rotate(
          angle: turn,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.92),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                letter,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FileSizeLabel extends StatelessWidget {
  final String label;

  const _FileSizeLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppTextStyles.badgeText.copyWith(fontSize: 9)),
    );
  }
}

class _DownloadBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.file_download_outlined,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
