import 'package:pop_search/core/services/launch_client.dart';
import 'package:pop_search/core/utils/search_url_builder.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';

class SearchExecutionException implements Exception {
  SearchExecutionException(this.message);

  final String message;

  @override
  String toString() => 'SearchExecutionException($message)';
}

class SearchExecutionService {
  SearchExecutionService({
    required LaunchClient launchClient,
    SearchUrlBuilder urlBuilder = const SearchUrlBuilder(),
  })  : _launchClient = launchClient,
        _urlBuilder = urlBuilder;

  final LaunchClient _launchClient;
  final SearchUrlBuilder _urlBuilder;

  Future<void> execute({
    required SearchEngine engine,
    required String query,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      throw SearchExecutionException('Search query is empty.');
    }

    if (engine == SearchEngine.youtube) {
      final success = await _launchYouTube(normalizedQuery);
      if (!success) {
        throw SearchExecutionException('Could not open YouTube search result.');
      }
      return;
    }

    final targetUri = _urlBuilder.build(engine: engine, query: normalizedQuery);
    final launched = await _launchClient.launchExternal(targetUri);
    if (!launched) {
      throw SearchExecutionException('Could not open search result page.');
    }
  }

  Future<bool> _launchYouTube(String query) async {
    final encoded = Uri.encodeQueryComponent(query);
    final appUri = Uri.parse('vnd.youtube://results?search_query=$encoded');
    final appLaunched = await _launchClient.launchExternal(appUri);
    if (appLaunched) {
      return true;
    }

    final webUri = _urlBuilder.build(engine: SearchEngine.youtube, query: query);
    return _launchClient.launchExternal(webUri);
  }
}
