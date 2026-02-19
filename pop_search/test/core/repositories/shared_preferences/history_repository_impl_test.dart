import 'package:flutter_test/flutter_test.dart';
import 'package:pop_search/core/repositories/shared_preferences/history_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('stores recent queries with dedupe and max 20 policy', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = SharedPreferencesHistoryRepository();

    for (var i = 0; i < 25; i++) {
      await repository.saveQuery('q$i');
    }
    await repository.saveQuery('q22');

    final history = await repository.readRecentQueries();

    expect(history.length, 20);
    expect(history.first, 'q22');
    expect(history.where((q) => q == 'q22').length, 1);
  });

  test('removes single query and clears all history', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = SharedPreferencesHistoryRepository();

    await repository.saveQuery('alpha');
    await repository.saveQuery('beta');
    await repository.removeQuery('alpha');

    var history = await repository.readRecentQueries();
    expect(history, <String>['beta']);

    await repository.clear();
    history = await repository.readRecentQueries();
    expect(history, isEmpty);
  });
}
