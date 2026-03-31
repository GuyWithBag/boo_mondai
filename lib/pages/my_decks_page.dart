// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: MyDecksPageController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/deck.dart';
import '../shared/app_spacing.dart';
import '../shared/theme_constants.dart';

typedef MyDecksWidgetController = ({
  ScrollController scrollController,
  TextEditingController searchController,
});

class MyDecksPage extends HookWidget {
  const MyDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyDecksPageController>();
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final searchQuery = useState('');

    useEffect(() {
      controller.load();
      return null;
    }, const []);

    useEffect(() {
      void listener() => searchQuery.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    final filteredDecks = controller.decks.where((deck) {
      final q = searchQuery.value.trim().toLowerCase();
      if (q.isEmpty) return true;
      return deck.title.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Decks')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/decks/new'),
        tooltip: 'New Deck',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _SearchBar(controller: searchController),
          Expanded(
            child: _DeckListBody(
              isLoading: controller.isLoading,
              error: controller.error,
              decks: filteredDecks,
              onRetry: controller.load,
              onDeleteDeck: controller.deleteDeck,
            ),
          ),
        ],
      ),
    );
  }
}

// ── _SearchBar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search decks…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: controller.clear,
              );
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        ),
      ),
    );
  }
}

// ── _DeckListBody ─────────────────────────────────────────────────────────────

class _DeckListBody extends StatelessWidget {
  const _DeckListBody({
    required this.isLoading,
    required this.error,
    required this.decks,
    required this.onRetry,
    required this.onDeleteDeck,
  });

  final bool isLoading;
  final String? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final void Function(String id) onDeleteDeck;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return ErrorState(message: error!, onRetry: onRetry);
    }

    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.sm.h,
          ),
          itemCount: 3,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (_, __) => _PlaceholderDeckTile(),
        ),
      );
    }

    if (decks.isEmpty) {
      return EmptyState(
        icon: Icons.layers,
        title: 'No decks yet',
        message: 'Create your first deck to get started',
        action: Builder(
          builder: (context) => PrimaryButton(
            text: 'Create Deck',
            onPressed: () => context.push('/decks/new'),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      itemCount: decks.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm.h),
      itemBuilder: (context, index) {
        final deck = decks[index];
        return _DismissibleDeckTile(
          deck: deck,
          onDismissed: () => onDeleteDeck(deck.id),
        );
      },
    );
  }
}

// ── _PlaceholderDeckTile ──────────────────────────────────────────────────────

class _PlaceholderDeckTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Container(
                    height: 12.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── _DismissibleDeckTile ──────────────────────────────────────────────────────

class _DismissibleDeckTile extends StatelessWidget {
  const _DismissibleDeckTile({required this.deck, required this.onDismissed});

  final Deck deck;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(deck.id),
      direction: DismissDirection.horizontal,
      background: _DismissBackground(alignment: Alignment.centerLeft),
      secondaryBackground: _DismissBackground(alignment: Alignment.centerRight),
      onDismissed: (_) => onDismissed(),
      child: DeckCardTile(
        deck: deck,
        // onTap: () => context.push('/decks/${deck.id}'),
        // onStartQuiz: () => context.push('/quiz/${deck.id}'),
      ),
    );
  }
}

// ── _DismissBackground ────────────────────────────────────────────────────────

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.incorrect,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }
}
