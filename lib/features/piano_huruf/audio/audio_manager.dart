import 'package:audioplayers/audioplayers.dart';

import '../models/letter_item.dart';

/// Keeps music, piano effects and letter voices on independent players.
///
/// Piano notes use the bundled `abc_piano_individual_A-Z/A-Z.wav` assets,
/// while voice and music remain on their own playback channels.
class AudioManager {
  static const _maximumConcurrentPianoNotes = 8;

  AudioManager({this.backgroundMusicAsset});

  final String? backgroundMusicAsset;
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _voicePlayer = AudioPlayer();
  final List<AudioPlayer> _activePianoPlayers = [];

  double _musicVolume = .30;
  double _pianoVolume = .80;
  double _voiceVolume = 1;

  Future<void> startBackgroundMusic() async {
    if (backgroundMusicAsset == null) return;
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicVolume);
    try {
      await _musicPlayer.play(AssetSource(backgroundMusicAsset!));
    } catch (_) {
      // Audio may be intentionally omitted from the first visual prototype.
    }
  }

  Future<void> playLetter(LetterItem item) async {
    // Piano is a fresh player per tap, so quick taps can overlap naturally.
    final pianoPlayer = AudioPlayer();
    if (_activePianoPlayers.length >= _maximumConcurrentPianoNotes) {
      _disposePiano(_activePianoPlayers.first);
    }
    _activePianoPlayers.add(pianoPlayer);
    await pianoPlayer.setVolume(_pianoVolume);
    pianoPlayer.onPlayerComplete.first.then((_) => _disposePiano(pianoPlayer));
    try {
      await pianoPlayer.play(AssetSource(item.pianoAsset));
    } catch (_) {
      _disposePiano(pianoPlayer);
    }

    // Piano Huruf is instrument-only: do not pronounce A/B/C on each tap.
    // The voice channel remains available for guided learning modes later.
  }

  Future<void> setMusicVolume(double value) async {
    _musicVolume = value;
    await _musicPlayer.setVolume(value);
  }

  Future<void> setPianoVolume(double value) async {
    _pianoVolume = value;
  }

  Future<void> setVoiceVolume(double value) async {
    _voiceVolume = value;
    await _voicePlayer.setVolume(value);
  }

  Future<void> pauseBackgroundMusic() => _musicPlayer.pause();
  Future<void> stopBackgroundMusic() => _musicPlayer.stop();

  void _disposePiano(AudioPlayer player) {
    _activePianoPlayers.remove(player);
    player.dispose();
  }

  void dispose() {
    for (final player in _activePianoPlayers.toList()) {
      player.dispose();
    }
    _activePianoPlayers.clear();
    _musicPlayer.dispose();
    _voicePlayer.dispose();
  }
}
