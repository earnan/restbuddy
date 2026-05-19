import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import '../data/models/user_settings.dart';

class TimerService {
  static const String _taskName = 'restBuddyReminderTask';
  static const String _uniqueName = 'restBuddyPeriodicTask';

  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  Future<void> registerPeriodicTask(Duration interval) async {
    await Workmanager().registerPeriodicTask(
      _uniqueName,
      _taskName,
      frequency: interval,
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
      ),
    );
  }

  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  bool isWithinWorkSchedule(List<WorkSchedule> schedules) {
    final now = DateTime.now();
    final currentDay = now.weekday - 1; // 0-6
    final currentTime = now.hour * 60 + now.minute;

    for (final schedule in schedules) {
      if (currentDay >= schedule.activeDays.length || !schedule.activeDays[currentDay]) {
        continue;
      }

      final start = schedule.startHour * 60 + schedule.startMinute;
      final end = schedule.endHour * 60 + schedule.endMinute;

      if (currentTime >= start && currentTime < end) {
        return true;
      }
    }
    return false;
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case TimerService._taskName:
        // TODO: 检查工作时间并触发通知
        debugPrint('Rest reminder task executed');
        return true;
      default:
        return false;
    }
  });
}
