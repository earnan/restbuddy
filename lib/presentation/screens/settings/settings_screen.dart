import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/env_config.dart';
import '../../../services/sync_service.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // 坚果云状态
  String _jianguoyunStatus = '未配置';
  String _jianguoyunEmail = '';

  @override
  void initState() {
    super.initState();
    _checkJianguoyunConfig();
  }

  void _checkJianguoyunConfig() {
    final username = EnvConfig.get('JIANGUOYUN_USERNAME');
    final password = EnvConfig.get('JIANGUOYUN_PASSWORD');
    if (username != null && password != null && username.isNotEmpty) {
      setState(() {
        _jianguoyunStatus = '已配置';
        _jianguoyunEmail = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 从 Provider 读取设置
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 提醒设置
          _buildSection(
            title: '提醒设置',
            children: [
              _buildSliderTile(
                title: '提醒间隔',
                value: settings.reminderIntervalMinutes.toDouble(),
                min: 15,
                max: 120,
                divisions: 21,
                suffix: '分钟',
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).updateReminderInterval(v.round());
                },
              ),
              _buildDropdownTile(
                title: '休息时长',
                value: settings.restDurationSeconds,
                items: const [
                  DropdownMenuItem(value: 30, child: Text('30秒')),
                  DropdownMenuItem(value: 60, child: Text('1分钟')),
                  DropdownMenuItem(value: 300, child: Text('5分钟')),
                  DropdownMenuItem(value: 600, child: Text('10分钟')),
                  DropdownMenuItem(value: 900, child: Text('15分钟')),
                ],
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).updateRestDuration(v!);
                },
              ),
            ],
          ),

          // 通知设置
          _buildSection(
            title: '通知设置',
            children: [
              _buildSwitchTile(
                title: '启用通知',
                value: settings.enableNotification,
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).toggleNotification(v);
                },
              ),
              _buildSwitchTile(
                title: '提醒声音',
                value: settings.enableSound,
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).toggleSound(v);
                },
              ),
              _buildSwitchTile(
                title: '强制模式',
                subtitle: '全屏弹窗，必须休息',
                value: settings.enableForceMode,
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).toggleForceMode(v);
                },
              ),
            ],
          ),

          // 工作时间
          _buildSection(
            title: '工作时间',
            children: [
              ListTile(
                title: const Text('工作时间段'),
                subtitle: const Text('09:00 - 18:00'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/settings/work-schedule');
                },
              ),
            ],
          ),

          // 云端同步
          _buildSection(
            title: '云端同步',
            children: [
              ListTile(
                leading: Icon(
                  Icons.cloud,
                  color: _jianguoyunStatus == '已配置' ? Colors.green : Colors.grey,
                ),
                title: const Text('坚果云同步'),
                subtitle: Text(_jianguoyunStatus == '已配置'
                    ? '已连接: $_jianguoyunEmail'
                    : '未配置 - 请在 .env 文件中配置'),
                trailing: _jianguoyunStatus == '已配置'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.chevron_right),
                onTap: () {
                  if (_jianguoyunStatus != '已配置') {
                    _showJianguoyunConfigDialog();
                  }
                },
              ),
              if (_jianguoyunStatus == '已配置')
                ListTile(
                  title: const Text('测试连接'),
                  trailing: const Icon(Icons.sync),
                  onTap: _testConnection,
                ),
            ],
          ),

          // 关于
          _buildSection(
            title: '关于',
            children: [
              const ListTile(
                title: Text('版本'),
                subtitle: Text('1.0.0'),
              ),
              const ListTile(
                title: Text('应用名称'),
                subtitle: Text('RestBuddy'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showJianguoyunConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('配置坚果云'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('请在项目根目录的 .env 文件中配置：'),
            SizedBox(height: 12),
            Text('JIANGUOYUN_USERNAME=你的邮箱', style: TextStyle(fontFamily: 'monospace')),
            Text('JIANGUOYUN_PASSWORD=应用密码', style: TextStyle(fontFamily: 'monospace')),
            SizedBox(height: 12),
            Text('应用密码获取方式：'),
            Text('坚果云 → 账户设置 → 安全选项 → 第三方应用管理 → 添加应用密码'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  Future<void> _testConnection() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正在测试连接...')),
    );

    try {
      final syncService = SyncService();
      final success = await syncService.testConnection();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('连接成功！坚果云同步正常'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('连接失败，请检查账号和应用密码'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('连接错误: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: '${value.round()}$suffix',
        onChanged: onChanged,
      ),
      trailing: Text('${value.round()}$suffix'),
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
