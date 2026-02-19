import 'package:flutter/material.dart';
import 'package:pop_search/core/constants/legal_notices.dart';
import 'package:pop_search/core/constants/privacy_notice.dart';
import 'package:pop_search/core/repositories/history_repository.dart';
import 'package:pop_search/features/settings/presentation/theme_controller.dart';
import 'package:pop_search/features/settings/presentation/widgets/android_banner_ad_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.historyRepository,
    required this.themeController,
    required this.onHistoryCleared,
  });

  final HistoryRepository historyRepository;
  final ThemeController themeController;
  final Future<void> Function() onHistoryCleared;

  Future<void> _clearHistory(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Clear history?'),
              content: const Text(
                'This will remove all recent search entries on this device.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Clear'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    await historyRepository.clear();
    await onHistoryCleared();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recent searches cleared.')),
    );
  }

  Future<void> _selectThemeMode(ThemeMode mode) async {
    await themeController.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Theme Mode',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: themeController,
            builder: (_, __) {
              return Column(
                children: <Widget>[
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeController.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        _selectThemeMode(value);
                      }
                    },
                    title: const Text('System'),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: themeController.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        _selectThemeMode(value);
                      }
                    },
                    title: const Text('Light'),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: themeController.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        _selectThemeMode(value);
                      }
                    },
                    title: const Text('Dark'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _clearHistory(context),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Clear History'),
          ),
          const SizedBox(height: 20),
          Text(
            kNonAffiliationNotice,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            kPrivacyNotice,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const AndroidBannerAdSection(),
        ],
      ),
    );
  }
}
