import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static final Map<String, String> _values = {};

  static String? get(String key) => _values[key];

  static Future<void> load() async {
    try {
      final exePath = Platform.resolvedExecutable;
      final exeDir = exePath.substring(0, exePath.lastIndexOf('\\'));
      final envFile = File('$exeDir\\.env');
      if (await envFile.exists()) {
        final content = await envFile.readAsString();
        for (final line in content.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
          final eqIndex = trimmed.indexOf('=');
          if (eqIndex > 0) {
            final key = trimmed.substring(0, eqIndex).trim();
            final value = trimmed.substring(eqIndex + 1).trim();
            _values[key] = value;
          }
        }
        debugPrint('Loaded .env: ${_values.keys.join(', ')}');
      }
    } catch (e) {
      debugPrint('Warning: Failed to load .env: $e');
    }
  }
}
