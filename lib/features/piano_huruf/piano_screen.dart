import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../animated_clouds.dart';
import '../../widgets/star_burst_effect.dart';
import 'audio/audio_manager.dart';
import 'data/piano_letters.dart';
import 'game/game_manager.dart';
import 'models/letter_item.dart';

/// A toy-piano scene based on the pink character piano reference.
class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen>
    with SingleTickerProviderStateMixin {
  final _audio = AudioManager(
    backgroundMusicAsset: 'audio/music/background_01.mp3',
  );
  final _game = GameManager();
  late final AnimationController _starController;
  int _firstVisibleIndex = 0;

  List<LetterItem> get _visibleLetters => pianoLetters
      .skip(_firstVisibleIndex)
      .take(12)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _audio.startBackgroundMusic();
  }

  @override
  void dispose() {
    _starController.dispose();
    _audio.dispose();
    _game.dispose();
    super.dispose();
  }

  void _press(LetterItem item, int slot) {
    _game.press(item);
    _starController.forward(from: 0);
    _audio.playLetter(item);

    // Pressing L changes the first key from A to M; the next page is M-X.
    if (slot == _visibleLetters.length - 1) {
      Future<void>.delayed(const Duration(milliseconds: 190), () {
        if (!mounted) return;
        setState(() {
          _firstVisibleIndex = _firstVisibleIndex + 12 >= pianoLetters.length
              ? 0
              : _firstVisibleIndex + 12;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AnimatedCloudSky(
          backgroundImageAsset: 'assets/images/bg_menu.png',
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 14,
                  top: 10,
                  child: _HomeButton(
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 42, 18, 12),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_game, _starController]),
                      builder: (context, _) => _PinkToyPiano(
                        active: _game.selectedLetter ?? pianoLetters.first,
                        visibleLetters: _visibleLetters,
                        starProgress: _starController.value,
                        onPressed: _press,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _PinkToyPiano extends StatelessWidget {
  final LetterItem active;
  final List<LetterItem> visibleLetters;
  final double starProgress;
  final void Function(LetterItem item, int slot) onPressed;

  const _PinkToyPiano({
    required this.active,
    required this.visibleLetters,
    required this.starProgress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 2.9,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(44),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF82BE), Color(0xFFE41B74)],
              ),
              border: Border.all(color: const Color(0xFFFFB5D8), width: 3),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final unit = constraints.maxHeight;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _Ear(left: true, size: unit * .27),
                    _Ear(left: false, size: unit * .27),
                    Positioned(
                      left: unit * .14,
                      right: unit * .14,
                      top: unit * .09,
                      height: unit * .38,
                      child: _FaceHeader(
                        active: active,
                        starProgress: starProgress,
                      ),
                    ),
                    Positioned(
                      left: unit * .14,
                      right: unit * .14,
                      bottom: unit * .12,
                      height: unit * .39,
                      child: _Keyboard(
                        letters: visibleLetters,
                        onPressed: onPressed,
                      ),
                    ),
                    Positioned(
                      right: unit * .035,
                      bottom: unit * .22,
                      child: _MusicButton(size: unit * .20),
                    ),
                    Positioned(
                      left: unit * .08,
                      top: unit * .31,
                      child: const Text('⭐', style: TextStyle(fontSize: 26)),
                    ),
                    Positioned(
                      right: unit * .08,
                      top: unit * .30,
                      child: const Text('🎵', style: TextStyle(fontSize: 25)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}

class _FaceHeader extends StatelessWidget {
  final LetterItem active;
  final double starProgress;

  const _FaceHeader({required this.active, required this.starProgress});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9BCB),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: const Color(0xFFFFC5E0), width: 3),
        ),
        child: Row(
          children: [
            const Expanded(child: _HappyFace()),
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  _ActiveLetter(letterAsset: active.letterAsset),
                  StarBurstEffect(progress: starProgress),
                ],
              ),
            ),
            const Expanded(flex: 2, child: _RewardPanel()),
          ],
        ),
      );
}

class _ActiveLetter extends StatelessWidget {
  final String letterAsset;
  const _ActiveLetter({required this.letterAsset});

  @override
  Widget build(BuildContext context) => Container(
        width: 58,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF90CE3C),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(color: Color(0xFF6B9D27), offset: Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(letterAsset, fit: BoxFit.contain),
        ),
      );
}

class _HappyFace extends StatelessWidget {
  const _HappyFace();
  @override
  Widget build(BuildContext context) => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text('●', style: TextStyle(fontSize: 20)), Text('◡', style: TextStyle(fontSize: 30))],
      );
}

class _RewardPanel extends StatelessWidget {
  const _RewardPanel();
  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFE83A84),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFFFB7D7), width: 2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text('★★★★★', style: TextStyle(fontSize: 11, color: Colors.white)), Text('💛💛💛💛💛', style: TextStyle(fontSize: 10))],
        ),
      );
}

class _Keyboard extends StatefulWidget {
  final List<LetterItem> letters;
  final void Function(LetterItem item, int slot) onPressed;
  const _Keyboard({required this.letters, required this.onPressed});

  @override
  State<_Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<_Keyboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  int? _pressedSlot;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _tap(int slot) {
    setState(() => _pressedSlot = slot);
    _bounceController.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _pressedSlot = null);
    });
    widget.onPressed(widget.letters[slot], slot);
  }

  double _scaleFor(int slot) {
    if (_pressedSlot != slot) return 1;
    final progress = _bounceController.value;
    if (progress < .35) return 1 - .08 * (progress / .35);
    if (progress < .68) return .92 + .13 * ((progress - .35) / .33);
    return 1.05 - .05 * ((progress - .68) / .32);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _bounceController,
        builder: (context, _) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF741142),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Row(
                children: List.generate(
                  widget.letters.length,
                  (_) => Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFAF2),
                        border: Border(
                          right: BorderSide(color: Color(0xFFD8BBC4)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(widget.letters.length, (index) => Expanded(
                  child: Transform.scale(
                    alignment: Alignment.bottomCenter,
                    scale: _scaleFor(index),
                    child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _tap(index),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          widget.letters[index].letter,
                          style: const TextStyle(
                            color: Color(0xFF9B5875),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    ),
                  ),
                )),
              ),
              ...[0, 1, 3, 4, 5, 7, 8, 10].map((keyIndex) {
                final keyWidth = constraints.maxWidth / widget.letters.length;
                return Positioned(
                  left: keyWidth * (keyIndex + 1) - keyWidth * .23,
                  top: 0,
                  width: keyWidth * .46,
                  height: constraints.maxHeight * .57,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF251B22),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        ),
      );
}

class _Ear extends StatelessWidget {
  final bool left;
  final double size;
  const _Ear({required this.left, required this.size});
  @override
  Widget build(BuildContext context) => Positioned(
        left: left ? size * .12 : null,
        right: left ? null : size * .12,
        top: -size * .02,
        child: Container(width: size, height: size, decoration: BoxDecoration(color: const Color(0xFFFF6EAF), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFB6DB), width: 4))),
      );
}

class _MusicButton extends StatelessWidget {
  final double size;
  const _MusicButton({required this.size});
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(color: const Color(0xFFFFD62B), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFF8FBC), width: 3)), child: const Icon(Icons.music_note_rounded, color: Color(0xFFE92E82)));
}

class _HomeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HomeButton({required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, child: const CircleAvatar(radius: 22, backgroundColor: Color(0xFFFFB32C), child: Icon(Icons.home_rounded, color: Colors.white)));
}
