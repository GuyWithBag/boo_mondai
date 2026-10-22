import 'package:flutter/widgets.dart';

import 'controllers/tool_bar.controller.dart';

class ToolBarScope extends InheritedWidget {
  const ToolBarScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final ToolBarController controller;

  static ToolBarController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ToolBarScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(ToolBarScope oldWidget) {
    return oldWidget.controller != controller;
  }
}
