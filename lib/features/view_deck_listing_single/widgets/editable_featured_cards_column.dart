import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplate,
        CardTemplateMapper,
        CreateDeckTile,
        ViewCardsTile;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        CrossAxisAlignment,
        LayoutBuilder,
        MainAxisSize,
        StatelessWidget,
        VoidCallback,
        Widget;
import 'package:theme_variants/theme_variants.dart';

class EditableFeaturedCardsColumn extends StatelessWidget {
  const EditableFeaturedCardsColumn({
    super.key,
    required this.featuredCards,
    this.isEditable = false,
    this.maxCardCount,
    this.onAddPressed,
  }) : assert(maxCardCount == null || maxCardCount > 0);

  final List<Map<String, dynamic>> featuredCards;
  final bool isEditable;
  final int? maxCardCount;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final templates = featuredCards
        .map(_tryDecodeTemplate)
        .nonNulls
        .toList(growable: false);
    final canAddCard =
        isEditable &&
        onAddPressed != null &&
        (maxCardCount == null || featuredCards.length < maxCardCount!);

    if (templates.isEmpty && !canAddCard) {
      return const Column(mainAxisSize: MainAxisSize.min);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = math.min(constraints.maxWidth, tokens.studyCardWidth);

        return Column(
          spacing: tokens.spaceLayoutGapMd,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final template in templates)
              ViewCardsTile.template(template: template, width: tileWidth),
            if (canAddCard)
              CreateDeckTile(width: tileWidth, onPressed: onAddPressed!),
          ],
        );
      },
    );
  }

  CardTemplate? _tryDecodeTemplate(Map<String, dynamic> card) {
    try {
      return CardTemplateMapper.fromMap(card);
    } on Object {
      return null;
    }
  }
}
