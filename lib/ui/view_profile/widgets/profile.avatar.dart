import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BackgroundImageEditButtonPosition,
        BackgroundImagePicked,
        BackgroundImageSurface,
        SurfaceShape,
        TextSize,
        textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.displayName,
    this.avatar,
    this.radius = 18,
    this.isSourceAuthor = false,
    this.onImagePicked,
    super.key,
  });

  final String displayName;
  final ImageProvider? avatar;
  final double radius;
  final bool isSourceAuthor;
  final BackgroundImagePicked? onImagePicked;

  @override
  Widget build(BuildContext context) {
    final name = displayName.trim().isEmpty ? '...' : displayName.trim();
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    final tokens = context.themeTokens<AppTokens>();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox.square(
          dimension: radius * 2,
          child: BackgroundImageSurface(
            image: avatar,
            isEditable: onImagePicked != null,
            onImagePicked: onImagePicked,
            missingImageIcon: null,
            shape: SurfaceShape.circle,
            editButtonPosition: BackgroundImageEditButtonPosition.bottomRight,
            // editButtonInset: -radius * 0.08,
            child: avatar == null
                ? Center(
                    child: Text(
                      initials,
                      style: textStyle.resolve(tokens, const [
                        TextSize.labelSmall,
                      ]),
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
              // ToDO:
              // decoration: BoxDecoration(
              //   color: scheme.tertiary,
              //   shape: BoxShape.circle,
              //   border: Border.all(color: scheme.surface, width: 1.5),
              // ),
            ),
          ),
      ],
    );
  }
}
