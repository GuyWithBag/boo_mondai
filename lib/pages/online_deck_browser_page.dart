// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/pages/online_deck_browser_page.dart
// // PURPOSE: Browse all public user-created decks with tag/language filters and copy to My Decks
// // PROVIDERS: DeckProvider
// // HOOKS: useEffect, useTextEditingController, useState
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:provider/provider.dart';
// import 'package:boo_mondai/models/models.barrel.dart';
// import 'package:boo_mondai/providers/providers.barrel.dart';
// import 'package:boo_mondai/shared/shared.barrel.dart';
// import 'package:boo_mondai/widgets/widgets.barrel.dart';

// class OnlineDeckBrowserPage extends HookWidget {
//   const OnlineDeckBrowserPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final deckProvider = context.watch<DeckProvider>();
//     final searchController = useTextEditingController();
//     final selectedLanguage = useState<String?>(null);
//     final selectedTag = useState<String?>(null);
//     final searchQuery = useState('');

//     useEffect(() {
//       final provider = context.read<DeckProvider>();
//       Future.microtask(() {
//         provider.loadDecks();
//         provider.pullPublicDecks();
//       });
//       return null;
//     }, const []);

//     useEffect(() {
//       void listener() => searchQuery.value = searchController.text;
//       searchController.addListener(listener);
//       return () => searchController.removeListener(listener);
//     }, [searchController]);

//     // Exclude decks the researcher has hidden from the public browser
//     final allDecks = deckProvider.decks
//         .where((d) => !d.hiddenInBrowser)
//         .toList();

//     // Collect all unique tags and languages from available decks
//     final allTags = {for (final d in allDecks) ...d.tags}.toList()..sort();
//     final allLanguages = {for (final d in allDecks) d.targetLanguage}.toList()
//       ..sort();

//     final filtered = allDecks.where((d) {
//       final q = searchQuery.value.trim().toLowerCase();
//       if (q.isNotEmpty &&
//           !d.title.toLowerCase().contains(q) &&
//           !d.shortDescription.toLowerCase().contains(q)) {
//         return false;
//       }
//       if (selectedLanguage.value != null &&
//           d.targetLanguage != selectedLanguage.value) {
//         return false;
//       }
//       if (selectedTag.value != null && !d.tags.contains(selectedTag.value)) {
//         return false;
//       }
//       return true;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Browse Decks'),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(56),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppSpacing.md,
//               vertical: AppSpacing.sm,
//             ),
//             child: TextField(
//               controller: searchController,
//               decoration: const InputDecoration(
//                 hintText: 'Search decks…',
//                 prefixIcon: Icon(Icons.search),
//                 isDense: true,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: deckProvider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 if (allLanguages.isNotEmpty || allTags.isNotEmpty)
//                   _FilterBar(
//                     languages: allLanguages,
//                     tags: allTags,
//                     selectedLanguage: selectedLanguage.value,
//                     selectedTag: selectedTag.value,
//                     onLanguage: (l) => selectedLanguage.value =
//                         selectedLanguage.value == l ? null : l,
//                     onTag: (t) =>
//                         selectedTag.value = selectedTag.value == t ? null : t,
//                   ),
//                 Expanded(
//                   child: filtered.isEmpty
//                       ? EmptyStateWidget(
//                           icon: Icons.explore_outlined,
//                           title: 'No decks found',
//                           actionLabel: 'Clear filters',
//                           onAction: () {
//                             searchController.clear();
//                             selectedLanguage.value = null;
//                             selectedTag.value = null;
//                           },
//                         )
//                       : RefreshIndicator(
//                           onRefresh: () =>
//                               context.read<DeckProvider>().pullPublicDecks(),
//                           child: ListView.builder(
//                             padding: const EdgeInsets.all(AppSpacing.md),
//                             itemCount: filtered.length,
//                             itemBuilder: (context, i) =>
//                                 _BrowseDeckTile(deck: filtered[i]),
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// // ── Filter bar ────────────────────────────────────────────────────

// class _FilterBar extends StatelessWidget {
//   const _FilterBar({
//     required this.languages,
//     required this.tags,
//     required this.selectedLanguage,
//     required this.selectedTag,
//     required this.onLanguage,
//     required this.onTag,
//   });

//   final List<String> languages;
//   final List<String> tags;
//   final String? selectedLanguage;
//   final String? selectedTag;
//   final void Function(String) onLanguage;
//   final void Function(String) onTag;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
//         children: [
//           for (final lang in languages)
//             _Chip(
//               label: lang,
//               selected: selectedLanguage == lang,
//               onTap: () => onLanguage(lang),
//             ),
//           if (languages.isNotEmpty && tags.isNotEmpty)
//             const SizedBox(width: AppSpacing.sm),
//           for (final tag in tags)
//             _Chip(
//               label: '#$tag',
//               selected: selectedTag == tag,
//               onTap: () => onTag(tag),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   const _Chip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     return Padding(
//       padding: const EdgeInsets.only(right: AppSpacing.xs),
//       child: FilterChip(
//         label: Text(label),
//         selected: selected,
//         onSelected: (_) => onTap(),
//         selectedColor: scheme.primaryContainer,
//         checkmarkColor: scheme.onPrimaryContainer,
//       ),
//     );
//   }
// }

// // ── Deck tile ─────────────────────────────────────────────────────

// class _BrowseDeckTile extends StatelessWidget {
//   const _BrowseDeckTile({required this.deck});

//   final Deck deck;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: AppSpacing.sm),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.md,
//           vertical: AppSpacing.sm,
//         ),
//         title: Text(deck.title, style: Theme.of(context).textTheme.titleMedium),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (deck.shortDescription.isNotEmpty)
//               Text(
//                 deck.shortDescription,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             const SizedBox(height: AppSpacing.xs),
//             Wrap(
//               spacing: AppSpacing.xs,
//               children: [
//                 MetaChip(deck.targetLanguage),
//                 MetaChip('${deck.cardCount} cards'),
//                 for (final tag in deck.tags) MetaChip('#$tag'),
//               ],
//             ),
//           ],
//         ),
//         onTap: () => showModalBottomSheet<void>(
//           context: context,
//           isScrollControlled: true,
//           useSafeArea: true,
//           builder: (_) => DeckDetailSheet(deck: deck),
//         ),
//       ),
//     );
//   }
// }
