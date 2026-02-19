import 'package:pop_search/features/search/domain/search_engine.dart';

abstract class PreferencesRepository {
  Future<SearchEngine> readLastEngine();

  Future<void> writeLastEngine(SearchEngine engine);
}
