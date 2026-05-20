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
- **窗口管理**: window_manager

## 目录结构
```
lib/
├── core/           # 核心基础设施（常量、主题、工具、EnvConfig）
├── data/           # 数据层（Isar 模型、数据源）
├── domain/         # 领域层（枚举：RestStatus, RestType）
├── presentation/   # 表现层（页面、Provider）
│   └── screens/
│       ├── home/              # 主界面
│       ├── settings/          # 设置页面
│       ├── statistics/        # 统计页面
│       └── rest_screensaver/  # 全屏休息屏保
├── services/       # 服务层（同步、通知、音频）
└── config/         # 路由配置
```

## 核心功能
- **主界面**: 倒计时 + 实时时钟 + 开始/暂停 + 立即休息 + 同步数据
- **休息屏保**: 系统级全屏覆盖（置顶+隐藏任务栏），脉冲动画，跳过按钮
- **设置页面**: 提醒间隔/休息时长/通知/声音/音效时长/强制模式/工作时间/坚果云
- **统计页面**: 今日/本周/本月数据 + 图表 + 历史记录
- **数据持久化**: Isar 本地数据库
- **云端同步**: 坚果云 WebDAV

## 开发规范
- 使用 Riverpod 进行状态管理（settingsProvider 共享设置状态）
- 数据模型使用 Isar Collection
- 坚果云配置存储在 Isar 数据库（UserSettings 模型），通过应用内设置界面配置
- 代码提交前确保 `flutter analyze` 无错误

## 构建命令
```bash
# 开发运行
flutter run -d windows
flutter run -d android

# 代码生成（Isar 模型）
dart run build_runner build --delete-conflicting-outputs

# 分析代码
flutter analyze

# Release 构建
flutter build windows --release       # Windows（需要纯英文路径）
flutter build apk --release           # Android

# 生成安装程序（需要 Inno Setup）
"C:\Users\hi\AppData\Local\Programs\Inno Setup 6\ISCC.exe" installer.iss
```

## Android 构建踩坑
- **JAVA_HOME**：必须设置，指向 JDK 17（`C:\Program Files\Java\jdk-17`）
- **ANDROID_HOME**：指向 Android SDK（`C:\Users\hi\AppData\Local\Android\Sdk`）
- **AGP 版本**：最低 8.2.2，否则 isar_flutter_libs 报 namespace 错误
- **Kotlin 版本**：最低 2.1.0，否则 package_info_plus 编译失败
- **isar_flutter_libs**：需手动修改 `~/.pub-cache/.../build.gradle` 添加 `namespace` 和升级 `compileSdkVersion`
- **Maven 镜像**：使用阿里云镜像加速（已在 build.gradle.kts 配置）
- **Gradle 镜像**：使用腾讯云镜像（已在 gradle-wrapper.properties 配置）

## 已确认决策
- 坚果云配置：存储在 Isar 数据库，通过应用内设置界面配置（非 .env 文件）
- 云端同步：坚果云 WebDAV（非 Supabase）
- 强制模式：始终可跳过，记录为 `force_skipped`
- 状态管理：Riverpod Provider 共享设置状态
- 休息屏保：系统级全屏（window_manager setFullScreen + setAlwaysOnTop）
- 提醒音效：循环播放，默认 5 秒，可在设置中调整（2/3/5/8/10 秒）
