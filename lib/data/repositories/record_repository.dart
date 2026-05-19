import '../models/rest_record.dart';
import '../../domain/enums/rest_status.dart';

class RecordRepository {
  // TODO: 实现 Isar 数据库操作

  Future<List<RestRecord>> getRecordsByDateRange(DateTime start, DateTime end) async {
    // TODO: 从 Isar 获取指定日期范围的记录
    return [];
  }

  Future<List<RestRecord>> getTodayRecords() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getRecordsByDateRange(start, end);
  }

  Future<void> recordRest({
    required String restType,
    required int durationSeconds,
    required RestStatus status,
    int? actualDurationSeconds,
  }) async {
    final record = RestRecord.create(
      restType: restType,
      durationSeconds: durationSeconds,
      status: status,
      actualDurationSeconds: actualDurationSeconds,
    );
    // TODO: 保存到 Isar
  }

  Future<int> getTodayCompletedCount() async {
    final records = await getTodayRecords();
    return records.where((r) => r.status == RestStatus.completed).length;
  }

  Future<int> getTodayTotalCount() async {
    final records = await getTodayRecords();
    return records.length;
  }

  Future<int> getTodayTotalSeconds() async {
    final records = await getTodayRecords();
    return records.fold<int>(0, (sum, r) => sum + r.actualDurationSeconds);
  }
}
