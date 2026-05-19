import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/daily_statistics.dart';

final statisticsProvider = StateNotifierProvider<StatisticsNotifier, List<DailyStatistics>>((ref) {
  return StatisticsNotifier();
});

class StatisticsNotifier extends StateNotifier<List<DailyStatistics>> {
  StatisticsNotifier() : super([]) {
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    // TODO: 从 Isar 加载统计数据
  }

  Future<void> refreshStatistics() async {
    await _loadStatistics();
  }

  List<DailyStatistics> getWeekStatistics() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return state.where((stat) {
      return stat.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          stat.date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }

  List<DailyStatistics> getMonthStatistics() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return state.where((stat) {
      return stat.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          stat.date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }

  double getCompletionRate() {
    if (state.isEmpty) return 0;
    final total = state.fold<int>(0, (sum, stat) => sum + stat.totalRestCount);
    final completed = state.fold<int>(0, (sum, stat) => sum + stat.completedCount);
    if (total == 0) return 0;
    return completed / total * 100;
  }

  int getTotalRestCount() {
    return state.fold<int>(0, (sum, stat) => sum + stat.totalRestCount);
  }

  int getTotalRestSeconds() {
    return state.fold<int>(0, (sum, stat) => sum + stat.totalRestSeconds);
  }
}
