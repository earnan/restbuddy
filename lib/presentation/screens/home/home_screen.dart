import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/settings_provider.dart';
import '../../../data/sources/local/isar_service.dart';
import '../../../data/models/rest_record.dart';
import '../../../domain/enums/rest_status.dart';
import '../../../services/sync_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/audio_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isRunning = false;
  bool _isResting = false;
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  String _currentTime = '';
  Timer? _clockTimer;

  // 统计数据
  int _todayCount = 0;
  int _completedCount = 0;
  int _totalMinutes = 0;

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
    _loadTodayStats();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await NotificationService.initialize();
  }

  Future<void> _loadTodayStats() async {
    final records = await IsarService.getTodayRecords();
    setState(() {
      _todayCount = records.length;
      _completedCount = records.where((r) => r.status == RestStatus.completed).length;
      _totalMinutes = records.fold<int>(0, (sum, r) => sum + r.actualDurationSeconds) ~/ 60;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isRunning && !_isResting) {
      final settings = ref.read(settingsProvider);
      _remainingSeconds = settings.reminderIntervalMinutes * 60;
      _totalSeconds = settings.reminderIntervalMinutes * 60;
    }
  }

  void _updateClock() {
    final now = DateTime.now();
    setState(() {
      _currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _startCountdown();
    } else {
      _timer?.cancel();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          _isRunning = false;
          _triggerRestReminder();
        } else {
          _remainingSeconds--;
        }
      });
    });
  }

  void _triggerRestReminder() {
    final settings = ref.read(settingsProvider);

    // 播放提醒音效
    if (settings.enableSound) {
      AudioService.playReminderSound('gentle_bell.mp3');
    }

    // 显示通知
    if (settings.enableNotification) {
      NotificationService.showRestReminder(
        title: '休息提醒',
        body: '该休息了！点击开始 ${settings.restDurationSeconds ~/ 60} 分钟休息',
      );
    }

    // 开始休息倒计时
    _startRest(settings.restDurationSeconds);
  }

  void _startRest(int seconds) {
    setState(() {
      _isResting = true;
      _remainingSeconds = seconds;
      _totalSeconds = seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          _isResting = false;
          _onRestComplete();
        } else {
          _remainingSeconds--;
        }
      });
    });
  }

  Future<void> _onRestComplete() async {
    final settings = ref.read(settingsProvider);

    // 记录休息完成
    final record = RestRecord.create(
      restType: '短休息',
      durationSeconds: settings.restDurationSeconds,
      status: RestStatus.completed,
      actualDurationSeconds: settings.restDurationSeconds,
    );
    await IsarService.addRecord(record);
    await IsarService.updateDailyStats(DateTime.now());

    // 播放完成音效
    if (settings.enableSound) {
      AudioService.playCompletionSound();
    }

    // 刷新统计数据
    await _loadTodayStats();

    // 重置倒计时
    setState(() {
      _remainingSeconds = settings.reminderIntervalMinutes * 60;
      _totalSeconds = settings.reminderIntervalMinutes * 60;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('休息完成！'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _onSkipRest() async {
    _timer?.cancel();

    final settings = ref.read(settingsProvider);

    // 记录跳过
    final record = RestRecord.create(
      restType: '短休息',
      durationSeconds: settings.restDurationSeconds,
      status: RestStatus.skipped,
      actualDurationSeconds: 0,
    );
    await IsarService.addRecord(record);
    await IsarService.updateDailyStats(DateTime.now());

    await _loadTodayStats();

    setState(() {
      _isResting = false;
      _remainingSeconds = settings.reminderIntervalMinutes * 60;
      _totalSeconds = settings.reminderIntervalMinutes * 60;
    });
  }

  String _formatCountdown(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _syncData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正在同步数据...')),
    );

    try {
      final syncService = SyncService();
      final result = await syncService.syncAll();

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('同步错误: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (!_isRunning && !_isResting) {
      final newTotal = settings.reminderIntervalMinutes * 60;
      if (_totalSeconds != newTotal) {
        _remainingSeconds = newTotal;
        _totalSeconds = newTotal;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('RestBuddy'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _currentTime,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/statistics'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 状态标签
                    Chip(
                      label: Text(_isResting ? '休息中' : (_isRunning ? '运行中' : '已暂停')),
                      backgroundColor: _isResting
                          ? Colors.green.shade100
                          : (_isRunning ? Colors.blue.shade100 : Colors.grey.shade200),
                    ),
                    const SizedBox(height: 24),

                    // 倒计时显示
                    Text(
                      _formatCountdown(_remainingSeconds),
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: _isResting
                            ? Colors.green
                            : (_isRunning
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 进度条
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: LinearProgressIndicator(
                        value: _totalSeconds > 0
                            ? (_totalSeconds - _remainingSeconds) / _totalSeconds
                            : 0,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        color: _isResting ? Colors.green : null,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _isResting
                          ? '休息中，放松一下'
                          : (_isRunning ? '距离下次休息' : '点击开始计时'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // 按钮区域
                    if (_isResting)
                      // 休息中：显示跳过按钮
                      ElevatedButton.icon(
                        onPressed: _onSkipRest,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('跳过休息'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      )
                    else
                      // 正常：显示开始/暂停按钮
                      GestureDetector(
                        onTap: _toggleTimer,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _isRunning
                                  ? [Colors.orange, Colors.orange.shade700]
                                  : [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.primaryContainer,
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_isRunning ? Colors.orange : Theme.of(context).colorScheme.primary)
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 48,
                                color: Colors.white,
                              ),
                              Text(
                                _isRunning ? '暂停' : '开始',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 今日统计摘要
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('今日休息', '$_todayCount次'),
                  _buildStatItem('完成率', '${_todayCount > 0 ? (_completedCount * 100 ~/ _todayCount) : 0}%'),
                  _buildStatItem('休息时长', '$_totalMinutes分钟'),
                ],
              ),
            ),

            // 底部操作栏
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _startRest(ref.read(settingsProvider).restDurationSeconds);
                    },
                    icon: const Icon(Icons.coffee),
                    label: const Text('立即休息'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _syncData,
                    icon: const Icon(Icons.sync),
                    label: const Text('同步数据'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }
}
