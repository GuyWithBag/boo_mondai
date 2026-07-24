import 'package:boo_mondai/lib.barrel.dart' show StatusLayoutState, ErrorState;
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListingStatesWrapper<T> extends StatelessWidget {
  /// Private base constructor. Handles the state logic.
  const ListingStatesWrapper({
    super.key,
    this.isLoading = false,
    this.exception,
    required this.items,
    this.emptyState,
    this.onRetry,
    this.skeletonTile,
    required this.itemBuilder,
    required this.layoutBuilder,
    this.leadingItem,
    this.showLeadingItemAlways = true,
    this.header,
    this.showHeaderWhenEmpty = false,
  });

  /// 1. Constructor for ListView.separated
  ListingStatesWrapper.list({
    super.key,
    this.isLoading = false,
    this.exception,
    required this.items,
    this.emptyState,
    this.onRetry,
    this.skeletonTile,
    required this.itemBuilder,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    double separatorHeight = 12.0,
    this.leadingItem,
    this.showLeadingItemAlways = true,
    this.header,
    this.showHeaderWhenEmpty = false,
    bool useParentScroll = false,
    bool reverse = false,
  }) : layoutBuilder = ((context, itemCount, builder) {
         final showLeading =
             leadingItem != null && (showLeadingItemAlways || items.isNotEmpty);
         return ListView.separated(
           padding: padding,
           reverse: reverse,
           shrinkWrap: useParentScroll,
           physics: useParentScroll
               ? const NeverScrollableScrollPhysics()
               : null,
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
    this.isLoading = false,
    this.exception,
    this.leadingItem,
    this.showLeadingItemAlways = true,
    this.header,
    this.showHeaderWhenEmpty = false,
    required this.items,
    this.emptyState,
    this.onRetry,
    this.skeletonTile,
    required this.itemBuilder,
    required SliverGridDelegate gridDelegate,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    bool useParentScroll = false,
    bool reverse = false,
    TextDirection textDirection = TextDirection.ltr,
  }) : layoutBuilder = ((context, itemCount, builder) {
         final showLeading =
             leadingItem != null && (showLeadingItemAlways || items.isNotEmpty);
         return Directionality(
           textDirection: textDirection,
           child: GridView.builder(
             padding: padding,
             reverse: reverse,
             shrinkWrap: useParentScroll,

             physics: useParentScroll
                 ? const NeverScrollableScrollPhysics()
                 : null,
             gridDelegate: gridDelegate,
             itemCount: itemCount + (showLeading ? 1 : 0),
             itemBuilder: (context, index) {
               if (showLeading && index == 0) return leadingItem;
               return builder(context, showLeading ? index - 1 : index);
             },
           ),
         );
       });

  /// 3. Constructor for Wrap
  ListingStatesWrapper.wrap({
    super.key,
    this.isLoading = false,
    this.exception,
    required this.items,
    this.emptyState,
    this.onRetry,
    this.skeletonTile,
    required this.itemBuilder,
    this.leadingItem,
    this.showLeadingItemAlways = true,
    this.header,
    this.showHeaderWhenEmpty = false,
    double spacing = 8.0,
    double runSpacing = 8.0,
    WrapAlignment alignment = WrapAlignment.start,
    bool reverse = false,
  }) : layoutBuilder = ((context, itemCount, builder) {
         final showLeading =
             leadingItem != null && (showLeadingItemAlways || items.isNotEmpty);
         final children = <Widget>[
           if (showLeading) leadingItem,
           ...List.generate(itemCount, (index) => builder(context, index)),
         ];
         return Wrap(
           spacing: spacing,
           runSpacing: runSpacing,
           alignment: alignment,
           children: reverse ? children.reversed.toList() : children,
         );
       });

  final bool isLoading;
  final Exception? exception;
  final List<T> items;
  final StatusLayoutState? emptyState;
  final VoidCallback? onRetry;
  final Widget? skeletonTile;
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
  final Widget? header;
  final bool showHeaderWhenEmpty;

  @override
  Widget build(BuildContext context) {
    if (exception != null) {
      return _withHeader(ErrorState(exception: exception, onRetry: onRetry));
    }

    if (isLoading) {
      return _withHeader(
        Skeletonizer(
          enabled: true,
          child: layoutBuilder(
            context,
            6, // The number of dummy skeleton items to show
            (context, index) => skeletonTile ?? SizedBox.shrink(),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return _withHeader(emptyState, isEmpty: true);
    }

    return _withHeader(
      layoutBuilder(context, items.length, (context, index) {
        final item = items[index];
        return itemBuilder(context, index, item);
      }),
    );
  }

  Widget _withHeader(Widget? body, {bool isEmpty = false}) {
    final shouldShowHeader =
        header != null && (!isEmpty || showHeaderWhenEmpty);
    if (!shouldShowHeader) return body ?? SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header!,
        if (body != null) Expanded(child: body),
      ],
    );
  }
}
