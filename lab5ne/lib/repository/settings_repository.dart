import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferencesAsync _preferences =
      SharedPreferencesAsync();

  static const String _themeKey = 'theme_mode';

  // Đọc chế độ giao diện đã lưu.
  Future<ThemeMode> loadTheme() async {
    final savedValue = await _preferences.getString(_themeKey);

    switch (savedValue) {
      case 'light':
        return ThemeMode.light;

      case 'dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  // Lưu chế độ giao diện người dùng chọn.
  Future<void> saveTheme(ThemeMode mode) async {
    await _preferences.setString(
      _themeKey,
      mode.name,
    );
  }
}