// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/avatar_with_label.dart
// PURPOSE: Avatar circle with a label and display name for author attribution
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show AppSpacing, AppColors;
import 'package:boo_mondai/features/profile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileLabel extends StatelessWidget {
  const ProfileLabel({
    super.key,
    required this.displayName,
    required this.label,
    this.avatarUrl,
    this.isSourceAuthor = false,
  });

  final String displayName;
  final String label;
  final String? avatarUrl;
  final bool isSourceAuthor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = displayName.trim().isEmpty ? '...' : displayName.trim();
    final imageUrl = avatarUrl?.trim();

    return Row(
      children: [
        ProfileAvatar(
          displayName: name,
          avatarUrl: imageUrl,
          radius: isSourceAuthor ? 16 : 18,
          isSourceAuthor: isSourceAuthor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
