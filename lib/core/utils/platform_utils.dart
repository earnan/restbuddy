import 'dart:io';

class PlatformUtils {
  static bool get isWindows => Platform.isWindows;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isDesktop => isWindows || isMacOS;
  static bool get isMobile => isAndroid || isIOS;
}
