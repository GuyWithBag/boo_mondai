import 'package:boo_mondai/features/main/main.controller.dart'
    show MainController;
import 'package:flutter/material.dart'
    show WidgetBuilder, BuildContext, Colors, showModalBottomSheet;
import 'package:provider/provider.dart' show ReadContext;

Future<T?> showBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool hideBottomNavbar = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) async {
  final mainController = context.read<MainController>();
  if (hideBottomNavbar) {
    mainController.setBottomNavbarVisible(false);
  }

  final result = await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    builder: builder,
  );
  mainController.setBottomNavbarVisible(true);
  return result;
}
