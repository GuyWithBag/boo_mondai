// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/pages/quiz_session/identification_feedback.dart
// // PURPOSE: Shows correct/incorrect feedback for identification question type
// // PROVIDERS: none
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:flutter/material.dart';
// import 'package:boo_mondai/controllers/controllers.barrel.dart';
// import 'package:boo_mondai/models/models.barrel.dart';
// import 'package:boo_mondai/shared/shared.barrel.dart';

// class IdentificationFeedback extends StatelessWidget {
//   const IdentificationFeedback({
//     super.key,
//     required this.card,
//     required this.controller,
//   });
//   final DeckCard card;
//   final QuizSessionPageController controller;

//   @override
//   Widget build(BuildContext context) {
//     final wrong = controller.lastAnswerWrong;
//     final color = wrong ? AppColors.incorrect : AppColors.correct;
//     return Card(
//       color: color.withValues(alpha: 0.08),
//       child: Padding(
//         padding: const EdgeInsets.all(AppSpacing.sm),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(wrong ? Icons.close : Icons.check, color: color, size: 18),
//                 const SizedBox(width: 6),
//                 Text(
//                   wrong ? 'Incorrect' : 'Correct!',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.labelLarge?.copyWith(color: color),
//                 ),
//               ],
//             ),
//             if (wrong) ...[
//               const SizedBox(height: 4),
//               Text(
//                 'Accepted: ${card.acceptedIdentificationAnswers.join(', ')}',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
