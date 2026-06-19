import 'package:boo_mondai/features/main/main.controller.dart'
    show MainController;
import 'package:flutter/material.dart'
    show WidgetBuilder, BuildContext, Colors, showModalBottomSheet;
import 'package:provider/provider.dart' show ReadContext;

Future<T?> showBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool runWithBottomNavbarHidden = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  Future<T?> show() => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    builder: builder,
  );

  if (runWithBottomNavbarHidden) {
    final mainController = context.read<MainController>();

    return mainController.runWithBottomNavbarHidden(() async {
      try {
        return await show();
      } finally {
        mainController.showBottomNavbar();
      }
    });
  }

  return show();
}
