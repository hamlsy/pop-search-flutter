import 'package:flutter/material.dart';
import 'package:pop_search/core/constants/legal_notices.dart';
import 'package:pop_search/core/utils/search_url_builder.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _maxRecentItems = 8;

  final TextEditingController _queryController = TextEditingController();
  final FocusNode _queryFocusNode = FocusNode();
  final SearchUrlBuilder _urlBuilder = const SearchUrlBuilder();
  final List<String> _recentQueries = <String>[];

  SearchEngine _selectedEngine = SearchEngine.google;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _queryFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _queryFocusNode.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      return;
    }

    final uri = _urlBuilder.build(engine: _selectedEngine, query: query);

    setState(() {
      _recentQueries.remove(query);
      _recentQueries.insert(0, query);
      if (_recentQueries.length > _maxRecentItems) {
        _recentQueries.removeLast();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedEngine.label}: $uri'),
      ),
    );
  }

  void _clearQuery() {
    _queryController.clear();
    _queryFocusNode.requestFocus();
    setState(() {});
  }

  IconData _iconForEngine(SearchEngine engine) {
    switch (engine.iconKey) {
      case 'search':
        return Icons.search_rounded;
      case 'play':
        return Icons.play_arrow_rounded;
      case 'leaf':
        return Icons.energy_savings_leaf_rounded;
      case 'spark':
        return Icons.auto_awesome_rounded;
      case 'globe':
        return Icons.public_rounded;
      default:
        return Icons.search_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFF4F7F3), Color(0xFFE9F1EC)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x220B1A14),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'PopSearch',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pick an engine and search instantly.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF60746B),
                              ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: SearchEngine.values.map((engine) {
                            final isSelected = engine == _selectedEngine;
                            return ChoiceChip(
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedEngine = engine;
                                });
                              },
                              avatar: Icon(
                                _iconForEngine(engine),
                                size: 18,
                                color: isSelected
                                    ? colors.onPrimary
                                    : const Color(0xFF496257),
                              ),
                              label: Text(engine.label),
                              selectedColor: colors.primary,
                              backgroundColor: const Color(0xFFEAF1ED),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? colors.onPrimary
                                    : const Color(0xFF263D33),
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _queryController,
                                focusNode: _queryFocusNode,
                                autofocus: true,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) => _submitSearch(),
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Search anything...',
                                  prefixIcon:
                                      const Icon(Icons.search_rounded, size: 20),
                                  suffixIcon: _queryController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.close_rounded,
                                            size: 20,
                                          ),
                                          onPressed: _clearQuery,
                                          tooltip: 'Clear',
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 52,
                              child: FilledButton.icon(
                                onPressed: _submitSearch,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: const Text('Go'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Recent Searches',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            if (_recentQueries.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(_recentQueries.clear);
                                },
                                child: const Text('Clear all'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_recentQueries.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F7F4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'No recent searches yet.',
                              style: TextStyle(color: Color(0xFF60746B)),
                            ),
                          )
                        else
                          Column(
                            children: _recentQueries.map((query) {
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                leading: const Icon(
                                  Icons.history_rounded,
                                  size: 18,
                                ),
                                title: Text(query),
                                trailing: IconButton(
                                  icon: const Icon(Icons.north_west_rounded),
                                  onPressed: () {
                                    _queryController.text = query;
                                    _queryController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(offset: query.length),
                                    );
                                    _submitSearch();
                                  },
                                  tooltip: 'Search again',
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          kNonAffiliationNotice,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF6D7A74),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
