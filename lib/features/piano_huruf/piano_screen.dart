import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../animated_clouds.dart';
import 'audio/audio_manager.dart';
import 'data/piano_letters.dart';
import 'game/game_manager.dart';
import 'models/letter_item.dart';
import 'widgets/piano_key.dart';

/// Free-play piano stage that feels like a colourful toy, not an adult piano.
class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  final _audio = AudioManager(
    backgroundMusicAsset: 'audio/music/background_01.mp3',
  );
  final _game = GameManager();

  @override
  void initState() {
    super.initState();
    _audio.startBackgroundMusic();
  }

  @override
  void dispose() {
    _audio.dispose();
    _game.dispose();
    super.dispose();
  }

  void _onKeyPressed(LetterItem item) {
    _game.press(item);
    _audio.playLetter(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCloudSky(
        backgroundImageAsset: 'assets/images/bg_menu.png',
        child: SafeArea(child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 500;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 10 : 20,
                compact ? 6 : 12,
                compact ? 10 : 20,
                compact ? 8 : 16,
              ),
              child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _RoundButton(
                    icon: Icons.home_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                    size: compact ? 43 : 58,
                  ),
                ),
                const SizedBox(height: 2),
                _PianoHero(compact: compact),
                SizedBox(height: compact ? 4 : 8),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _game,
                    builder: (context, _) => _WoodenPiano(
                      selectedId: _game.selectedLetter?.id,
                      onPressed: _onKeyPressed,
                      compact: compact,
                    ),
                  ),
                ),
              ],
            ),
            );
          },
        )),
      ),
    );
  }
}

class _PianoHero extends StatelessWidget {
  final bool compact;

  const _PianoHero({required this.compact});

  @override
  Widget build(BuildContext context) {
    final scale = compact ? .62 : 1.0;
    return SizedBox(
      height: 138 * scale,
      child: ClipRect(
        child: Transform.scale(
          alignment: Alignment.topCenter,
          scale: scale,
          child: SizedBox(
            height: 138,
            child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 20,
            bottom: -20,
            child: Text('🐻', style: TextStyle(fontSize: 116)),
          ),
          Container(
            width: 390,
            padding: const EdgeInsets.fromLTRB(30, 9, 30, 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFC97B32), Color(0xFF925022)],
              ),
              border: Border.all(color: const Color(0xFFFFC45A), width: 5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Piano',
                  style: GoogleFonts.baloo2(
                    color: const Color(0xFFFFC733),
                    fontSize: 53,
                    height: .78,
                    fontWeight: FontWeight.w800,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF713315),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Huruf',
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 51,
                    height: .98,
                    fontWeight: FontWeight.w800,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF1776B9),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2D7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tekan tombol, dengar suaranya!',
                    style: GoogleFonts.baloo2(
                      color: const Color(0xFF84461F),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 32,
            top: 44,
            child: Transform.rotate(
              angle: .18,
              child: const Text('🎵', style: TextStyle(fontSize: 48)),
            ),
          ),
          const Positioned(
            left: 130,
            top: 58,
            child: Text('🎶', style: TextStyle(fontSize: 33)),
          ),
        ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WoodenPiano extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<LetterItem> onPressed;
  final bool compact;

  const _WoodenPiano({
    required this.selectedId,
    required this.onPressed,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        compact ? 8 : 18,
        compact ? 10 : 26,
        compact ? 8 : 18,
        compact ? 7 : 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(42),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF6B460), Color(0xFFBD6628)],
        ),
        border: Border.all(color: const Color(0xFF8C441B), width: 5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 11,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 620 ? 3 : 5;
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pianoLetters.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: compact ? 6 : 10,
                    childAspectRatio: compact ? 1.14 : columns == 5 ? .70 : .96,
                  ),
                  itemBuilder: (context, index) {
                    final item = pianoLetters[index];
                    return PianoKey(
                      item: item,
                      isSelected: selectedId == item.id,
                      onPressed: onPressed,
                    );
                  },
                );
              },
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 7),
            const _StarBadge(),
          ],
        ],
      ),
    );
  }
}

class _StarBadge extends StatelessWidget {
  const _StarBadge();

  @override
  Widget build(BuildContext context) => Container(
        width: 128,
        height: 33,
        decoration: BoxDecoration(
          color: const Color(0xFF9B4F23),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: const Text('✦  ⭐  ✦', style: TextStyle(fontSize: 19)),
      );
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _RoundButton({
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE369), Color(0xFFFF9F1F)],
            ),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Icon(icon, color: Colors.white, size: size * .58),
        ),
      );
}
