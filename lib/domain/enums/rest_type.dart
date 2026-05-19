enum RestType {
  micro('微休息', 30),
  short('短休息', 300),
  long('长休息', 900);

  final String displayName;
  final int defaultDurationSeconds;

  const RestType(this.displayName, this.defaultDurationSeconds);
}
