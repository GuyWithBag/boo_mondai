import 'package:boo_mondai/lib.barrel.dart' show AppTokens, surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});
  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Surface(
      style: surfaceStyle.resolve(tokens),
      child: Column(children: [Icon(Icons.flashlight_on_sharp)]),
    );
  }
}
