import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class TactileRadioCircle extends StatelessWidget {
  const TactileRadioCircle({required this.correct, super.key});

  final bool correct;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: correct
              ? tokens.colorActionSuccess
              : tokens.colorBorderNeutralSubtle,
          width: 3,
        ),
      ),
      child: correct
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: tokens.colorActionSuccess,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
