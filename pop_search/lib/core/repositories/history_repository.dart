abstract class HistoryRepository {
  Future<List<String>> readRecentQueries();

  Future<void> saveQuery(String query);

  Future<void> removeQuery(String query);

  Future<void> clear();
}
