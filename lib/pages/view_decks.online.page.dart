// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_decks_online_page.dart
// PURPOSE: Browse all public user-created decks with tag filters
// HOOKS: useEffect, useTextEditingController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ViewDecksOnlinePage extends StatelessWidget {
  const ViewDecksOnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller at the page level
    return ChangeNotifierProvider(
      create: (_) => ViewDecksOnlineController()..loadPublicDecks(),
      child: const _ViewDecksOnlineView(),
    );
  }
}

class _ViewDecksOnlineView extends HookWidget {
  const _ViewDecksOnlineView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksOnlineController>();
    final searchController = useTextEditingController();

    // Store the selected tag's ID
    final selectedTagId = useState<String?>(null);
    final searchQuery = useState('');

    useEffect(() {
      void listener() => searchQuery.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    // Filter Logic
    final filtered = controller.decks.where((d) {
      final q = searchQuery.value.trim().toLowerCase();

      // Text Search
      if (q.isNotEmpty &&
          !d.title.toLowerCase().contains(q) &&
          !d.shortDescription.toLowerCase().contains(q)) {
        return false;
      }

      // Tag Search
      if (selectedTagId.value != null &&
          !d.tags.any((tag) => tag.id == selectedTagId.value)) {
        return false;
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Decks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search decks…',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (controller.availableTags.isNotEmpty)
                  _FilterBar(
                    tags: controller.availableTags,
                    selectedTagId: selectedTagId.value,
                    onTag: (tagId) {
                      selectedTagId.value = selectedTagId.value == tagId
                          ? null
                          : tagId;
                    },
                  ),
                Expanded(
                  child: filtered.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.explore_outlined,
                          title: 'No decks found',
                          actionLabel: 'Clear filters',
                          onAction: () {
                            searchController.clear();
                            selectedTagId.value = null;
                          },
                        )
                      : RefreshIndicator(
                          onRefresh: controller.loadPublicDecks,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            itemCount: filtered.length,
                            itemBuilder: (context, i) =>
                                _BrowseDeckTile(deck: filtered[i]),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

// ── Filter bar ────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.tags,
    required this.selectedTagId,
    required this.onTag,
  });

  final List<Tag> tags;
  final String? selectedTagId;
  final void Function(String) onTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          for (final tag in tags)
            _Chip(
              label: '#${tag.name}',
              selected: selectedTagId == tag.id,
              onTap: () => onTag(tag.id),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: scheme.primaryContainer,
        checkmarkColor: scheme.onPrimaryContainer,
      ),
    );
  }
}

// ── Deck tile ─────────────────────────────────────────────────────

class _BrowseDeckTile extends StatelessWidget {
  const _BrowseDeckTile({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        title: Text(deck.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (deck.shortDescription.isNotEmpty)
              Text(
                deck.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                // MetaChip('${deck.cardCount} cards'),
                // for (final tag in deck.tags) MetaChip('#${tag.name}'),
              ],
            ),
          ],
        ),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => DeckDetailSheet(deck: deck),
        ),
      ),
    );
  }
}
