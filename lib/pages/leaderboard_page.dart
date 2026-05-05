// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/leaderboard_page.dart
// PURPOSE: Display global leaderboard rankings with optional language filter
// PROVIDERS: LeaderboardController
// HOOKS: useEffect, useScrollController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class LeaderboardPage extends HookWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = context.watch<LeaderboardController>();
    final scrollController = useScrollController();

    useEffect(() {
      Future.microtask(
        () => context.read<LeaderboardController>().fetchLeaderboard(),
      );
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by language',
            onSelected: (lang) =>
                context.read<LeaderboardController>().setLanguageFilter(lang),
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('All languages')),
              const PopupMenuItem(value: 'japanese', child: Text('Japanese')),
            ],
          ),
        ],
      ),
      body: leaderboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaderboard.entries.isEmpty
          ? const Center(child: Text('No entries yet'))
          : RefreshIndicator(
              onRefresh: () =>
                  context.read<LeaderboardController>().fetchLeaderboard(
                    targetLanguage: leaderboard.filteredLanguage,
                  ),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: leaderboard.entries.length,
                itemBuilder: (context, i) {
                  final entry = leaderboard.entries[i];
                  return LeaderboardTileWidget(
                    rank: i + 1,
                    username: entry.username,
                    drillScore: entry.drillScore,
                    reviewCount: entry.reviewCount,
                    currentStreak: entry.currentStreak,
                  );
                },
              ),
            ),
    );
  }
}
