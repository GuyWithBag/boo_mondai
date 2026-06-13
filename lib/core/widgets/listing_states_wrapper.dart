import 'package:boo_mondai/lib.barrel.dart' show EmptyState, ErrorState;
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListingStatesWrapper<T> extends StatelessWidget {
  /// Private base constructor. Handles the state logic.
  const ListingStatesWrapper({
    super.key,
    required this.isLoading,
    this.exception,
    required this.items,
    required this.emptyState,
    required this.onRetry,
    required this.skeletonTile,
    required this.itemBuilder,
    required this.layoutBuilder,
    this.leadingItem,
    this.showLeadingItemAlways = true,
  });

  /// 1. Constructor for ListView.separated
  ListingStatesWrapper.list({
    super.key,
    required this.isLoading,
    this.exception,
    required this.items,
    required this.emptyState,
    required this.onRetry,
    required this.skeletonTile,
    required this.itemBuilder,
    EdgeInsetsGeometry? padding,
    double separatorHeight = 12.0,
    this.leadingItem,
    this.showLeadingItemAlways = true,
  }) : layoutBuilder = ((context, itemCount, builder) {
         final showLeading =
             leadingItem != null && (showLeadingItemAlways || items.isNotEmpty);
         return ListView.separated(
           padding: padding,
           itemCount: itemCount + (showLeading ? 1 : 0),
           separatorBuilder: (_, _) => SizedBox(height: separatorHeight),
           itemBuilder: (context, index) {
             if (showLeading && index == 0) return leadingItem;
             return builder(context, showLeading ? index - 1 : index);
           },
         );
       });

  /// 2. Constructor for GridView
  ListingStatesWrapper.grid({
    super.key,
    required this.isLoading,
    this.exception,
    this.leadingItem,
    this.showLeadingItemAlways = true,
    required this.items,
    required this.emptyState,
    required this.onRetry,
    required this.skeletonTile,
    required this.itemBuilder,
    required SliverGridDelegate gridDelegate,
    EdgeInsetsGeometry? padding,
  }) : layoutBuilder = ((context, itemCount, builder) {
         return GridView.builder(
           padding: padding,
           gridDelegate: gridDelegate,
           itemCount: itemCount,
           itemBuilder: builder,
         );
       });

  /// 3. Constructor for Wrap
  ListingStatesWrapper.wrap({
    super.key,
    required this.isLoading,
    this.exception,
    required this.items,
    required this.emptyState,
    required this.onRetry,
    required this.skeletonTile,
    required this.itemBuilder,
    this.leadingItem,
    this.showLeadingItemAlways = true,
    double spacing = 8.0,
    double runSpacing = 8.0,
    WrapAlignment alignment = WrapAlignment.start,
  }) : layoutBuilder = ((context, itemCount, builder) {
         final showLeading =
             leadingItem != null && (showLeadingItemAlways || items.isNotEmpty);
         return Wrap(
           spacing: spacing,
           runSpacing: runSpacing,
           alignment: alignment,
           children: [
             if (showLeading) leadingItem,
             ...List.generate(itemCount, (index) => builder(context, index)),
           ],
         );
       });

  final bool isLoading;
  final Exception? exception;
  final List<T> items;
  final EmptyState emptyState;
  final VoidCallback onRetry;
  final Widget skeletonTile;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(
    BuildContext context,
    int itemCount,
    Widget Function(BuildContext context, int index) layoutItemBuilder,
  )
  layoutBuilder;

  /// An item to add at the start of the list
  final Widget? leadingItem;
  final bool showLeadingItemAlways;

  @override
  Widget build(BuildContext context) {
    if (exception != null) {
      return ErrorState(exception: exception, onRetry: onRetry);
    }

    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: layoutBuilder(
          context,
          6, // The number of dummy skeleton items to show
          (context, index) => skeletonTile,
        ),
      );
    }

    if (items.isEmpty) {
      return emptyState;
    }

    return layoutBuilder(context, items.length, (context, index) {
      final item = items[index];
      return itemBuilder(context, index, item);
    });
  }
}
