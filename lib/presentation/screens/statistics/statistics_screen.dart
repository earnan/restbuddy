import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../data/sources/local/isar_service.dart';
import '../../../data/models/rest_record.dart';
import '../../../data/models/daily_statistics.dart';
import '../../../domain/enums/rest_status.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  String _selectedPeriod = '本周';
  List<RestRecord> _records = [];
  List<DailyStatistics> _weekStats = [];
  int _totalRestCount = 0;
  int _completedCount = 0;
  int _skippedCount = 0;
  int _totalRestSeconds = 0;
  double _completionRate = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<RestRecord> records;
    List<DailyStatistics> stats;

    switch (_selectedPeriod) {
      case '今日':
        records = await IsarService.getTodayRecords();
        stats = [];
        break;
      case '本周':
        records = await IsarService.getWeekRecords();
        stats = await IsarService.getWeekStatistics();
        break;
      case '本月':
        records = await IsarService.getMonthRecords();
        stats = await IsarService.getMonthStatistics();
        break;
      default:
        records = await IsarService.getWeekRecords();
        stats = await IsarService.getWeekStatistics();
    }

    setState(() {
      _records = records;
      _weekStats = stats;
      _totalRestCount = records.length;
      _completedCount = records.where((r) => r.status == RestStatus.completed).length;
      _skippedCount = records.where((r) =>
          r.status == RestStatus.skipped || r.status == RestStatus.forceSkipped).length;
      _totalRestSeconds = records.fold<int>(0, (sum, r) => sum + r.actualDurationSeconds);
      _completionRate = _totalRestCount > 0
          ? (_completedCount / _totalRestCount * 100)
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              setState(() => _selectedPeriod = v);
              _loadData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '今日', child: Text('今日')),
              const PopupMenuItem(value: '本周', child: Text('本周')),
              const PopupMenuItem(value: '本月', child: Text('本月')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(_selectedPeriod),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _totalRestCount == 0
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('暂无数据', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('完成休息后会自动记录统计', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 概览卡片
                _buildOverviewCard(),
                const SizedBox(height: 16),

                // 柱状图
                if (_weekStats.isNotEmpty) ...[
                  _buildWeeklyChart(),
                  const SizedBox(height: 16),
                ],

                // 完成率饼图
                _buildCompletionPie(),
                const SizedBox(height: 16),

                // 历史记录
                _buildHistoryList(),
              ],
            ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('总休息', '$_totalRestCount', '次'),
            _buildStatColumn('完成率', '${_completionRate.toStringAsFixed(0)}', '%'),
            _buildStatColumn('总时长', '${_totalRestSeconds ~/ 60}', '分钟'),
            _buildStatColumn('跳过', '$_skippedCount', '次'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              TextSpan(
                text: unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    // 按天统计
    final dailyData = <int, Map<String, int>>{};
    for (int i = 1; i <= 7; i++) {
      dailyData[i] = {'completed': 0, 'skipped': 0};
    }

    for (final stat in _weekStats) {
      final day = stat.date.weekday;
      dailyData[day] = {
        'completed': stat.completedCount,
        'skipped': stat.skippedCount,
      };
    }

    final maxY = dailyData.values
            .map((d) => (d['completed'] ?? 0) + (d['skipped'] ?? 0))
            .reduce((a, b) => a > b ? a : b)
            .toDouble() *
        1.2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '本周休息统计',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY > 0 ? maxY : 10,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['一', '二', '三', '四', '五', '六', '日'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(days[value.toInt() - 1]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: dailyData.entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: (entry.value['completed'] ?? 0).toDouble(),
                          color: Colors.green,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: (entry.value['skipped'] ?? 0).toDouble(),
                          color: Colors.red.shade300,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend('完成', Colors.green),
                const SizedBox(width: 16),
                _buildLegend('跳过', Colors.red.shade300),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildCompletionPie() {
    final interrupted = _totalRestCount - _completedCount - _skippedCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '完成率分布',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    if (_completedCount > 0)
                      PieChartSectionData(
                        value: _completedCount.toDouble(),
                        color: Colors.green,
                        title: '${(_completedCount * 100 ~/ _totalRestCount)}%',
                        radius: 60,
                      ),
                    if (_skippedCount > 0)
                      PieChartSectionData(
                        value: _skippedCount.toDouble(),
                        color: Colors.orange,
                        title: '${(_skippedCount * 100 ~/ _totalRestCount)}%',
                        radius: 60,
                      ),
                    if (interrupted > 0)
                      PieChartSectionData(
                        value: interrupted.toDouble(),
                        color: Colors.red,
                        title: '${(interrupted * 100 ~/ _totalRestCount)}%',
                        radius: 60,
                      ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend('完成', Colors.green),
                const SizedBox(width: 16),
                _buildLegend('跳过', Colors.orange),
                const SizedBox(width: 16),
                _buildLegend('中断', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final recentRecords = _records.reversed.take(10).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最近记录',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (recentRecords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('暂无记录', style: TextStyle(color: Colors.grey))),
              )
            else
              ...recentRecords.map((r) => _buildHistoryItem(r)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(RestRecord record) {
    final isCompleted = record.status == RestStatus.completed;
    final timeStr = DateFormat('HH:mm').format(record.startTime);
    final durationStr = record.actualDurationSeconds >= 60
        ? '${record.actualDurationSeconds ~/ 60}分钟'
        : '${record.actualDurationSeconds}秒';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          isCompleted ? Icons.check : Icons.close,
          color: isCompleted ? Colors.green : Colors.red,
        ),
      ),
      title: Text(record.restType),
      subtitle: Text('$timeStr · $durationStr'),
      trailing: Text(
        _getStatusName(record.status),
        style: TextStyle(
          color: isCompleted ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getStatusName(RestStatus status) {
    switch (status) {
      case RestStatus.completed:
        return '完成';
      case RestStatus.skipped:
        return '跳过';
      case RestStatus.forceSkipped:
        return '强制跳过';
      case RestStatus.interrupted:
        return '中断';
    }
  }
}
