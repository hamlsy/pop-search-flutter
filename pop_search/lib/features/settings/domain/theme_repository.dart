import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<ThemeMode> readThemeMode();

  Future<void> writeThemeMode(ThemeMode mode);
}
