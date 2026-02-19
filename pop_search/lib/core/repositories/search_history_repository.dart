abstract class SearchHistoryRepository {
  Future<List<String>> readRecentQueries();

  Future<void> saveQuery(String query);

  Future<void> clear();
}
