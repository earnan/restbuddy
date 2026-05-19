import '../models/user_settings.dart';

class SettingsRepository {
  // TODO: 实现 Isar 数据库操作

  Future<UserSettings> getSettings() async {
    // TODO: 从 Isar 获取设置
    return UserSettings.defaults();
  }

  Future<void> saveSettings(UserSettings settings) async {
    // TODO: 保存到 Isar
  }

  Future<void> updateSettings(UserSettings settings) async {
    // TODO: 更新 Isar 中的设置
  }
}
