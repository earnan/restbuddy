class AppConstants {
  static const String appName = 'RestBuddy';
  static const String appVersion = '1.0.0';

  // 默认设置
  static const int defaultReminderInterval = 45; // 分钟
  static const int defaultRestDuration = 300; // 秒 (5分钟)

  // WebDAV 配置
  static const String webdavServer = 'https://dav.jianguoyun.com/dav/';
  static const String syncFolder = '/RestBuddy/';

  // 休息类型
  static const String microRest = '微休息';
  static const String shortRest = '短休息';
  static const String longRest = '长休息';
}
