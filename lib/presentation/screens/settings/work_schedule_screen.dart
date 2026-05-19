import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_settings.dart';
import '../../providers/settings_provider.dart';

class WorkScheduleScreen extends ConsumerStatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  ConsumerState<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends ConsumerState<WorkScheduleScreen> {
  late List<WorkSchedule> _schedules;

  @override
  void initState() {
    super.initState();
    // 初始化默认工作时间
    _schedules = [
      WorkSchedule()
        ..label = '上午'
        ..startHour = 9
        ..startMinute = 0
        ..endHour = 12
        ..endMinute = 0
        ..activeDays = [true, true, true, true, true, false, false],
      WorkSchedule()
        ..label = '下午'
        ..startHour = 14
        ..startMinute = 0
        ..endHour = 18
        ..endMinute = 0
        ..activeDays = [true, true, true, true, true, false, false],
    ];
  }

  Future<void> _pickTime(bool isStart, int index) async {
    final schedule = _schedules[index];
    final initialTime = TimeOfDay(
      hour: isStart ? schedule.startHour : schedule.endHour,
      minute: isStart ? schedule.startMinute : schedule.endMinute,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _schedules[index].startHour = picked.hour;
          _schedules[index].startMinute = picked.minute;
        } else {
          _schedules[index].endHour = picked.hour;
          _schedules[index].endMinute = picked.minute;
        }
      });
    }
  }

  void _toggleDay(int scheduleIndex, int dayIndex) {
    setState(() {
      _schedules[scheduleIndex].activeDays[dayIndex] =
          !_schedules[scheduleIndex].activeDays[dayIndex];
    });
  }

  void _addSchedule() {
    setState(() {
      _schedules.add(
        WorkSchedule()
          ..label = '时段${_schedules.length + 1}'
          ..startHour = 19
          ..startMinute = 0
          ..endHour = 21
          ..endMinute = 0
          ..activeDays = [true, true, true, true, true, false, false],
      );
    });
  }

  void _removeSchedule(int index) {
    if (_schedules.length > 1) {
      setState(() {
        _schedules.removeAt(index);
      });
    }
  }

  void _save() {
    // TODO: 保存到 Provider 和数据库
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('工作时间已保存'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工作时间设置'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '设置工作时间段，休息提醒仅在工作时间内触发',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // 工作时间段列表
          ..._schedules.asMap().entries.map((entry) {
            return _buildScheduleCard(entry.key, entry.value);
          }),

          const SizedBox(height: 16),

          // 添加按钮
          OutlinedButton.icon(
            onPressed: _addSchedule,
            icon: const Icon(Icons.add),
            label: const Text('添加时间段'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(int index, WorkSchedule schedule) {
    final days = ['一', '二', '三', '四', '五', '六', '日'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题和删除按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_schedules.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeSchedule(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 时间选择
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickTime(true, index),
                    child: Text(
                      '${schedule.startHour.toString().padLeft(2, '0')}:${schedule.startMinute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('至', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickTime(false, index),
                    child: Text(
                      '${schedule.endHour.toString().padLeft(2, '0')}:${schedule.endMinute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 星期选择
            const Text('重复', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: days.asMap().entries.map((entry) {
                final isActive = schedule.activeDays[entry.key];
                return GestureDetector(
                  onTap: () => _toggleDay(index, entry.key),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                    ),
                    child: Center(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
