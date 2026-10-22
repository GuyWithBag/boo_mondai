import 'package:boo_mondai/lib.barrel.dart'
    show SectionEyebrowTone, AppTokens, sectionEyebrowStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow(
    this.label, {
    this.tone = SectionEyebrowTone.muted,
    super.key,
    this.isUpperCase = true,
  });

  final String label;
  final SectionEyebrowTone tone;
  final bool isUpperCase;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Text(
      isUpperCase ? label.toUpperCase() : label,
      style: sectionEyebrowStyle.resolve(tokens, [tone]),
    );
  }
}
