// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: MyDecksPageController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

// typedef MyDecksWidgetController = ({
//   ScrollController scrollController,
//   TextEditingController searchController,
// });

class MyDecksPage extends HookWidget {
  const MyDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyDecksPageController>();
    // final scrollController = useScrollController();
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
        onPressed: () => context.push('/my-decks/create'),
        tooltip: 'New Deck',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SearchBar(controller: searchController),
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
          builder: (context) => ElevatedButton(
            child: Text('Create Deck'),
            onPressed: () => context.push('/my-decks/create'),
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
        return Dismissible(
          key: ValueKey(deck.id),
          direction: DismissDirection.horizontal,
          // background: _DismissBackground(alignment: Alignment.centerLeft),
          // secondaryBackground: _DismissBackground(
          //   alignment: Alignment.centerRight,
          // ),
          onDismissed: (_) => onDeleteDeck(deck.id),
          child: DeckCardTile(
            deck: deck,
            // onTap: () => context.push('/decks/${deck.id}'),
            // onStartQuiz: () => context.push('/quiz/${deck.id}'),
          ),
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

// // ── _DismissBackground ────────────────────────────────────────────────────────

// class _DismissBackground extends StatelessWidget {
//   const _DismissBackground({required this.alignment});

//   final Alignment alignment;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.incorrect,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       alignment: alignment,
//       padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
//       child: const Icon(Icons.delete_outline, color: Colors.white),
//     );
//   }
// }
