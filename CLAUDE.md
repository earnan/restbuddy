# RestBuddy - 多端休息提醒应用

## 项目概述
Flutter 多端应用（Windows/macOS/Android/iOS），定时提醒休息，支持自定义上班时间、坚果云同步、完整统计。

## 技术栈
- **框架**: Flutter 3.41.9
- **状态管理**: Riverpod 2.x
- **本地数据库**: Isar 3.x
- **云端同步**: 坚果云 WebDAV
- **通知**: flutter_local_notifications
- **图表**: fl_chart

## 目录结构
```
lib/
├── core/           # 核心基础设施（常量、主题、工具、EnvConfig）
├── data/           # 数据层（Isar 模型、数据源）
├── domain/         # 领域层（枚举：RestStatus, RestType）
├── presentation/   # 表现层（页面、Provider）
├── services/       # 服务层（同步、通知、音频）
└── config/         # 路由配置
```

## 核心功能
- **主界面**: 倒计时 + 实时时钟 + 开始/暂停 + 立即休息 + 同步数据
- **设置页面**: 提醒间隔/休息时长/通知/声音/强制模式/工作时间/坚果云
- **统计页面**: 今日/本周/本月数据 + 图表 + 历史记录
- **数据持久化**: Isar 本地数据库
- **云端同步**: 坚果云 WebDAV

## 开发规范
- 使用 Riverpod 进行状态管理（settingsProvider 共享设置状态）
- 数据模型使用 Isar Collection
- 所有密钥通过 `.env` 文件管理（EnvConfig 类）
- 代码提交前确保 `flutter analyze` 无错误

## 构建命令
```bash
# 开发运行
flutter run -d windows

# 代码生成（Isar 模型）
dart run build_runner build --delete-conflicting-outputs

# 分析代码
flutter analyze

# Release 构建（需要纯英文路径）
flutter build windows --release
```

## 已确认决策
- 密钥管理：`.env` + 自定义 EnvConfig 类（从 exe 目录加载）
- 云端同步：坚果云 WebDAV（非 Supabase）
- 强制模式：始终可跳过，记录为 `force_skipped`
- 状态管理：Riverpod Provider 共享设置状态
