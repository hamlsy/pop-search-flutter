import 'package:flutter/material.dart';
import 'package:pop_search/features/settings/domain/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesThemeRepository implements ThemeRepository {
  static const _themeModeKey = 'theme_mode';

  @override
  Future<ThemeMode> readThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getString(_themeModeKey);
    switch (storedValue) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> writeThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }
}
