// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/avatar_with_label.dart
// PURPOSE: Avatar circle with a label and display name for author attribution
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show AppSpacing, AppColors;
import 'package:flutter/material.dart';

class AvatarWithLabel extends StatelessWidget {
  const AvatarWithLabel({
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
    final scheme = theme.colorScheme;
    final name = displayName.trim().isEmpty ? '...' : displayName.trim();
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final imageUrl = avatarUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: isSourceAuthor ? 16 : 18,
              backgroundColor: isSourceAuthor
                  ? scheme.tertiaryContainer
                  : scheme.primaryContainer,
              backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
              child: !hasImage
                  ? Text(
                      initials,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSourceAuthor
                            ? scheme.onTertiaryContainer
                            : scheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            if (isSourceAuthor)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: scheme.tertiary,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.surface, width: 1.5),
                  ),
                ),
              ),
          ],
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
