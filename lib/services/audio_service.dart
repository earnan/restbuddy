import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isEnabled = true;

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  static Future<void> playReminderSound(String soundName) async {
    if (!_isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/$soundName'));
    } catch (e) {
      debugPrint('Failed to play sound: $e');
    }
  }

  static Future<void> playCompletionSound() async {
    if (!_isEnabled) return;
    try {
      await _player.play(AssetSource('sounds/completion.mp3'));
    } catch (e) {
      debugPrint('Failed to play completion sound: $e');
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }

  static void dispose() {
    _player.dispose();
  }
}
