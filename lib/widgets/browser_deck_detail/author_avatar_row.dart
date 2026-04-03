// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/author_avatar_row.dart
// PURPOSE: Row displaying author and optional original-author avatars
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/cached_profile.dart';
import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/browser_deck_detail/avatar_with_label.dart';

class AuthorAvatarRow extends StatelessWidget {
  const AuthorAvatarRow({
    super.key,
    required this.author,
    required this.sourceAuthor,
  });

  final CachedProfile? author;
  final CachedProfile? sourceAuthor;

  @override
  Widget build(BuildContext context) {
    final hasSourceAuthor = sourceAuthor != null;
    return Row(
      children: [
        AvatarWithLabel(
          profile: author,
          label: hasSourceAuthor ? 'Published by' : 'By',
        ),
        if (hasSourceAuthor) ...[
          const SizedBox(width: AppSpacing.lg),
          AvatarWithLabel(
            profile: sourceAuthor,
            label: 'Original by',
            isSourceAuthor: true,
          ),
        ],
      ],
    );
  }
}
