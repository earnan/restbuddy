# RestBuddy

多端休息提醒应用 - Windows / macOS / Android / iOS

## 功能特性

- **定时提醒**: 自定义间隔（15-120分钟），到时间自动提醒休息
- **休息类型**: 微休息(30秒)、短休息(5分钟)、长休息(15分钟)
- **提醒方式**: 系统通知 + 自定义声音 + 弹窗提醒
- **强制模式**: 全屏弹窗强制休息（可紧急跳过）
- **上班时间**: 支持多时间段、按星期配置
- **完整统计**: 今日/本周/本月数据、图表、历史记录
- **坚果云同步**: WebDAV 协议同步休息记录
- **数据导出**: CSV/JSON 格式导出

## 截图

![主界面](screenshots/home.png)
![设置页面](screenshots/settings.png)
![统计页面](screenshots/statistics.png)

## 开发环境

- Flutter 3.41.9
- Dart 3.11.5

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/rest_reminder.git
cd rest_reminder

# 安装依赖
flutter pub get

# 运行代码生成
dart run build_runner build --delete-conflicting-outputs

# 配置坚果云
cp .env.example .env
# 编辑 .env 填入坚果云账号

# 运行应用
flutter run -d windows
```

## 配置坚果云

1. 登录坚果云 → 账户设置 → 安全选项 → 第三方应用管理
2. 添加应用密码，获取应用密码
3. 在 `.env` 文件中配置：
   ```
   JIANGUOYUN_USERNAME=your_email@example.com
   JIANGUOYUN_PASSWORD=your_app_password
   ```

## 项目结构

```
lib/
├── core/           # 核心基础设施
│   ├── constants/  # 常量定义
│   ├── theme/      # 主题配置
│   └── utils/      # 工具类（EnvConfig、日期、平台）
├── data/           # 数据层
│   ├── models/     # Isar 数据模型
│   └── sources/    # 数据源（本地数据库）
├── domain/         # 领域层
│   └── enums/      # 枚举定义
├── presentation/   # 表现层
│   ├── screens/    # 页面（主页、设置、统计）
│   └── providers/  # Riverpod Provider
├── services/       # 服务层
│   ├── sync_service.dart      # 坚果云同步
│   ├── notification_service.dart # 通知服务
│   └── audio_service.dart     # 音频服务
└── config/         # 路由配置
```

## 构建发布

```bash
# Windows (需要纯英文路径)
flutter build windows --release

# Android
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release
```

## 技术栈

| 组件 | 技术 |
|------|------|
| 框架 | Flutter 3.x |
| 状态管理 | Riverpod 2.x |
| 本地数据库 | Isar 3.x |
| 云端同步 | 坚果云 WebDAV |
| 通知 | flutter_local_notifications |
| 图表 | fl_chart |
| 路由 | go_router |

## License

MIT License
