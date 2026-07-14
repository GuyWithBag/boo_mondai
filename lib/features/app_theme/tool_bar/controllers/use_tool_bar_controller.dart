import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

import 'tool_bar.controller.dart';

ToolBarController useToolBarController() {
  final controller = useMemoized(() => ToolBarController());
  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
