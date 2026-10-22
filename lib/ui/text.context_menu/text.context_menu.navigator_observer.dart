import 'package:boo_mondai/ui/text.context_menu/text.context_menu.controller.dart';
import 'package:flutter/widgets.dart';

class TextContextMenuNavigatorObserver extends NavigatorObserver {
  void dismissMenu() {
    TextContextMenuController.instance.dismiss();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    dismissMenu();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    dismissMenu();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    dismissMenu();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
