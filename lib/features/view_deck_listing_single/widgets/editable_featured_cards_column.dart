import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplate,
        CardTemplateMapper,
        CreateDeckTile,
        ViewCardsTile,
        surfaceStyle,
        SurfaceShape,
        SurfaceBorder;
import 'package:flutter/material.dart';
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

    final body = templates.isEmpty && !canAddCard
        ? const Text('This deck contains no cards featured.')
        : LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = math.min(
                constraints.maxWidth,
                tokens.studyCardWidth,
              );

              return Column(
                spacing: tokens.spaceLayoutGapMd,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final template in templates)
                    ViewCardsTile.template(
                      template: template,
                      width: tileWidth,
                    ),
                  if (canAddCard)
                    CreateDeckTile(width: tileWidth, onPressed: onAddPressed!),
                ],
              );
            },
          );

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceShape.roundedSm,
        SurfaceBorder.none,
      ]),
      child: body,
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
