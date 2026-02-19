enum SearchEngine {
  google,
  youtube,
  naver,
  daum,
  yahoo,
}

extension SearchEngineMetadata on SearchEngine {
  String get label {
    switch (this) {
      case SearchEngine.google:
        return 'Google';
      case SearchEngine.youtube:
        return 'YouTube';
      case SearchEngine.naver:
        return 'Naver';
      case SearchEngine.daum:
        return 'Daum';
      case SearchEngine.yahoo:
        return 'Yahoo';
    }
  }

  String get iconKey {
    switch (this) {
      case SearchEngine.google:
        return 'search';
      case SearchEngine.youtube:
        return 'play';
      case SearchEngine.naver:
        return 'leaf';
      case SearchEngine.daum:
        return 'spark';
      case SearchEngine.yahoo:
        return 'globe';
    }
  }

  String get urlTemplate {
    switch (this) {
      case SearchEngine.google:
        return 'https://www.google.com/search?q={query}';
      case SearchEngine.youtube:
        return 'https://www.youtube.com/results?search_query={query}';
      case SearchEngine.naver:
        return 'https://search.naver.com/search.naver?query={query}';
      case SearchEngine.daum:
        return 'https://search.daum.net/search?q={query}';
      case SearchEngine.yahoo:
        return 'https://search.yahoo.com/search?p={query}';
    }
  }
}
