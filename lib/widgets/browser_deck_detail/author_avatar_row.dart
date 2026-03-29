// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/author_avatar_row.dart
// PURPOSE: Row displaying author and optional original-author avatars
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/browser_deck_detail/avatar_with_label.dart';
import 'package:boo_mondai/widgets/browser_deck_detail/profile_info.dart';

class AuthorAvatarRow extends StatelessWidget {
  const AuthorAvatarRow({
    super.key,
    required this.authorProfile,
    required this.originalAuthorProfile,
    required this.hasOriginal,
  });

  final ProfileInfo? authorProfile;
  final ProfileInfo? originalAuthorProfile;
  final bool hasOriginal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarWithLabel(
          profile: authorProfile,
          label: hasOriginal ? 'Published by' : 'By',
        ),
        if (hasOriginal) ...[
          const SizedBox(width: AppSpacing.lg),
          AvatarWithLabel(
            profile: originalAuthorProfile,
            label: 'Original by',
            isOriginal: true,
          ),
        ],
      ],
    );
  }
}
