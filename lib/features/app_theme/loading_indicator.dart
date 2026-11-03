import 'package:boo_mondai/lib.barrel.dart' show AppTokens, ThemeController;
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
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
