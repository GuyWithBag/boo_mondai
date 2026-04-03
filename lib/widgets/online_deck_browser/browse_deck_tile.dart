// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/pages/online_deck_browser/browse_deck_tile.dart
// // PURPOSE: List tile for a public deck in the online browser
// // PROVIDERS: none
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';
// import 'package:boo_mondai/models/models.barrel.dart';
// import 'package:boo_mondai/shared/shared.barrel.dart';
// import 'package:boo_mondai/widgets/widgets.barrel.dart';

// class BrowseDeckTile extends StatelessWidget {
//   const BrowseDeckTile({super.key, required this.deck});

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
