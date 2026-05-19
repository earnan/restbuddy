import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/env_config.dart';
import 'data/sources/local/isar_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载 .env 配置
  await EnvConfig.load();

  // 初始化 Isar 数据库
  await IsarService.initialize();

  runApp(
    const ProviderScope(
      child: RestBuddyApp(),
    ),
  );
}
