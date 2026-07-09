import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChipInput,
        ChipTone,
        DeckFormValidator,
        EditableTextValue,
        FormField,
        SectionEyebrow,
        TextSize,
        textStyle,
        TextWeight;
import 'package:flutter/material.dart' hide FormField;
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
        if (isEditable)
          FormField<String>(
            value: title,
            validator: DeckFormValidator.title,
            builder: (_, field) => EditableTextValue(
              value: title,
              placeholder: 'Deck title',
              onSave: (value) async {
                field.didChange(value);
                if (field.validate()) {
                  await onTitleChanged?.call(value);
                }
              },
              textStyle: textStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
          )
        else
          EditableTextValue(
            value: title,
            enabled: false,
            placeholder: 'Deck title',
            onSave: null,
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
        if (isEditable)
          FormField<String>(
            value: shortDescription,
            validator: DeckFormValidator.optionalText,
            builder: (_, field) => EditableTextValue(
              value: shortDescription,
              placeholder: 'Short description',
              isMarkdown: true,
              onSave: (value) async {
                field.didChange(value);
                if (field.validate()) {
                  await onShortDescriptionChanged?.call(value);
                }
              },
              textStyle: textStyle.resolve(tokens, const [
                TextSize.labelSmall,
                TextWeight.body,
              ]),
            ),
          )
        else
          EditableTextValue(
            value: shortDescription,
            enabled: false,
            placeholder: 'Short description',
            isMarkdown: true,
            onSave: null,
            textStyle: textStyle.resolve(tokens, const [
              TextSize.labelSmall,
              TextWeight.body,
            ]),
          ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        if (isEditable)
          FormField<String>(
            value: longDescription,
            validator: DeckFormValidator.optionalText,
            builder: (_, field) => EditableTextValue(
              value: longDescription,
              placeholder: 'Long description',
              maxLines: null,
              isMarkdown: true,
              onSave: (value) async {
                field.didChange(value);
                if (field.validate()) {
                  await onLongDescriptionChanged?.call(value);
                }
              },
              textStyle: textStyle.resolve(tokens, const [
                TextSize.body,
                TextWeight.body,
              ]),
            ),
          )
        else
          EditableTextValue(
            value: longDescription,
            enabled: false,
            placeholder: 'Long description',
            maxLines: null,
            isMarkdown: true,
            onSave: null,
            textStyle: textStyle.resolve(tokens, const [
              TextSize.body,
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
              if (areTagsEditable)
                FormField<List<String>>(
                  value: tags,
                  validator: DeckFormValidator.tags,
                  builder: (_, field) => ChipInput(
                    values: tags,
                    onChanged: (values) {
                      field.didChange(values);
                      if (field.validate()) {
                        onTagsChanged?.call(values);
                      }
                    },
                    placeholder: tagsPlaceholder ?? 'No tags yet',
                    isEditable: true,
                    chipTone: tagsTone,
                  ),
                )
              else
                ChipInput(
                  values: tags,
                  onChanged: (_) {},
                  placeholder: tagsPlaceholder ?? 'No tags yet',
                  isEditable: false,
                  chipTone: tagsTone,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
