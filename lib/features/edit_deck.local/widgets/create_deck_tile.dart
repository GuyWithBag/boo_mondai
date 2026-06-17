import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class CreateDeckTile extends StatelessWidget {
  const CreateDeckTile({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return SizedBox(
      width: 300,
      child: AspectRatio(
        aspectRatio: tokens.studyCardAspectRatio,
        child: Button.icon(
          tone: ButtonTone.dashed,
          icon: Icons.add,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
