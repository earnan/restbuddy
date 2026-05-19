import 'dart:convert';
import 'dart:typed_data';
import 'package:webdav_client/webdav_client.dart';
import 'package:flutter/foundation.dart';
import '../core/utils/env_config.dart';
import '../core/constants/app_constants.dart';
import '../data/sources/local/isar_service.dart';
import '../data/models/rest_record.dart';
import '../domain/enums/rest_status.dart';

class SyncService {
  Client? _client;
  bool _isInitialized = false;

  Future<void> initialize() async {
    final username = EnvConfig.get('JIANGUOYUN_USERNAME');
    final password = EnvConfig.get('JIANGUOYUN_PASSWORD');

    if (username == null || password == null) {
      throw Exception('坚果云配置未找到，请在 .env 文件中配置');
    }

    _client = newClient(
      AppConstants.webdavServer,
      user: username,
      password: password,
    );

    // 创建同步目录
    await _ensureDirectoryExists(AppConstants.syncFolder);
    await _ensureDirectoryExists('${AppConstants.syncFolder}records/');
    await _ensureDirectoryExists('${AppConstants.syncFolder}statistics/');
    _isInitialized = true;
  }

  Future<void> _ensureDirectoryExists(String path) async {
    try {
      await _client!.mkdir(path);
    } catch (e) {
      // 目录可能已存在，忽略错误
    }
  }

  // 测试连接
  Future<bool> testConnection() async {
    try {
      await initialize();
      await _client!.ping();
      return true;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  // 上传休息记录
  Future<void> uploadRecords(List<RestRecord> records) async {
    if (!_isInitialized) await initialize();

    final recordsJson = records.map((r) => {
      'id': r.id,
      'restType': r.restType,
      'durationSeconds': r.durationSeconds,
      'actualDurationSeconds': r.actualDurationSeconds,
      'startTime': r.startTime.toIso8601String(),
      'endTime': r.endTime?.toIso8601String(),
      'status': r.status.name,
      'createdAt': r.createdAt.toIso8601String(),
    }).toList();

    final jsonStr = jsonEncode(recordsJson);
    final bytes = Uint8List.fromList(utf8.encode(jsonStr));

    final now = DateTime.now();
    final fileName = '${now.year}-${now.month.toString().padLeft(2, '0')}.json';

    await _client!.write(
      '${AppConstants.syncFolder}records/$fileName',
      bytes,
    );

    debugPrint('Uploaded ${records.length} records to $fileName');
  }

  // 下载休息记录
  Future<List<Map<String, dynamic>>?> downloadRecords(String monthKey) async {
    if (!_isInitialized) await initialize();

    try {
      final bytes = await _client!.read('${AppConstants.syncFolder}records/$monthKey.json');
      if (bytes.isEmpty) return null;

      final jsonStr = utf8.decode(bytes);
      final list = jsonDecode(jsonStr) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Download records failed: $e');
      return null;
    }
  }

  // 同步所有数据
  Future<SyncResult> syncAll() async {
    if (!_isInitialized) await initialize();

    try {
      // 上传今日记录
      final todayRecords = await IsarService.getTodayRecords();
      await uploadRecords(todayRecords);

      // 上传本周记录
      final weekRecords = await IsarService.getWeekRecords();
      await uploadRecords(weekRecords);

      return SyncResult(
        success: true,
        message: '同步成功！上传了 ${todayRecords.length} 条今日记录',
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: '同步失败: $e',
      );
    }
  }
}

class SyncResult {
  final bool success;
  final String message;

  SyncResult({required this.success, required this.message});
}
