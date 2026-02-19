import 'package:flutter/material.dart';
import 'package:pop_search/app/theme/app_theme.dart';
import 'package:pop_search/core/repositories/shared_preferences/history_repository_impl.dart';
import 'package:pop_search/core/repositories/shared_preferences/preferences_repository_impl.dart';
import 'package:pop_search/core/services/url_launcher_client.dart';
import 'package:pop_search/features/search/application/search_execution_service.dart';
import 'package:pop_search/features/search/presentation/search_screen.dart';
import 'package:pop_search/features/settings/data/shared_preferences_theme_repository.dart';
import 'package:pop_search/features/settings/presentation/theme_controller.dart';

class PopSearchApp extends StatefulWidget {
  const PopSearchApp({super.key});

  @override
  State<PopSearchApp> createState() => _PopSearchAppState();
}

class _PopSearchAppState extends State<PopSearchApp> {
  final _historyRepository = SharedPreferencesHistoryRepository();
  final _preferencesRepository = SharedPreferencesPreferencesRepository();
  late final ThemeController _themeController = ThemeController(
    SharedPreferencesThemeRepository(),
  );
  late final SearchExecutionService _executionService = SearchExecutionService(
    launchClient: const UrlLauncherClient(),
  );

  @override
  void initState() {
    super.initState();
    _themeController.loadThemeMode();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (_, __) {
        return MaterialApp(
          title: 'PopSearch',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeController.themeMode,
          home: SearchScreen(
            historyRepository: _historyRepository,
            preferencesRepository: _preferencesRepository,
            executionService: _executionService,
            themeController: _themeController,
          ),
        );
      },
    );
  }
}
