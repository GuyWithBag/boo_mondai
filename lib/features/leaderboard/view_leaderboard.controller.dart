// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/leaderboard_controller.dart
// PURPOSE: UI state for leaderboard rankings with optional language filter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show RemoteDB, JoinedLeaderboardEntry;
import 'package:signals_hooks/signals_hooks.dart';

class ViewLeaderboardController {
  final entries = listSignal<JoinedLeaderboardEntry>([]);

  final error = signal<Exception?>(null);
  final isLoading = signal(false);

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;

    try {
      entries.value = await RemoteDB.leaderboard.selectJoined();
    } on Exception catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }
}
