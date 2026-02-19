import 'package:flutter_test/flutter_test.dart';
import 'package:pop_search/core/repositories/shared_preferences/preferences_repository_impl.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('reads default engine when nothing is stored', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = SharedPreferencesPreferencesRepository();

    final engine = await repository.readLastEngine();

    expect(engine, SearchEngine.google);
  });

  test('persists and restores selected engine', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = SharedPreferencesPreferencesRepository();

    await repository.writeLastEngine(SearchEngine.yahoo);
    final restored = await repository.readLastEngine();

    expect(restored, SearchEngine.yahoo);
  });
}
