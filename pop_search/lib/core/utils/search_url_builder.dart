import 'package:pop_search/features/search/domain/search_engine.dart';

class SearchUrlBuilder {
  const SearchUrlBuilder();

  Uri build({
    required SearchEngine engine,
    required String query,
  }) {
    final encodedQuery = Uri.encodeQueryComponent(query.trim());
    final url = engine.urlTemplate.replaceAll('{query}', encodedQuery);
    return Uri.parse(url);
  }
}
