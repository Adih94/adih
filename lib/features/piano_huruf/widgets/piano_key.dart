import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/letter_item.dart';

class PianoKey extends StatefulWidget {
  final LetterItem item;
  final bool isSelected;
  final ValueChanged<LetterItem> onPressed;

  const PianoKey({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 105),
      reverseDuration: const Duration(milliseconds: 240),
      lowerBound: .92,
      upperBound: 1.05,
      value: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tap() {
    _controller.forward(from: .92).then((_) => _controller.reverse());
    widget.onPressed(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 105 || constraints.maxHeight < 150;
      final letterSize = compact ? 31.0 : 50.0;
      final wordSize = compact ? 10.0 : 17.0;
      final padding = compact ? 4.0 : 10.0;

      return Semantics(
        button: true,
        label: 'Huruf ${widget.item.letter}, ${widget.item.word}',
        child: GestureDetector(
          onTap: _tap,
          child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.scale(
            scale: _controller.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(widget.item.color, Colors.white, .40)!,
                  widget.item.color,
                  Color.lerp(widget.item.color, Colors.black, .17)!,
                ],
              ),
              borderRadius: BorderRadius.circular(compact ? 14 : 28),
              border: Border.all(color: Colors.white, width: compact ? 2 : 4),
              boxShadow: [
                BoxShadow(
                  color: widget.item.color.withOpacity(widget.isSelected ? .7 : .38),
                  blurRadius: widget.isSelected ? 22 : 10,
                  spreadRadius: widget.isSelected ? 3 : 0,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.item.letter,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: letterSize,
                    height: .9,
                    fontWeight: FontWeight.w800,
                    shadows: const [
                      Shadow(color: Colors.black26, offset: Offset(0, 3)),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 1 : 4),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(widget.item.emoji),
                  ),
                ),
                Text(
                  widget.item.word,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: wordSize,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      );
    });
  }
}
