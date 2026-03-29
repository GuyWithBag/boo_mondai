// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review/upcoming_only_view.dart
// PURPOSE: View shown when all reviewable cards are done but upcoming cards remain
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class UpcomingOnlyView extends StatelessWidget {
  const UpcomingOnlyView({
    super.key,
    required this.upcomingCards,
    required this.tick,
  });

  final List<FsrsCardState> upcomingCards;
  final int tick; // causes rebuild every second for live countdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AllDoneHeader(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Coming up',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: ListView.separated(
                      itemCount: upcomingCards.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) {
                        final card = upcomingCards[i];
                        return UpcomingCardTile(fsrsCard: card, tick: tick);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
