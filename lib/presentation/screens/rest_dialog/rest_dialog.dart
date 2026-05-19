import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timer_provider.dart';

class RestDialog extends ConsumerStatefulWidget {
  final String restType;
  final int durationSeconds;
  final bool forceMode;

  const RestDialog({
    super.key,
    required this.restType,
    required this.durationSeconds,
    this.forceMode = false,
  });

  @override
  ConsumerState<RestDialog> createState() => _RestDialogState();
}

class _RestDialogState extends ConsumerState<RestDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _remainingSeconds;
  bool _canSkip = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    );
    _startCountdown();

    // 强制模式下，延迟显示跳过按钮
    if (widget.forceMode) {
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) setState(() => _canSkip = true);
      });
    } else {
      _canSkip = true;
    }
  }

  void _startCountdown() {
    _controller.forward();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _onRestComplete();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getRestIcon(widget.restType),
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              _formatTime(_remainingSeconds),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            Text(
              _getRestTip(widget.restType),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            if (_canSkip)
              TextButton(
                onPressed: _onSkip,
                child: Text(
                  widget.forceMode ? '紧急跳过' : '跳过本次休息',
                  style: TextStyle(
                    color: widget.forceMode ? Colors.red : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getRestIcon(String type) {
    switch (type) {
      case '微休息':
        return Icons.coffee;
      case '短休息':
        return Icons.self_improvement;
      case '长休息':
        return Icons.hotel;
      default:
        return Icons.pause;
    }
  }

  String _getRestTip(String type) {
    switch (type) {
      case '微休息':
        return '看看远处，活动一下眼睛';
      case '短休息':
        return '站起来，伸展一下身体';
      case '长休息':
        return '离开座位，喝杯水，走动一下';
      default:
        return '休息一下，稍后继续';
    }
  }

  void _onRestComplete() {
    // TODO: 记录休息完成
    Navigator.of(context).pop(true);
  }

  void _onSkip() {
    // TODO: 记录跳过
    Navigator.of(context).pop(false);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
