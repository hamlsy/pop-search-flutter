import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pop_search/features/settings/domain/theme_repository.dart';
import 'package:pop_search/features/settings/presentation/theme_controller.dart';

class _FakeThemeRepository implements ThemeRepository {
  ThemeMode stored = ThemeMode.system;

  @override
  Future<ThemeMode> readThemeMode() async => stored;

  @override
  Future<void> writeThemeMode(ThemeMode mode) async {
    stored = mode;
  }
}

void main() {
  test('loads theme mode from repository', () async {
    final repository = _FakeThemeRepository()..stored = ThemeMode.dark;
    final controller = ThemeController(repository);

    await controller.loadThemeMode();

    expect(controller.themeMode, ThemeMode.dark);
  });

  test('sets theme mode and persists value', () async {
    final repository = _FakeThemeRepository();
    final controller = ThemeController(repository);

    await controller.setThemeMode(ThemeMode.light);

    expect(controller.themeMode, ThemeMode.light);
    expect(repository.stored, ThemeMode.light);
  });
}
