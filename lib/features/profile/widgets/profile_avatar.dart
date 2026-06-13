import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.displayName,
    this.avatarUrl,
    this.radius = 18,
    this.isSourceAuthor = false,
    super.key,
  });

  final String displayName;
  final String? avatarUrl;
  final double radius;
  final bool isSourceAuthor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = displayName.trim().isEmpty ? '...' : displayName.trim();
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final imageUrl = avatarUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: isSourceAuthor
              ? scheme.tertiaryContainer
              : scheme.primaryContainer,
          backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
          child: !hasImage
              ? Text(
                  initials,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: radius * 0.7,
                    color: isSourceAuthor
                        ? scheme.onTertiaryContainer
                        : scheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                )
              : null,
        ),
        if (isSourceAuthor)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.42,
              height: radius * 0.42,
              decoration: BoxDecoration(
                color: scheme.tertiary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
