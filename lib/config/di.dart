import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/record_repository.dart';
import '../services/sync_service.dart';
import '../services/timer_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';
import '../services/export_service.dart';

// Repository Providers
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  return RecordRepository();
});

// Service Providers
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final timerServiceProvider = Provider<TimerService>((ref) {
  return TimerService();
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});
