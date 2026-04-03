// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/avatar_with_label.dart
// PURPOSE: Avatar circle with a label and display name for author attribution
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';

class AvatarWithLabel extends StatelessWidget {
  const AvatarWithLabel({
    super.key,
    required this.profile,
    required this.label,
    this.isSourceAuthor = false,
  });

  final CachedProfile? profile;
  final String label;
  final bool isSourceAuthor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = profile?.userName ?? '…';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: isSourceAuthor ? 16 : 18,
              backgroundColor: isSourceAuthor
                  ? scheme.tertiaryContainer
                  : scheme.primaryContainer,
              backgroundImage: profile?.avatarUrl != null
                  ? NetworkImage(profile!.avatarUrl!)
                  : null,
              child: profile?.avatarUrl == null
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
