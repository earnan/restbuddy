import 'package:isar/isar.dart';

part 'daily_statistics.g.dart';

@collection
class DailyStatistics {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late int totalRestCount;
  late int completedCount;
  late int skippedCount;
  late int totalRestSeconds;
  late int workSeconds;
  late double completionRate;
  late List<int> hourlyRestCounts;

  DailyStatistics();

  factory DailyStatistics.fromRecords(DateTime date, List records) {
    // TODO: 实现从记录计算统计数据
    return DailyStatistics()
      ..date = date
      ..totalRestCount = 0
      ..completedCount = 0
      ..skippedCount = 0
      ..totalRestSeconds = 0
      ..workSeconds = 0
      ..completionRate = 0.0
      ..hourlyRestCounts = List.filled(24, 0);
  }
}
