import 'package:isar/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  // 基本设置
  late int reminderIntervalMinutes;
  late int restDurationSeconds;

  // 提醒方式
  late bool enableNotification;
  late bool enableSound;
  late bool enablePopup;
  late bool enableForceMode;
  late String soundName;

  // 工作时间
  late List<WorkSchedule> schedules;

  // 坚果云配置
  String? jianguoyunUsername;
  String? jianguoyunPassword;

  // 同步相关
  DateTime? lastSyncAt;

  // 元数据
  late DateTime createdAt;
  late DateTime updatedAt;

  UserSettings();

  factory UserSettings.defaults() {
    return UserSettings()
      ..reminderIntervalMinutes = 45
      ..restDurationSeconds = 300
      ..enableNotification = true
      ..enableSound = true
      ..enablePopup = true
      ..enableForceMode = false
      ..soundName = 'gentle_bell'
      ..schedules = [WorkSchedule.defaults()]
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
  }
}

@embedded
class WorkSchedule {
  late String label;
  late int startHour;
  late int startMinute;
  late int endHour;
  late int endMinute;
  late List<bool> activeDays;

  WorkSchedule();

  factory WorkSchedule.defaults() {
    return WorkSchedule()
      ..label = '工作日'
      ..startHour = 9
      ..startMinute = 0
      ..endHour = 18
      ..endMinute = 0
      ..activeDays = [true, true, true, true, true, false, false];
  }
}
