import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'persistence/local_storage_settings_persistence.dart';
import 'persistence/settings_persistence.dart';

class SettingsController extends ChangeNotifier {
  static final _log = Logger('SettingsController');

  // Persistence store for saving settings
  final SettingsPersistence _store;

  // Audio players for managing background music and sound effects
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // Settings for audio controls
  ValueNotifier<bool> audioOn = ValueNotifier(true);
  ValueNotifier<bool> soundsOn = ValueNotifier(true);
  ValueNotifier<bool> musicOn = ValueNotifier(true);
  ValueNotifier<String> playerName = ValueNotifier('Player');

  SettingsController({SettingsPersistence? store})
      : _store = store ?? LocalStorageSettingsPersistence() {
    _loadStateFromPersistence();
  }

  /// Toggles global audio (affects both music and sounds).
  void toggleAudioOn() {
    audioOn.value = !audioOn.value;
    notifyListeners();
    _store.saveAudioOn(audioOn.value);
    if (audioOn.value) {
      _resumeMusicIfNeeded();
    } else {
      _stopAllAudio();
    }
  }

  /// Toggles background music on/off.
  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    notifyListeners();
    _store.saveMusicOn(musicOn.value);
    if (musicOn.value && audioOn.value) {
      _playBackgroundMusic();
    } else {
      _stopBackgroundMusic();
    }
  }

  /// Toggles sound effects on/off.
  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    notifyListeners();
    _store.saveSoundsOn(soundsOn.value);
  }

  /// Plays background music if allowed by the settings.
  void _playBackgroundMusic() async {
    try {
      if (audioOn.value && musicOn.value) {
        await _musicPlayer.setAsset('assets/music/theme_music.mp3');
        await _musicPlayer.setLoopMode(LoopMode.all);
        await _musicPlayer.play();
      }
    } catch (e) {
      _log.severe('Error playing background music: $e');
    }
  }

  /// Resumes background music if music is toggled on and audio is allowed.
  void _resumeMusicIfNeeded() {
    if (musicOn.value) {
      _playBackgroundMusic();
    }
  }

  /// Stops background music playback.
  void _stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }

  /// Plays sound effects based on user actions.
  Future<void> playSoundEffect(String fileName) async {
    if (!audioOn.value || !soundsOn.value) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setAsset(fileName);
      await _sfxPlayer.play();
    } catch (e) {
      _log.severe('Error playing sound effect: $e');
    }
  }

  /// Stops all audio (music and sounds).
  void _stopAllAudio() async {
    await _musicPlayer.stop();
    await _sfxPlayer.stop();
  }

  /// Loads settings from persistence.
  Future<void> _loadStateFromPersistence() async {
    audioOn.value = await _store.getAudioOn(defaultValue: true);
    soundsOn.value = await _store.getSoundsOn(defaultValue: true);
    musicOn.value = await _store.getMusicOn(defaultValue: true);
    playerName.value = await _store.getPlayerName();

    if (audioOn.value && musicOn.value) {
      _playBackgroundMusic();
    }
  }
  Future<void> loadSettings() async {
    // Logic to load settings from persistence (e.g., local storage or shared preferences)
  }
  @override
  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }
}
