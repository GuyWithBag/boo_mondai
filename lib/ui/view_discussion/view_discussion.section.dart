import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Content,
        SectionEyebrow,
        ViewCommentsSection,
        ViewReviewsSection;
import 'package:flutter/material.dart'
    show Widget, BuildContext, SizedBox, CrossAxisAlignment, Column;
import 'package:signals_hooks/signals_hooks.dart';

import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class ViewDiscussionSection extends SignalHookWidget {
  const ViewDiscussionSection({super.key, required this.rootContent});

  final Content rootContent;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow('Reviews'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        ViewReviewsSection(rootContent: rootContent),

        SizedBox(height: tokens.spaceLayoutGapLg),

        SectionEyebrow('Comments'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        ViewCommentsSection(rootContent: rootContent),
      ],
    );
  }
}
