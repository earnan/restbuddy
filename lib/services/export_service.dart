import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/models/rest_record.dart';
import '../domain/enums/rest_status.dart';

class ExportService {
  Future<File> exportToCSV({
    required List<RestRecord> records,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final csvData = [
      ['日期', '时间', '休息类型', '计划时长(秒)', '实际时长(秒)', '状态'],
      ...records.map((r) => [
            DateFormat('yyyy-MM-dd').format(r.startTime),
            DateFormat('HH:mm').format(r.startTime),
            r.restType,
            r.durationSeconds.toString(),
            r.actualDurationSeconds.toString(),
            _getStatusName(r.status),
          ]),
    ];

    final csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'rest_records_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(csv);
    return file;
  }

  Future<File> exportToJSON({
    required List<RestRecord> records,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final jsonData = records.map((r) => {
          'date': DateFormat('yyyy-MM-dd').format(r.startTime),
          'time': DateFormat('HH:mm').format(r.startTime),
          'type': r.restType,
          'planned_duration': r.durationSeconds,
          'actual_duration': r.actualDurationSeconds,
          'status': r.status.name,
        }).toList();

    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonData);
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'rest_records_${DateFormat('yyyyMMdd').format(DateTime.now())}.json';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(jsonStr);
    return file;
  }

  Future<void> shareFile(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'RestBuddy 休息记录导出',
    );
  }

  String _getStatusName(RestStatus status) {
    switch (status) {
      case RestStatus.completed:
        return '已完成';
      case RestStatus.skipped:
        return '已跳过';
      case RestStatus.forceSkipped:
        return '强制跳过';
      case RestStatus.interrupted:
        return '已中断';
    }
  }
}
