import 'package:boo_mondai/lib.barrel.dart'
    show StatusLayoutState, ListingStatesWrapper;
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
          emptyState: const StatusLayoutState(
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
          emptyState: const StatusLayoutState(
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

  testWidgets('list can defer scrolling to parent scroll view', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        home: SingleChildScrollView(
          child: ListingStatesWrapper<int>.list(
            isLoading: false,
            useParentScroll: true,
            items: const [1],
            emptyState: const StatusLayoutState(
              icon: Icons.inbox,
              title: 'Empty',
              message: 'No rows',
            ),
            onRetry: () {},
            skeletonTile: const Text('Skeleton'),
            itemBuilder: (_, _, item) => Text('Item $item'),
          ),
        ),
      ),
    );

    final listView = tester.widget<ListView>(find.byType(ListView));

    expect(listView.shrinkWrap, isTrue);
    expect(listView.physics, isA<NeverScrollableScrollPhysics>());
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
          emptyState: const StatusLayoutState(
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

  testWidgets('hides header on empty state by default', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        home: ListingStatesWrapper<int>.list(
          isLoading: false,
          items: const [],
          header: const Text('Header'),
          emptyState: const StatusLayoutState(
            icon: Icons.inbox,
            title: 'Empty',
            message: 'No rows',
          ),
          onRetry: () {},
          skeletonTile: const Text('Skeleton'),
          itemBuilder: (_, _, item) => Text('Item $item'),
        ),
      ),
    );

    expect(find.text('Header'), findsNothing);
    expect(find.text('Empty'), findsOneWidget);
  });

  testWidgets('renders header on empty state when configured', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        home: ListingStatesWrapper<int>.list(
          isLoading: false,
          items: const [],
          header: const Text('Header'),
          showHeaderWhenEmpty: true,
          emptyState: const StatusLayoutState(
            icon: Icons.inbox,
            title: 'Empty',
            message: 'No rows',
          ),
          onRetry: () {},
          skeletonTile: const Text('Skeleton'),
          itemBuilder: (_, _, item) => Text('Item $item'),
        ),
      ),
    );

    expect(find.text('Header'), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
  });

  testWidgets('renders leading grid item before non-empty items', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        home: ListingStatesWrapper<int>.grid(
          isLoading: false,
          items: const [1],
          emptyState: const StatusLayoutState(
            icon: Icons.inbox,
            title: 'Empty',
            message: 'No rows',
          ),
          onRetry: () {},
          skeletonTile: const Text('Skeleton'),
          leadingItem: const Text('Leading item'),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (_, _, item) => Text('Item $item'),
        ),
      ),
    );

    expect(find.text('Leading item'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });

  testWidgets('grid can defer scrolling to parent scroll view', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        home: SingleChildScrollView(
          child: ListingStatesWrapper<int>.grid(
            isLoading: false,
            useParentScroll: true,
            items: const [1],
            emptyState: const StatusLayoutState(
              icon: Icons.inbox,
              title: 'Empty',
              message: 'No rows',
            ),
            onRetry: () {},
            skeletonTile: const Text('Skeleton'),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (_, _, item) => Text('Item $item'),
          ),
        ),
      ),
    );

    final gridView = tester.widget<GridView>(find.byType(GridView));

    expect(gridView.shrinkWrap, isTrue);
    expect(gridView.physics, isA<NeverScrollableScrollPhysics>());
    expect(find.text('Item 1'), findsOneWidget);
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
