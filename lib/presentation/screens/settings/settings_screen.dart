import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/sync_service.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final hasJianguoyun = settings.jianguoyunUsername != null &&
        settings.jianguoyunUsername!.isNotEmpty;

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
              if (settings.enableSound)
                _buildDropdownTile(
                  title: '提示音时长',
                  value: settings.soundDurationSeconds,
                  items: const [
                    DropdownMenuItem(value: 2, child: Text('2秒')),
                    DropdownMenuItem(value: 3, child: Text('3秒')),
                    DropdownMenuItem(value: 5, child: Text('5秒')),
                    DropdownMenuItem(value: 8, child: Text('8秒')),
                    DropdownMenuItem(value: 10, child: Text('10秒')),
                  ],
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).updateSoundDuration(v!);
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
                  color: hasJianguoyun ? Colors.green : Colors.grey,
                ),
                title: const Text('坚果云同步'),
                subtitle: Text(hasJianguoyun
                    ? '已配置: ${settings.jianguoyunUsername}'
                    : '未配置 - 点击配置'),
                trailing: hasJianguoyun
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.chevron_right),
                onTap: () => _showJianguoyunConfigDialog(),
              ),
              if (hasJianguoyun) ...[
                ListTile(
                  title: const Text('测试连接'),
                  trailing: const Icon(Icons.sync),
                  onTap: _testConnection,
                ),
                ListTile(
                  title: const Text('清除配置'),
                  trailing: const Icon(Icons.delete_outline, color: Colors.red),
                  onTap: _clearJianguoyunConfig,
                ),
              ],
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
    final settings = ref.read(settingsProvider);
    final usernameController = TextEditingController(
      text: settings.jianguoyunUsername ?? '',
    );
    final passwordController = TextEditingController(
      text: settings.jianguoyunPassword ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('配置坚果云'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '应用密码获取方式：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('坚果云 → 账户设置 → 安全选项 → 第三方应用管理 → 添加应用密码'),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: '坚果云账号',
                hintText: 'your_email@example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: '应用密码',
                hintText: '输入应用密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final username = usernameController.text.trim();
              final password = passwordController.text.trim();
              if (username.isNotEmpty && password.isNotEmpty) {
                ref.read(settingsProvider.notifier).updateJianguoyun(
                  username,
                  password,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('坚果云配置已保存')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请填写完整的账号和密码'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _clearJianguoyunConfig() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除坚果云配置'),
        content: const Text('确定要清除坚果云配置吗？清除后需要重新配置才能同步。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).updateJianguoyun('', '');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('坚果云配置已清除')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('清除'),
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
      final settings = ref.read(settingsProvider);
      final syncService = SyncService();
      await syncService.initialize(
        username: settings.jianguoyunUsername,
        password: settings.jianguoyunPassword,
      );
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
