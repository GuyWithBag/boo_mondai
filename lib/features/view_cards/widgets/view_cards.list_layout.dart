import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, EmptyState, ListingStatesWrapper, ViewCardsLayoutMode;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsListLayout<TEntry> extends StatelessWidget {
  const ViewCardsListLayout({
    required this.isLoading,
    required this.exception,
    required this.entries,
    required this.emptyState,
    required this.onRetry,
    required this.layoutMode,
    required this.entryBuilder,
    super.key,
  });

  final bool isLoading;
  final Exception? exception;
  final List<TEntry> entries;
  final EmptyState emptyState;
  final VoidCallback onRetry;
  final ViewCardsLayoutMode layoutMode;
  final Widget Function(BuildContext context, int index, TEntry entry)
  entryBuilder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    if (layoutMode == ViewCardsLayoutMode.compact) {
      return ListingStatesWrapper<TEntry>.grid(
        isLoading: isLoading,
        exception: exception,
        items: entries,
        emptyState: emptyState,
        onRetry: onRetry,
        skeletonTile: GridTileMaxWidthConstraints(
          builder: (width) => ViewCardSkeletonTile(width: width),
        ),
        useParentScroll: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: tokens.studyCardWidth,
          mainAxisSpacing: tokens.spaceLayoutGapMd,
          crossAxisSpacing: tokens.spaceLayoutGapMd,
          childAspectRatio: viewCardGridAspectRatio(tokens),
        ),
        itemBuilder: entryBuilder,
      );
    }

    return ListingStatesWrapper<TEntry>.wrap(
      isLoading: isLoading,
      exception: exception,
      items: entries,
      emptyState: emptyState,
      onRetry: onRetry,
      skeletonTile: const ViewCardSkeletonTile(),
      spacing: tokens.spaceLayoutGapMd,
      runSpacing: tokens.spaceLayoutGapMd,
      itemBuilder: entryBuilder,
    );
  }
}

class ViewCardSkeletonTile extends StatelessWidget {
  const ViewCardSkeletonTile({this.width = 280, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 0.7142857142857143,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

class GridTileMaxWidthConstraints extends StatelessWidget {
  const GridTileMaxWidthConstraints({required this.builder, super.key});

  final Widget Function(double width) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(constraints.maxWidth),
    );
  }
}

double viewCardGridAspectRatio(AppTokens tokens) {
  return tokens.studyCardAspectRatio * 0.86;
}
