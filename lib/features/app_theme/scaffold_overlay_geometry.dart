import 'package:flutter/widgets.dart';

class ScaffoldOverlayGeometry extends InheritedWidget {
  const ScaffoldOverlayGeometry({
    super.key,
    required this.topInset,
    required this.bottomInset,
    required super.child,
  });

  final double topInset;
  final double bottomInset;

  static ScaffoldOverlayGeometry? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScaffoldOverlayGeometry>();
  }

  @override
  bool updateShouldNotify(ScaffoldOverlayGeometry oldWidget) {
    return topInset != oldWidget.topInset ||
        bottomInset != oldWidget.bottomInset;
  }
}
