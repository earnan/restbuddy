import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../../models/user_settings.dart';
import '../../models/rest_record.dart';
import '../../models/daily_statistics.dart';
import '../../../domain/enums/rest_status.dart';

class IsarService {
  static late Isar _isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UserSettingsSchema, RestRecordSchema, DailyStatisticsSchema],
      directory: dir.path,
    );
    debugPrint('Isar initialized at: ${dir.path}');
  }

  static Isar get instance => _isar;

  // ========== 用户设置 ==========

  static Future<UserSettings> getSettings() async {
    var settings = await _isar.userSettings.where().findFirst();
    if (settings == null) {
      settings = UserSettings.defaults();
      await _isar.writeTxn(() => _isar.userSettings.put(settings!));
    }
    return settings;
  }

  static Future<void> saveSettings(UserSettings settings) async {
    settings.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.userSettings.put(settings));
  }

  // ========== 休息记录 ==========

  static Future<void> addRecord(RestRecord record) async {
    await _isar.writeTxn(() => _isar.restRecords.put(record));
  }

  static Future<List<RestRecord>> getRecordsByDateRange(DateTime start, DateTime end) async {
    return await _isar.restRecords
        .filter()
        .startTimeBetween(start, end)
        .sortByStartTime()
        .findAll();
  }

  static Future<List<RestRecord>> getTodayRecords() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getRecordsByDateRange(start, end);
  }

  static Future<List<RestRecord>> getWeekRecords() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getRecordsByDateRange(start, end);
  }

  static Future<List<RestRecord>> getMonthRecords() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return getRecordsByDateRange(start, end);
  }

  // ========== 统计数据 ==========

  static Future<DailyStatistics> getOrCreateDailyStats(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    var stats = await _isar.dailyStatistics
        .filter()
        .dateEqualTo(dateOnly)
        .findFirst();

    if (stats == null) {
      stats = DailyStatistics()
        ..date = dateOnly
        ..totalRestCount = 0
        ..completedCount = 0
        ..skippedCount = 0
        ..totalRestSeconds = 0
        ..workSeconds = 0
        ..completionRate = 0.0
        ..hourlyRestCounts = List.filled(24, 0);
      await _isar.writeTxn(() => _isar.dailyStatistics.put(stats!));
    }
    return stats;
  }

  static Future<void> updateDailyStats(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final records = await getTodayRecords();

    var stats = await getOrCreateDailyStats(date);
    stats.totalRestCount = records.length;
    stats.completedCount = records.where((r) => r.status == RestStatus.completed).length;
    stats.skippedCount = records.where((r) => r.status == RestStatus.skipped || r.status == RestStatus.forceSkipped).length;
    stats.totalRestSeconds = records.fold<int>(0, (sum, r) => sum + r.actualDurationSeconds);
    stats.completionRate = stats.totalRestCount > 0
        ? (stats.completedCount / stats.totalRestCount * 100)
        : 0.0;

    // 按小时统计
    final hourly = List.filled(24, 0);
    for (final record in records) {
      hourly[record.startTime.hour]++;
    }
    stats.hourlyRestCounts = hourly;

    await _isar.writeTxn(() => _isar.dailyStatistics.put(stats));
  }

  static Future<List<DailyStatistics>> getWeekStatistics() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return await _isar.dailyStatistics
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();
  }

  static Future<List<DailyStatistics>> getMonthStatistics() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return await _isar.dailyStatistics
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();
  }
}
