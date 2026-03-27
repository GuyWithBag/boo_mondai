// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_list_page.dart
// PURPOSE: Browse all public decks in a responsive grid
// PROVIDERS: DeckProvider, AuthProvider
// HOOKS: useEffect, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class DeckListPage extends HookWidget {
  const DeckListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final deckProvider = context.watch<DeckProvider>();
    final searchText = useState('');

    useEffect(() {
      Future.microtask(() => context.read<DeckProvider>().fetchDecks());
      return null;
    }, const []);

    final filtered = deckProvider.decks.where((d) {
      if (searchText.value.isEmpty) return true;
      return d.title.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
            child: deckProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? const Center(child: Text('No decks found'))
                : RefreshIndicator(
                    onRefresh: () => context.read<DeckProvider>().fetchDecks(),
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
                          itemBuilder: (context, i) =>
                              DeckCardWidget(deck: filtered[i]),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
