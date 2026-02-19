import 'package:flutter_test/flutter_test.dart';
import 'package:pop_search/core/utils/search_url_builder.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';

void main() {
  const builder = SearchUrlBuilder();

  test('builds encoded URL for Google', () {
    final uri = builder.build(engine: SearchEngine.google, query: 'flutter test');

    expect(
      uri.toString(),
      'https://www.google.com/search?q=flutter+test',
    );
  });

  test('builds encoded URL for YouTube', () {
    final uri = builder.build(engine: SearchEngine.youtube, query: 'lofi mix');

    expect(
      uri.toString(),
      'https://www.youtube.com/results?search_query=lofi+mix',
    );
  });

  test('builds encoded URL for Naver', () {
    final uri = builder.build(engine: SearchEngine.naver, query: '한글 검색');

    expect(
      uri.toString(),
      'https://search.naver.com/search.naver?query=%ED%95%9C%EA%B8%80+%EA%B2%80%EC%83%89',
    );
  });

  test('builds encoded URL for Daum', () {
    final uri = builder.build(engine: SearchEngine.daum, query: 'dart uri');

    expect(
      uri.toString(),
      'https://search.daum.net/search?q=dart+uri',
    );
  });

  test('builds encoded URL for Yahoo', () {
    final uri = builder.build(engine: SearchEngine.yahoo, query: 'market news');

    expect(
      uri.toString(),
      'https://search.yahoo.com/search?p=market+news',
    );
  });
}
