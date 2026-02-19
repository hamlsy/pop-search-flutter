import 'package:flutter_test/flutter_test.dart';
import 'package:pop_search/core/services/launch_client.dart';
import 'package:pop_search/features/search/application/search_execution_service.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';

class _FakeLaunchClient implements LaunchClient {
  _FakeLaunchClient(this._responses);

  final List<bool> _responses;
  final List<Uri> launchedUris = <Uri>[];

  @override
  Future<bool> launchExternal(Uri uri) async {
    launchedUris.add(uri);
    if (_responses.isEmpty) {
      return false;
    }
    return _responses.removeAt(0);
  }
}

void main() {
  test('blocks empty query', () async {
    final launchClient = _FakeLaunchClient(<bool>[]);
    final service = SearchExecutionService(launchClient: launchClient);

    expect(
      () => service.execute(engine: SearchEngine.google, query: '   '),
      throwsA(isA<SearchExecutionException>()),
    );
    expect(launchClient.launchedUris, isEmpty);
  });

  test('launches non-youtube engine url', () async {
    final launchClient = _FakeLaunchClient(<bool>[true]);
    final service = SearchExecutionService(launchClient: launchClient);

    await service.execute(engine: SearchEngine.google, query: 'flutter');

    expect(
      launchClient.launchedUris.single.toString(),
      'https://www.google.com/search?q=flutter',
    );
  });

  test('youtube falls back to web when app launch fails', () async {
    final launchClient = _FakeLaunchClient(<bool>[false, true]);
    final service = SearchExecutionService(launchClient: launchClient);

    await service.execute(engine: SearchEngine.youtube, query: 'lofi');

    expect(launchClient.launchedUris.length, 2);
    expect(launchClient.launchedUris.first.toString(), startsWith('vnd.youtube://'));
    expect(
      launchClient.launchedUris.last.toString(),
      'https://www.youtube.com/results?search_query=lofi',
    );
  });

  test('throws when both youtube app and web launch fail', () async {
    final launchClient = _FakeLaunchClient(<bool>[false, false]);
    final service = SearchExecutionService(launchClient: launchClient);

    expect(
      () => service.execute(engine: SearchEngine.youtube, query: 'music'),
      throwsA(isA<SearchExecutionException>()),
    );
  });
}
