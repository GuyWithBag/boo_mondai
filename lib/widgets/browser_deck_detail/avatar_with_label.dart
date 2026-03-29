// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/avatar_with_label.dart
// PURPOSE: Avatar circle with a label and display name for author attribution
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/browser_deck_detail/profile_info.dart';

class AvatarWithLabel extends StatelessWidget {
  const AvatarWithLabel({
    super.key,
    required this.profile,
    required this.label,
    this.isOriginal = false,
  });

  final ProfileInfo? profile;
  final String label;
  final bool isOriginal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = profile?.displayName ?? '…';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: isOriginal ? 16 : 18,
              backgroundColor: isOriginal
                  ? scheme.tertiaryContainer
                  : scheme.primaryContainer,
              backgroundImage: profile?.avatarUrl != null
                  ? NetworkImage(profile!.avatarUrl!)
                  : null,
              child: profile?.avatarUrl == null
                  ? Text(
                      initials,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isOriginal
                            ? scheme.onTertiaryContainer
                            : scheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            if (isOriginal)
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
