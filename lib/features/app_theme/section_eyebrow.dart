import 'package:boo_mondai/lib.barrel.dart'
    show SectionEyebrowTone, AppTokens, sectionEyebrowStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow(
    this.label, {
    this.tone = SectionEyebrowTone.muted,
    super.key,
  });

  final String label;
  final SectionEyebrowTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Text(
      label.toUpperCase(),
      style: sectionEyebrowStyle.resolve(tokens, [tone]),
    );
  }
}
