import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChipInput, ChipTone, EditableTextValue, SectionEyebrow;
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
    this.tagsEnabled = true,
    this.tagsPlaceholder,
    this.tagsTone = ChipTone.ghost,
    super.key,
  });

  final EditableTextValue title;
  final Widget? metaLabels;
  final EditableTextValue shortDescription;
  final EditableTextValue longDescription;
  final List<String> tags;
  final ValueChanged<List<String>>? onTagsChanged;
  final bool tagsEnabled;
  final String? tagsPlaceholder;
  final ChipTone tagsTone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(height: tokens.spaceLayoutGapSm),
        if (metaLabels != null) ...[
          metaLabels!,
          SizedBox(height: tokens.spaceLayoutGapMd),
        ],
        shortDescription,
        SizedBox(height: tokens.spaceLayoutGapSm),
        longDescription,
        SizedBox(height: tokens.spaceLayoutGapLg),
        const SectionEyebrow('Tags'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        ChipInput(
          values: tags,
          onChanged: onTagsChanged ?? (_) {},
          placeholder: tagsPlaceholder ?? 'No tags yet',
          isEnabled: tagsEnabled,
          chipTone: tagsTone,
        ),
      ],
    );
  }
}
