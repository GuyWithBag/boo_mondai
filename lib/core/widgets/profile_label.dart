// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/avatar_with_label.dart
// PURPOSE: Avatar circle with a label and display name for author attribution
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show ProfileAvatar, TextColor, TextSize, textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ProfileLabel extends StatelessWidget {
  const ProfileLabel({
    super.key,
    required this.displayName,
    this.label = 'By',
    this.avatarUrl,
    this.isSourceAuthor = false,
    this.facingLeft = false,
  });

  final String displayName;
  final String label;
  final String? avatarUrl;
  final bool isSourceAuthor;
  final bool facingLeft;

  @override
  Widget build(BuildContext context) {
    final name = displayName.trim().isEmpty ? '...' : displayName.trim();
    final imageUrl = avatarUrl?.trim();
    final tokens = context.themeTokens<AppTokens>();

    return Row(
      textDirection: facingLeft ? TextDirection.rtl : TextDirection.ltr,
      spacing: tokens.spaceLayoutGapXsm,
      children: [
        ProfileAvatar(
          displayName: name,
          avatarUrl: imageUrl,
          radius: isSourceAuthor ? 16 : 18,
          isSourceAuthor: isSourceAuthor,
        ),
        Column(
          crossAxisAlignment: facingLeft
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textStyle.resolve(tokens, const [
                TextColor.muted,
                TextSize.labelSmall,
              ]),
            ),
            Text(
              name,
              style: textStyle.resolve(tokens, const [
                TextColor.muted,
                TextSize.labelSmall,
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
