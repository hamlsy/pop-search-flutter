import 'package:flutter/material.dart';
import 'package:pop_search/features/settings/domain/theme_repository.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._repository);

  final ThemeRepository _repository;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeMode() async {
    _themeMode = await _repository.readThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    await _repository.writeThemeMode(mode);
  }
}
