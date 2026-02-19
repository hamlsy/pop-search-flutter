import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pop_search/core/constants/legal_notices.dart';
import 'package:pop_search/core/repositories/history_repository.dart';
import 'package:pop_search/core/repositories/preferences_repository.dart';
import 'package:pop_search/features/search/application/search_execution_service.dart';
import 'package:pop_search/features/search/domain/search_engine.dart';
import 'package:pop_search/features/settings/presentation/settings_screen.dart';
import 'package:pop_search/features/settings/presentation/theme_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.historyRepository,
    required this.preferencesRepository,
    required this.executionService,
    required this.themeController,
  });

  final HistoryRepository historyRepository;
  final PreferencesRepository preferencesRepository;
  final SearchExecutionService executionService;
  final ThemeController themeController;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _queryFocusNode = FocusNode();
  final List<String> _recentQueries = <String>[];
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<Offset> _slideAnimation = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic));
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _entranceController,
    curve: Curves.easeOut,
  );

  SearchEngine _selectedEngine = SearchEngine.google;
  bool _isQueryFocused = false;

  @override
  void initState() {
    super.initState();
    _restorePersistedState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _queryFocusNode.requestFocus();
      }
    });
    _queryFocusNode.addListener(_onFocusChange);
    _entranceController.forward();
  }

  void _onFocusChange() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isQueryFocused = _queryFocusNode.hasFocus;
    });
  }

  Future<void> _restorePersistedState() async {
    final lastEngine = await widget.preferencesRepository.readLastEngine();
    final recentQueries = await widget.historyRepository.readRecentQueries();
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedEngine = lastEngine;
      _recentQueries
        ..clear()
        ..addAll(recentQueries);
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _queryFocusNode.removeListener(_onFocusChange);
    _queryFocusNode.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _submitSearch() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      return;
    }

    try {
      await widget.executionService.execute(engine: _selectedEngine, query: query);
    } on SearchExecutionException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
      return;
    }

    setState(() {
      _recentQueries.remove(query);
      _recentQueries.insert(0, query);
    });

    await widget.preferencesRepository.writeLastEngine(_selectedEngine);
    await widget.historyRepository.saveQuery(query);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opened ${_selectedEngine.label} search result.')),
    );
  }

  void _clearQuery() {
    _queryController.clear();
    _queryFocusNode.requestFocus();
    setState(() {});
  }

  Future<void> _onEngineSelected(SearchEngine engine) async {
    setState(() {
      _selectedEngine = engine;
    });
    await widget.preferencesRepository.writeLastEngine(engine);
  }

  Future<void> _clearRecentQueries() async {
    await widget.historyRepository.clear();
    if (!mounted) {
      return;
    }
    setState(_recentQueries.clear);
  }

  Future<void> _removeRecentQuery(String query) async {
    await widget.historyRepository.removeQuery(query);
    if (!mounted) {
      return;
    }
    setState(() {
      _recentQueries.remove(query);
    });
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

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(
          historyRepository: widget.historyRepository,
          themeController: widget.themeController,
          onHistoryCleared: _clearRecentQueries,
        ),
      ),
    );
    await _restorePersistedState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isApplePlatform =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);
    final colors = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final contentPadding = textScale > 1.2 ? 24.0 : 20.0;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const <Color>[Color(0xFF0F1713), Color(0xFF13221B)]
                  : const <Color>[Color(0xFFF4F7F3), Color(0xFFE9F1EC)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
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
                        color: colors.surface,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.all(contentPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'PopSearch',
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _openSettings,
                                    icon: const Icon(Icons.settings_outlined),
                                    tooltip: 'Settings',
                                    constraints: const BoxConstraints(
                                      minWidth: 48,
                                      minHeight: 48,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Pick an engine and search instantly.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? const Color(0xFF9CB4A9)
                                          : const Color(0xFF60746B),
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
                                    onSelected: (_) => _onEngineSelected(engine),
                                    avatar: Icon(
                                      _iconForEngine(engine),
                                      size: 18,
                                      color: isSelected
                                          ? colors.onPrimary
                                          : (isDark
                                              ? const Color(0xFFAAC8BA)
                                              : const Color(0xFF496257)),
                                    ),
                                    label: Text(engine.label),
                                    selectedColor: colors.primary,
                                    backgroundColor: isDark
                                        ? const Color(0xFF22372D)
                                        : const Color(0xFFEAF1ED),
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? colors.onPrimary
                                          : (isDark
                                              ? const Color(0xFFE0F1E8)
                                              : const Color(0xFF263D33)),
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
                                  if (isApplePlatform && _isQueryFocused)
                                    TextButton(
                                      onPressed: () {
                                        _queryFocusNode.unfocus();
                                      },
                                      child: const Text('Cancel'),
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
                                      onPressed: _clearRecentQueries,
                                      child: const Text('Clear all'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (_recentQueries.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1A2B23)
                                        : const Color(0xFFF3F7F4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'No recent searches yet.',
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF9CB4A9)
                                          : const Color(0xFF60746B),
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  children: _recentQueries.map((query) {
                                    return ListTile(
                                      dense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(horizontal: 8),
                                      leading: const Icon(
                                        Icons.history_rounded,
                                        size: 18,
                                      ),
                                      title: Text(query),
                                      trailing: SizedBox(
                                        width: 92,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
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
                                              constraints: const BoxConstraints(
                                                minWidth: 48,
                                                minHeight: 48,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                              ),
                                              onPressed: () => _removeRecentQuery(query),
                                              tooltip: 'Delete',
                                              constraints: const BoxConstraints(
                                                minWidth: 48,
                                                minHeight: 48,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                kNonAffiliationNotice,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? const Color(0xFFA9B7B0)
                                          : const Color(0xFF6D7A74),
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
          ),
        ),
      ),
    );
  }
}
