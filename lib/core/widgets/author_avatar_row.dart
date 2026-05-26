// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/author_avatar_row.dart
// PURPOSE: Row displaying author and optional original-author avatars
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/theme.deprecated/app_spacing.dart'
    show AppSpacing;
import 'package:boo_mondai/core/widgets/avatar_with_label.dart'
    show AvatarWithLabel;
import 'package:flutter/material.dart';

class AuthorAvatarRow extends StatelessWidget {
  const AuthorAvatarRow({
    super.key,
    required this.authorName,
    this.authorAvatarUrl,
    this.sourceAuthorName,
    this.sourceAuthorAvatarUrl,
  });

  final String authorName;
  final String? authorAvatarUrl;
  final String? sourceAuthorName;
  final String? sourceAuthorAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasSourceAuthor =
        sourceAuthorName != null && sourceAuthorName!.trim().isNotEmpty;
    return Row(
      children: [
        AvatarWithLabel(
          displayName: authorName,
          avatarUrl: authorAvatarUrl,
          label: hasSourceAuthor ? 'Published by' : 'By',
        ),
        if (hasSourceAuthor) ...[
          const SizedBox(width: AppSpacing.lg),
          AvatarWithLabel(
            displayName: sourceAuthorName!,
            avatarUrl: sourceAuthorAvatarUrl,
            label: 'Original by',
            isSourceAuthor: true,
          ),
        ],
      ],
    );
  }
}
