import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final int reminderIntervalMinutes;
  final int restDurationSeconds;
  final bool enableNotification;
  final bool enableSound;
  final bool enableForceMode;

  const AppSettings({
    this.reminderIntervalMinutes = 45,
    this.restDurationSeconds = 300,
    this.enableNotification = true,
    this.enableSound = true,
    this.enableForceMode = false,
  });

  AppSettings copyWith({
    int? reminderIntervalMinutes,
    int? restDurationSeconds,
    bool? enableNotification,
    bool? enableSound,
    bool? enableForceMode,
  }) {
    return AppSettings(
      reminderIntervalMinutes: reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      restDurationSeconds: restDurationSeconds ?? this.restDurationSeconds,
      enableNotification: enableNotification ?? this.enableNotification,
      enableSound: enableSound ?? this.enableSound,
      enableForceMode: enableForceMode ?? this.enableForceMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void updateReminderInterval(int minutes) {
    state = state.copyWith(reminderIntervalMinutes: minutes);
  }

  void updateRestDuration(int seconds) {
    state = state.copyWith(restDurationSeconds: seconds);
  }

  void toggleNotification(bool enabled) {
    state = state.copyWith(enableNotification: enabled);
  }

  void toggleSound(bool enabled) {
    state = state.copyWith(enableSound: enabled);
  }

  void toggleForceMode(bool enabled) {
    state = state.copyWith(enableForceMode: enabled);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});
