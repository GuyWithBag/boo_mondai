// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/online_deck_browser/filter_bar.dart
// PURPOSE: Horizontal scrollable filter bar with language and tag chips
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class BrowserFilterBar extends StatelessWidget {
  const BrowserFilterBar({
    super.key,
    required this.languages,
    required this.tags,
    required this.selectedLanguage,
    required this.selectedTag,
    required this.onLanguage,
    required this.onTag,
  });

  final List<String> languages;
  final List<String> tags;
  final String? selectedLanguage;
  final String? selectedTag;
  final void Function(String) onLanguage;
  final void Function(String) onTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          for (final lang in languages)
            SelectableFilterChip(
              label: lang,
              selected: selectedLanguage == lang,
              onTap: () => onLanguage(lang),
            ),
          if (languages.isNotEmpty && tags.isNotEmpty)
            const SizedBox(width: AppSpacing.sm),
          for (final tag in tags)
            SelectableFilterChip(
              label: '#$tag',
              selected: selectedTag == tag,
              onTap: () => onTag(tag),
            ),
        ],
      ),
    );
  }
}
