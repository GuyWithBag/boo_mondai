import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChipInput,
        ChipTone,
        EditableTextValue,
        SectionEyebrow,
        TextSize,
        textStyle,
        TextWeight;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class DeckDetails extends StatelessWidget {
  const DeckDetails({
    required this.title,
    required this.metaLabels,
    required this.shortDescription,
    required this.longDescription,
    required this.tags,
    this.onTagsChanged,
    this.areTagsEditable = true,
    this.tagsPlaceholder,
    this.tagsTone = ChipTone.ghost,
    super.key,
    this.isEditable = false,
    this.onShortDescriptionChanged,
    this.onLongDescriptionChanged,
    this.onTitleChanged,
  });

  final String title;
  final Widget? metaLabels;
  final String shortDescription;
  final String longDescription;
  final Future<void> Function(String)? onTitleChanged;
  final Future<void> Function(String)? onShortDescriptionChanged;
  final Future<void> Function(String)? onLongDescriptionChanged;
  final List<String> tags;
  final ValueChanged<List<String>>? onTagsChanged;
  final bool areTagsEditable;
  final String? tagsPlaceholder;
  final ChipTone tagsTone;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditableTextValue(
          value: title,
          enabled: isEditable,
          placeholder: 'Deck title',
          onSave: onTitleChanged,
          textStyle: textStyle.resolve(tokens, const [
            TextSize.header,
            TextWeight.heavy,
          ]),
        ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        if (metaLabels != null) ...[
          metaLabels!,
          SizedBox(height: tokens.spaceLayoutGapMd),
        ],
        EditableTextValue(
          value: shortDescription,
          enabled: isEditable,
          placeholder: 'Short description',
          isMarkdown: true,
          onSave: onShortDescriptionChanged,
          textStyle: textStyle.resolve(tokens, const [
            TextSize.labelSmall,
            TextWeight.body,
          ]),
        ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        EditableTextValue(
          value: longDescription,
          enabled: isEditable,
          placeholder: 'Long description',
          maxLines: null,
          isMarkdown: true,
          onSave: onLongDescriptionChanged,
          textStyle: textStyle.resolve(tokens, const [
            TextSize.bodyLarge,
            TextWeight.body,
          ]),
        ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        Surface(
          style: surfaceStyle.resolve(tokens, const [
            SurfaceBorder.none,
            SurfaceShape.roundedXsm,
          ]),
          child: Column(
            spacing: tokens.spaceLayoutGapSm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionEyebrow('Tags'),
              ChipInput(
                values: tags,
                onChanged: onTagsChanged ?? (_) {},
                placeholder: tagsPlaceholder ?? 'No tags yet',
                isEditable: areTagsEditable,
                chipTone: tagsTone,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
