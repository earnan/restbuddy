import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sources/local/isar_service.dart';
import '../../data/models/user_settings.dart';

class AppSettings {
  final int reminderIntervalMinutes;
  final int restDurationSeconds;
  final bool enableNotification;
  final bool enableSound;
  final bool enableForceMode;
  final String soundName;
  final int soundDurationSeconds;
  final String? jianguoyunUsername;
  final String? jianguoyunPassword;

  const AppSettings({
    this.reminderIntervalMinutes = 45,
    this.restDurationSeconds = 300,
    this.enableNotification = true,
    this.enableSound = true,
    this.enableForceMode = false,
    this.soundName = 'gentle_bell',
    this.soundDurationSeconds = 5,
    this.jianguoyunUsername,
    this.jianguoyunPassword,
  });

  AppSettings copyWith({
    int? reminderIntervalMinutes,
    int? restDurationSeconds,
    bool? enableNotification,
    bool? enableSound,
    bool? enableForceMode,
    String? soundName,
    int? soundDurationSeconds,
    String? jianguoyunUsername,
    String? jianguoyunPassword,
  }) {
    return AppSettings(
      reminderIntervalMinutes: reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      restDurationSeconds: restDurationSeconds ?? this.restDurationSeconds,
      enableNotification: enableNotification ?? this.enableNotification,
      enableSound: enableSound ?? this.enableSound,
      enableForceMode: enableForceMode ?? this.enableForceMode,
      soundName: soundName ?? this.soundName,
      soundDurationSeconds: soundDurationSeconds ?? this.soundDurationSeconds,
      jianguoyunUsername: jianguoyunUsername ?? this.jianguoyunUsername,
      jianguoyunPassword: jianguoyunPassword ?? this.jianguoyunPassword,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadFromDatabase();
  }

  Future<void> _loadFromDatabase() async {
    final settings = await IsarService.getSettings();
    state = AppSettings(
      reminderIntervalMinutes: settings.reminderIntervalMinutes,
      restDurationSeconds: settings.restDurationSeconds,
      enableNotification: settings.enableNotification,
      enableSound: settings.enableSound,
      enableForceMode: settings.enableForceMode,
      soundName: settings.soundName,
      soundDurationSeconds: settings.soundDurationSeconds,
      jianguoyunUsername: settings.jianguoyunUsername,
      jianguoyunPassword: settings.jianguoyunPassword,
    );
  }

  Future<void> _saveToDatabase() async {
    final settings = await IsarService.getSettings();
    settings
      ..reminderIntervalMinutes = state.reminderIntervalMinutes
      ..restDurationSeconds = state.restDurationSeconds
      ..enableNotification = state.enableNotification
      ..enableSound = state.enableSound
      ..enableForceMode = state.enableForceMode
      ..soundName = state.soundName
      ..soundDurationSeconds = state.soundDurationSeconds
      ..jianguoyunUsername = state.jianguoyunUsername
      ..jianguoyunPassword = state.jianguoyunPassword
      ..updatedAt = DateTime.now();
    await IsarService.saveSettings(settings);
  }

  void updateReminderInterval(int minutes) {
    state = state.copyWith(reminderIntervalMinutes: minutes);
    _saveToDatabase();
  }

  void updateRestDuration(int seconds) {
    state = state.copyWith(restDurationSeconds: seconds);
    _saveToDatabase();
  }

  void toggleNotification(bool enabled) {
    state = state.copyWith(enableNotification: enabled);
    _saveToDatabase();
  }

  void toggleSound(bool enabled) {
    state = state.copyWith(enableSound: enabled);
    _saveToDatabase();
  }

  void toggleForceMode(bool enabled) {
    state = state.copyWith(enableForceMode: enabled);
    _saveToDatabase();
  }

  void updateSoundDuration(int seconds) {
    state = state.copyWith(soundDurationSeconds: seconds);
    _saveToDatabase();
  }

  void updateJianguoyun(String username, String password) {
    state = state.copyWith(
      jianguoyunUsername: username.isEmpty ? null : username,
      jianguoyunPassword: password.isEmpty ? null : password,
    );
    _saveToDatabase();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});
