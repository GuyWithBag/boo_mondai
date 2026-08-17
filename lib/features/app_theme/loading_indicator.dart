import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: tokens.colorTextOnBrand,
      ),
    );
  }
}
