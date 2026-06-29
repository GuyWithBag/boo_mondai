import 'package:boo_mondai/features/main/main.controller.dart'
    show MainController;
import 'package:flutter/material.dart'
    show WidgetBuilder, BuildContext, Colors, showModalBottomSheet;
import 'package:provider/provider.dart' show ReadContext;

Future<T?> showBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool hideBottomNavBar = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) async {
  final mainController = context.read<MainController>();
  if (hideBottomNavBar) {
    mainController.setBottomNavBarVisible(false);
  }

  final result = await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    builder: builder,
  );
  mainController.setBottomNavBarVisible(true);
  return result;
}
