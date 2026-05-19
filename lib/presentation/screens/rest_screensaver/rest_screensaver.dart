import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../providers/settings_provider.dart';
import '../../../services/audio_service.dart';

class RestScreensaver extends ConsumerStatefulWidget {
  final String restType;
  final int durationSeconds;
  final bool forceMode;
  final VoidCallback? onRestComplete;
  final VoidCallback? onSkip;

  const RestScreensaver({
    super.key,
    required this.restType,
    required this.durationSeconds,
    this.forceMode = false,
    this.onRestComplete,
    this.onSkip,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String restType,
    required int durationSeconds,
    bool forceMode = false,
    VoidCallback? onRestComplete,
  }) async {
    // 进入系统级全屏（置顶 + 全屏覆盖）
    await _enterFullscreen();

    final result = await Navigator.of(context).push<bool>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return RestScreensaver(
            restType: restType,
            durationSeconds: durationSeconds,
            forceMode: forceMode,
            onRestComplete: onRestComplete,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );

    // 退出全屏
    await _exitFullscreen();
    return result;
  }

  static Future<void> _enterFullscreen() async {
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // 桌面平台：使用 window_manager
        await windowManager.setAlwaysOnTop(true);
        await windowManager.setFullScreen(true);
        await windowManager.setSkipTaskbar(true);
      } else if (Platform.isAndroid || Platform.isIOS) {
        // 移动平台：使用 SystemChrome
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
      // 启用屏幕常亮
      await WakelockPlus.enable();
    } catch (e) {
      debugPrint('Failed to enter fullscreen: $e');
    }
  }

  static Future<void> _exitFullscreen() async {
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // 桌面平台：使用 window_manager
        await windowManager.setFullScreen(false);
        await windowManager.setAlwaysOnTop(false);
        await windowManager.setSkipTaskbar(false);
      } else if (Platform.isAndroid || Platform.isIOS) {
        // 移动平台：恢复系统 UI
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        await SystemChrome.setPreferredOrientations([]);
      }
      // 禁用屏幕常亮
      await WakelockPlus.disable();
    } catch (e) {
      debugPrint('Failed to exit fullscreen: $e');
    }
  }

  @override
  ConsumerState<RestScreensaver> createState() => _RestScreensaverState();
}

class _RestScreensaverState extends ConsumerState<RestScreensaver>
    with TickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  bool _canSkip = false;
  late AnimationController _pulseController;
  late AnimationController _bgController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _bgColorAnimation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;

    // 脉冲动画
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 背景渐变动画
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _bgColorAnimation = ColorTween(
      begin: Colors.blue.shade900,
      end: Colors.indigo.shade900,
    ).animate(_bgController);

    // 强制模式下延迟显示跳过按钮
    if (widget.forceMode) {
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) setState(() => _canSkip = true);
      });
    } else {
      _canSkip = true;
    }

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _onRestComplete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _onRestComplete() {
    _timer?.cancel();
    AudioService.stop(); // 停止音效
    widget.onRestComplete?.call();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _onSkip() {
    _timer?.cancel();
    AudioService.stop(); // 停止音效
    widget.onSkip?.call();
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgColorAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _bgColorAnimation.value ?? Colors.blue.shade900,
                  Colors.black87,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // 休息图标（脉冲动画）
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Icon(
                          _getRestIcon(widget.restType),
                          size: 120,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // 休息类型
                  Text(
                    widget.restType,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 倒计时
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      fontFamily: 'monospace',
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 进度条
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: widget.durationSeconds > 0
                            ? _remainingSeconds / widget.durationSeconds
                            : 0,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 休息提示
                  Text(
                    _getRestTip(widget.restType),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white60,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 2),

                  // 跳过按钮
                  if (_canSkip)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: TextButton.icon(
                        onPressed: _onSkip,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: widget.forceMode ? Colors.red.shade300 : Colors.white54,
                        ),
                        label: Text(
                          widget.forceMode ? '紧急跳过' : '跳过本次休息',
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.forceMode ? Colors.red.shade300 : Colors.white54,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  IconData _getRestIcon(String type) {
    switch (type) {
      case '微休息':
        return Icons.coffee_rounded;
      case '短休息':
        return Icons.self_improvement_rounded;
      case '长休息':
        return Icons.hotel_rounded;
      default:
        return Icons.pause_circle_outline_rounded;
    }
  }

  String _getRestTip(String type) {
    switch (type) {
      case '微休息':
        return '看看远处，让眼睛休息一下';
      case '短休息':
        return '站起来，伸展一下身体';
      case '长休息':
        return '离开座位，喝杯水，走动走动';
      default:
        return '休息一下，稍后继续';
    }
  }
}
