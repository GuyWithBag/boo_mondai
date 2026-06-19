import 'dart:async' show FutureOr;

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SurfaceShape, surfaceStyle, SurfaceBorder;
import 'package:file_picker/file_picker.dart'
    show FilePicker, FileType, PlatformFile;
import 'package:flutter/material.dart'
    show
        Alignment,
        AlignmentGeometry,
        BoxFit,
        BuildContext,
        Center,
        Clip,
        EdgeInsets,
        Icon,
        IconData,
        IconTheme,
        Icons,
        Image,
        ImageProvider,
        GestureDetector,
        HitTestBehavior,
        Padding,
        Positioned,
        SizedBox,
        Stack,
        StackFit,
        StatelessWidget,
        Widget;
import 'package:theme_variants/theme_variants.dart';

typedef BackgroundImagePicked = FutureOr<void> Function(PlatformFile file);

Future<PlatformFile?> pickBackgroundImageFile() async {
  final result = await FilePicker.pickFiles(
    type: FileType.image,
    allowMultiple: false,
    withData: true,
  );
  final files = result?.files;
  if (files == null || files.isEmpty) return null;

  return files.first;
}

class BackgroundImageSurface extends StatelessWidget {
  const BackgroundImageSurface({
    super.key,
    this.image,
    this.child,
    this.style,
    this.fit = BoxFit.cover,
    this.imageAlignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.missingImageIcon = Icons.image_not_supported_outlined,
    this.missingImageIconSize = 40,
    this.onImagePicked,
  });

  final ImageProvider? image;
  final Widget? child;
  final SurfaceStyle? style;
  final BoxFit fit;
  final AlignmentGeometry imageAlignment;
  final Clip clipBehavior;
  final IconData? missingImageIcon;
  final double missingImageIconSize;
  final BackgroundImagePicked? onImagePicked;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedStyle =
        style ??
        surfaceStyle.resolve(tokens, const [
          SurfaceShape.sharp,
          SurfaceBorder.none,
        ]);
    final childPadding = resolvedStyle.padding ?? EdgeInsets.zero;
    final finalStyle = resolvedStyle.copyWith(
      padding: EdgeInsets.zero,
      clipBehavior: resolvedStyle.clipBehavior ?? clipBehavior,
    );

    final surface = Surface(
      style: finalStyle,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image case final image?)
            Positioned.fill(
              child: Image(image: image, fit: fit, alignment: imageAlignment),
            )
          else
            Center(
              child: IconTheme(
                data: finalStyle.iconTheme,
                child: missingImageIcon == null
                    ? const SizedBox.shrink()
                    : Icon(missingImageIcon, size: missingImageIconSize),
              ),
            ),
          if (child != null)
            Positioned.fill(
              child: Padding(padding: childPadding, child: child),
            ),
        ],
      ),
    );

    if (onImagePicked == null) {
      return surface;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _pickImage,
      child: surface,
    );
  }

  Future<void> _pickImage() async {
    final file = await pickBackgroundImageFile();
    if (file == null) return;

    await onImagePicked?.call(file);
  }
}
