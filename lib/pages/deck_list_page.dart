// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_list_page.dart
// PURPOSE: Browse and manage user decks — search, sync, long-press multi-select, delete
// PROVIDERS: DeckProvider, CardProvider, AuthProvider
// HOOKS: useEffect, useTextEditingController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckListPage extends HookWidget {
  const DeckListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final deckProvider = context.watch<DeckProvider>();
    final cardProvider = context.watch<CardProvider>();
    final auth = context.watch<AuthProvider>();
    final searchText = useState('');
    final selectedIds = useState<Set<String>>({});

    final isSelecting = selectedIds.value.isNotEmpty;

    useEffect(() {
      final userId = auth.userProfile?.id;
      if (userId == null) return null;
      final deckProv = context.read<DeckProvider>();
      Future.microtask(() {
        if (!context.mounted) return;
        deckProv.loadUserDecks(userId);
      });
      return null;
    }, [auth.userProfile?.id]);

    final filtered = deckProvider.userDecks.where((d) {
      if (searchText.value.isEmpty) return true;
      return d.title.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();

    void refresh() {
      final uid = auth.userProfile?.id;
      if (uid == null) return;
      context.read<DeckProvider>().loadUserDecks(uid);
    }

    Future<void> startSync() async {
      final prov = context.read<CardProvider>();
      final dirtyIds = deckProvider.userDecks
          .where((d) => prov.isDirty(d.id))
          .map((d) => d.id)
          .toList();
      if (dirtyIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Everything is already up to date')),
        );
        return;
      }
      final completed = await prov.syncAll(dirtyIds);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(completed ? 'All decks synced!' : 'Sync cancelled'),
          ),
        );
      }
    }

    Future<void> deleteSelected() async {
      final toDelete = {...selectedIds.value};
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Delete ${toDelete.length} deck${toDelete.length == 1 ? '' : 's'}?',
          ),
          content: const Text(
            'These decks and all their cards will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      selectedIds.value = {};
      for (final id in toDelete) {
        if (context.mounted) {
          await context.read<DeckProvider>().deleteDeck(id);
        }
      }
    }

    void toggleSelection(String id) {
      final next = {...selectedIds.value};
      if (next.contains(id)) {
        next.remove(id);
      } else {
        next.add(id);
      }
      selectedIds.value = next;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create');
        },
        child: Icon(Icons.add_rounded),
      ),
      appBar: isSelecting
          ? _DeckListSelectionAppBar(
              count: selectedIds.value.length,
              onCancel: () => selectedIds.value = {},
              onDelete: deleteSelected,
            )
          : AppBar(
              title: const Text('My Decks'),
              actions: [
                if (cardProvider.lastSyncedAt != null)
                  _SyncTimeLabel(cardProvider.lastSyncedAt!),
                Tooltip(
                  message: cardProvider.isSyncing
                      ? 'Cancel sync'
                      : 'Sync all decks to cloud',
                  child: IconButton(
                    icon: cardProvider.isSyncing
                        ? const Icon(Icons.cancel_outlined)
                        : const Icon(Icons.sync),
                    onPressed: cardProvider.isSyncing
                        ? () => context.read<CardProvider>().cancelSync()
                        : startSync,
                  ),
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search decks...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => searchText.value = v,
              ),
            ),
            Expanded(
              child: filtered.isEmpty && !deckProvider.isLoading
                  ? const Center(child: Text('No decks found'))
                  : RefreshIndicator(
                      onRefresh: () async => refresh(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final crossCount =
                              Breakpoints.isDesktop(constraints.maxWidth)
                              ? 3
                              : Breakpoints.isTablet(constraints.maxWidth)
                              ? 2
                              : 1;
                          return GridView.builder(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossCount,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  childAspectRatio: 2.5,
                                ),
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final deck = filtered[i];
                              final dirty = cardProvider.isDirty(deck.id);
                              return DeckCardWidget(
                                deck: deck,
                                isDirty: dirty,
                                isPushing: dirty && cardProvider.isPushing,
                                isSelecting: isSelecting,
                                isSelected: selectedIds.value.contains(deck.id),
                                onSelect: () => toggleSelection(deck.id),
                                onLongPress: () => toggleSelection(deck.id),
                                onPush: dirty && !cardProvider.isPushing
                                    ? () => context
                                          .read<CardProvider>()
                                          .pushDeck(deck.id)
                                    : null,
                                onDelete: isSelecting
                                    ? null
                                    : () => _confirmDeleteSingle(
                                        context,
                                        deck.id,
                                        deck.title,
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteSingle(
    BuildContext context,
    String deckId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete deck?'),
        content: Text('"$title" will be removed from your library.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<DeckProvider>().deleteDeck(deckId);
    }
  }
}

// ── Selection app bar ──────────────────────────────────────────────

class _DeckListSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _DeckListSelectionAppBar({
    required this.count,
    required this.onCancel,
    required this.onDelete,
  });

  final int count;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: scheme.primaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel selection',
        onPressed: onCancel,
      ),
      title: Text(
        '$count selected',
        style: TextStyle(color: scheme.onPrimaryContainer),
      ),
      actions: [
        Tooltip(
          message: 'Delete selected',
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: scheme.error,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

// ── Sync time label ────────────────────────────────────────────────

class _SyncTimeLabel extends StatelessWidget {
  const _SyncTimeLabel(this.syncedAt);

  final DateTime syncedAt;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: Text(
          _formatSyncTime(syncedAt),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

String _formatSyncTime(DateTime dt) {
  final now = DateTime.now();
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final min = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour < 12 ? 'AM' : 'PM';
  if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
    return 'Synced $hour:$min $ampm';
  }
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return 'Synced ${months[dt.month - 1]} ${dt.day}';
}
