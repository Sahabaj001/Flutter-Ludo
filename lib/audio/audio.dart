import 'package:just_audio/just_audio.dart';
import '/settings/settings_controller.dart';
import 'package:logging/logging.dart';

class Audio {
  static final Logger _log = Logger('Audio');
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static SettingsController? _settings;

  static void attachSettings(SettingsController settingsController) {
    _settings = settingsController;

    _settings?.audioOn.addListener(_audioOnHandler);
    _settings?.soundsOn.addListener(_soundsOnHandler);
  }


  static void _audioOnHandler() {
    if (!_settings!.audioOn.value) {
      stopSound();
    }
  }

  static void _soundsOnHandler() {
    if (!_settings!.soundsOn.value) {
      stopSound();
    }
  }

  static Future<void> playMove() async {
    await _sfxPlayer.setAsset('assets/sounds/move.wav');
    await _sfxPlayer.play();

  }

  static Future<void> playKill() async {
    await _settings?.playSoundEffect('assets/sounds/kill.wav');
  }

  static Future<void> rollDice() async {
    await _settings?.playSoundEffect('assets/sounds/roll_the_dice.mp3');
  }

  static Future<void> playFinish() async {
    await _settings?.playSoundEffect('assets/sounds/level-up.mp3');
  }

  static Future<void> dispose() async {
    await _sfxPlayer.dispose();
    _log.info('SFX audio player disposed.');
  }

  static Future<void> stopSound() async {
    try {
      await _sfxPlayer.stop();
      _log.fine('Sound effect stopped.');
    } catch (e, stack) {
      _log.severe('Error stopping sound effect: $e', e, stack);
    }
  }
}
