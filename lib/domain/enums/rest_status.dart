enum RestStatus {
  completed, // 完成
  skipped, // 跳过
  forceSkipped, // 强制模式下紧急跳过
  interrupted, // 中断
}

extension RestStatusExtension on RestStatus {
  String get displayName {
    switch (this) {
      case RestStatus.completed:
        return '已完成';
      case RestStatus.skipped:
        return '已跳过';
      case RestStatus.forceSkipped:
        return '强制跳过';
      case RestStatus.interrupted:
        return '已中断';
    }
  }

  bool get isSuccess => this == RestStatus.completed;
  bool get isSkipped => this == RestStatus.skipped || this == RestStatus.forceSkipped;
}
