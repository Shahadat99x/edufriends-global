import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _prefKey = 'edu_friends_theme_mode'; // 'system'|'light'|'dark'
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  // Call once at app start (before runApp)
  static Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(_prefKey);
  ThemeMode mode;
  switch (saved) {
    case 'light':
      mode = ThemeMode.light;
      break;
    case 'dark':
      mode = ThemeMode.dark;
      break;
    default:
      // Default to light so app starts in light mode (but user can still switch)
      mode = ThemeMode.light;
  }
  themeModeNotifier.value = mode;
}

  // Persist and notify listeners
  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await prefs.setString(_prefKey, value);
    themeModeNotifier.value = mode;
  }
}
