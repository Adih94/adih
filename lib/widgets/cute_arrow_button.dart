import 'package:flutter/material.dart';

import 'bounce_tap.dart';

enum ArrowDirection { left, right }

/// Tombol navigasi berbentuk lencana yang seluruh tampilannya dibuat Flutter.
class CuteArrowButton extends StatelessWidget {
  final ArrowDirection direction;
  final VoidCallback? onTap;
  final double size;

  const CuteArrowButton({
    super.key,
    required this.direction,
    required this.onTap,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final isLeft = direction == ArrowDirection.left;
    final mainColor =
        isLeft ? const Color(0xFF78C92D) : const Color(0xFF20AEEB);
    final darkColor =
        isLeft ? const Color(0xFF369217) : const Color(0xFF087FC4);

    return BounceTap(
      onTap: onTap,
      enabled: enabled,
      semanticLabel: isLeft ? 'Sebelumnya' : 'Berikutnya',
      child: Opacity(
        opacity: enabled ? 1.0 : 0.35,
        child: SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [mainColor.withOpacity(0.82), mainColor, darkColor],
              ),
              border: Border.all(color: Colors.white, width: size * 0.055),
              boxShadow: [
                BoxShadow(
                  color: darkColor.withOpacity(0.5),
                  offset: Offset(0, size * 0.075),
                  blurRadius: size * 0.07,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(size * 0.1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.42),
                    width: size * 0.025,
                  ),
                ),
                child: Icon(
                  isLeft
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: size * 0.52,
                  shadows: const [
                    Shadow(
                      color: Color(0x55000000),
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
