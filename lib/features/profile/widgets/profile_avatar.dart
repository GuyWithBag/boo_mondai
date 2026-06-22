import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BackgroundImagePicked,
        BackgroundImageSurface,
        Button,
        ButtonColor,
        SurfaceBorder,
        SurfaceShape,
        ImageHelper,
        pickBackgroundImageFile,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.displayName,
    this.avatarUrl,
    this.radius = 18,
    this.isSourceAuthor = false,
    this.onImagePicked,
    super.key,
  });

  final String displayName;
  final String? avatarUrl;
  final double radius;
  final bool isSourceAuthor;
  final BackgroundImagePicked? onImagePicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = displayName.trim().isEmpty ? '...' : displayName.trim();
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final imageUrl = avatarUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final image = ImageHelper.getImageProviderFromSource(imageUrl);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox.square(
          dimension: radius * 2,
          child: BackgroundImageSurface(
            image: image,
            onImagePicked: onImagePicked,
            missingImageIcon: null,
            style: surfaceStyle.resolve(
              context.themeTokens<AppTokens>(),
              const [SurfaceShape.circle, SurfaceBorder.none],
            ),
            child: !hasImage
                ? Center(
                    child: Text(
                      initials,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: radius * 0.7,
                        color: isSourceAuthor
                            ? scheme.onTertiaryContainer
                            : scheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  )
                : null,
          ),
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
        if (onImagePicked != null)
          Positioned(
            right: -radius * 0.08,
            bottom: -radius * 0.08,
            child: Button.iconSmall(
              icon: Icons.edit,
              color: ButtonColor.primary,
              onPressed: () => _pickAndApplyImage(onImagePicked!),
            ),
          ),
      ],
    );
  }

  Future<void> _pickAndApplyImage(BackgroundImagePicked onImagePicked) async {
    final file = await pickBackgroundImageFile();
    if (file == null) return;

    await onImagePicked(file);
  }
}
