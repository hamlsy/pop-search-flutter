import 'package:pop_search/core/repositories/history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHistoryRepository implements HistoryRepository {
  static const _historyKey = 'recent_queries';
  static const _maxItems = 20;

  @override
  Future<List<String>> readRecentQueries() async {
    final prefs = await SharedPreferences.getInstance();
    return List<String>.from(prefs.getStringList(_historyKey) ?? <String>[]);
  }

  @override
  Future<void> saveQuery(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final current = List<String>.from(prefs.getStringList(_historyKey) ?? <String>[]);
    current.remove(normalized);
    current.insert(0, normalized);
    if (current.length > _maxItems) {
      current.removeRange(_maxItems, current.length);
    }
    await prefs.setStringList(_historyKey, current);
  }

  @override
  Future<void> removeQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final current = List<String>.from(prefs.getStringList(_historyKey) ?? <String>[]);
    current.remove(query);
    await prefs.setStringList(_historyKey, current);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, <String>[]);
  }
}
