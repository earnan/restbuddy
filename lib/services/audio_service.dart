import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isEnabled = true;
  static Timer? _stopTimer;

  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// 播放提醒音效，循环播放指定时长（默认5秒）
  static Future<void> playReminderSound(String soundName, {int durationSeconds = 5}) async {
    if (!_isEnabled) return;
    try {
      _stopTimer?.cancel();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('sounds/$soundName'));

      // 指定时长后停止
      _stopTimer = Timer(Duration(seconds: durationSeconds), () async {
        await _player.stop();
        await _player.setReleaseMode(ReleaseMode.release);
      });
    } catch (e) {
      debugPrint('Failed to play sound: $e');
    }
  }

  static Future<void> playCompletionSound() async {
    if (!_isEnabled) return;
    try {
      await _player.setReleaseMode(ReleaseMode.release);
      await _player.play(AssetSource('sounds/completion.mp3'));
    } catch (e) {
      debugPrint('Failed to play completion sound: $e');
    }
  }

  static Future<void> stop() async {
    _stopTimer?.cancel();
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.release);
  }

  static void dispose() {
    _stopTimer?.cancel();
    _player.dispose();
  }
}
