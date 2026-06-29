import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class CreateDeckTile extends StatelessWidget {
  const CreateDeckTile({super.key, required this.onPressed, this.width});

  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return SizedBox(
      width: width ?? 300,
      child: AspectRatio(
        aspectRatio: tokens.studyCardAspectRatio,
        child: Button.dashed(
          tokens: tokens,
          leading: const Icon(Icons.add),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
