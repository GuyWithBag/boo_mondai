import 'package:boo_mondai/lib.barrel.dart'
    show EmptyState, ListingStatesWrapper;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders empty state when items are empty', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        home: ListingStatesWrapper<int>.list(
          isLoading: false,
          items: const [],
          emptyState: const EmptyState(
            icon: Icons.inbox,
            title: 'Empty',
            message: 'No rows',
          ),
          onRetry: () {},
          skeletonTile: const Text('Skeleton'),
          leadingItem: const Text('Leading item'),
          itemBuilder: (_, _, item) => Text('Item $item'),
        ),
      ),
    );

    expect(find.text('Leading item'), findsNothing);
    expect(find.text('Empty'), findsOneWidget);
  });

  testWidgets('renders leading list item before non-empty items', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        home: ListingStatesWrapper<int>.list(
          isLoading: false,
          items: const [1],
          emptyState: const EmptyState(
            icon: Icons.inbox,
            title: 'Empty',
            message: 'No rows',
          ),
          onRetry: () {},
          skeletonTile: const Text('Skeleton'),
          leadingItem: const Text('Leading item'),
          itemBuilder: (_, _, item) => Text('Item $item'),
        ),
      ),
    );

    expect(find.text('Leading item'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });

  testWidgets('hides leading list item while loading when configured', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        home: ListingStatesWrapper<int>.list(
          isLoading: true,
          showLeadingItemAlways: false,
          items: const [],
          emptyState: const EmptyState(
            icon: Icons.inbox,
            title: 'Empty',
            message: 'No rows',
          ),
          onRetry: () {},
          skeletonTile: const Text('Skeleton'),
          leadingItem: const Text('Leading item'),
          itemBuilder: (_, _, item) => Text('Item $item'),
        ),
      ),
    );

    expect(find.text('Leading item'), findsNothing);
    expect(find.text('Skeleton'), findsWidgets);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => MaterialApp(home: home),
    );
  }
}
