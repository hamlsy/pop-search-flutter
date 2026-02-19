import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pop_search/core/repositories/history_repository.dart';
import 'package:pop_search/core/repositories/preferences_repository.dart';
import 'package:pop_search/core/services/launch_client.dart';
import 'package:pop_search/features/search/application/search_execution_service.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';
import 'package:pop_search/features/search/presentation/search_screen.dart';
import 'package:pop_search/features/settings/domain/theme_repository.dart';
import 'package:pop_search/features/settings/presentation/theme_controller.dart';

class _MemoryHistoryRepository implements HistoryRepository {
  final List<String> _items = <String>[];

  @override
  Future<void> clear() async {
    _items.clear();
  }

  @override
  Future<List<String>> readRecentQueries() async => List<String>.from(_items);

  @override
  Future<void> removeQuery(String query) async {
    _items.remove(query);
  }

  @override
  Future<void> saveQuery(String query) async {
    _items.remove(query);
    _items.insert(0, query);
  }
}

class _MemoryPreferencesRepository implements PreferencesRepository {
  SearchEngine _engine = SearchEngine.google;

  @override
  Future<SearchEngine> readLastEngine() async => _engine;

  @override
  Future<void> writeLastEngine(SearchEngine engine) async {
    _engine = engine;
  }
}

class _SpyLaunchClient implements LaunchClient {
  final List<Uri> launched = <Uri>[];

  @override
  Future<bool> launchExternal(Uri uri) async {
    launched.add(uri);
    return true;
  }
}

class _MemoryThemeRepository implements ThemeRepository {
  ThemeMode _mode = ThemeMode.system;

  @override
  Future<ThemeMode> readThemeMode() async => _mode;

  @override
  Future<void> writeThemeMode(ThemeMode mode) async {
    _mode = mode;
  }
}

void main() {
  testWidgets('Enter and Go trigger search execution path', (tester) async {
    final historyRepository = _MemoryHistoryRepository();
    final preferencesRepository = _MemoryPreferencesRepository();
    final launchClient = _SpyLaunchClient();
    final executionService = SearchExecutionService(launchClient: launchClient);
    final themeController = ThemeController(_MemoryThemeRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: SearchScreen(
          historyRepository: historyRepository,
          preferencesRepository: preferencesRepository,
          executionService: executionService,
          themeController: themeController,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'first query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'second query');
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(launchClient.launched.length, 2);
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.text('second query'), findsOneWidget);
  });
}
