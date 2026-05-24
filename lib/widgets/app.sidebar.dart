import 'package:boo_mondai/shared/shared.barrel.dart' show AppTokens;
import 'package:boo_mondai/variant_styles/surface.variant.dart';
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
