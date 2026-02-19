import 'package:pop_search/core/repositories/preferences_repository.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPreferencesRepository implements PreferencesRepository {
  static const _engineKey = 'last_engine_key';

  @override
  Future<SearchEngine> readLastEngine() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getString(_engineKey);
    return SearchEngine.values.firstWhere(
      (engine) => engine.name == storedValue,
      orElse: () => SearchEngine.google,
    );
  }

  @override
  Future<void> writeLastEngine(SearchEngine engine) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_engineKey, engine.name);
  }
}
