// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/pages/review/upcoming_card_tile.dart
// // PURPOSE: List tile showing an upcoming FSRS card with countdown and state badge
// // PROVIDERS: none
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';
// import 'package:boo_mondai/models/models.barrel.dart';
// import 'package:boo_mondai/shared/shared.barrel.dart';
// import 'package:boo_mondai/widgets/widgets.barrel.dart';

// class UpcomingCardTile extends StatelessWidget {
//   const UpcomingCardTile({
//     super.key,
//     required this.fsrsCard,
//     required this.tick,
//   });

//   final FsrsCardState fsrsCard;
//   final int tick; // unused value but causes rebuild

//   String _formatDue(DateTime due) {
//     final now = DateTime.now();
//     final diff = due.difference(now);
//     if (diff.isNegative) return 'Overdue since ${_fmt(diff.abs())}';
//     return 'Due in ${_fmt(diff)}';
//   }

//   String _fmt(Duration d) {
//     final days = d.inDays;
//     final hours = d.inHours.remainder(24);
//     final minutes = d.inMinutes.remainder(60);
//     final seconds = d.inSeconds.remainder(60);
//     return '${days}d ${hours}h ${minutes}m ${seconds}s';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: StatusBadge.fsrsState(state: fsrsCard.state),
//         title: Text(
//           fsrsCard.cardId,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
//         ),
//         trailing: Text(
//           _formatDue(fsrsCard.due),
//           style: Theme.of(
//             context,
//           ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
//         ),
//       ),
//     );
//   }
// }
