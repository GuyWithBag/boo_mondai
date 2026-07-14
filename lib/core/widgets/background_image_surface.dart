import 'dart:async' show FutureOr;

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, SurfaceShape, surfaceStyle, SurfaceBorder;
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
        Padding,
        Positioned,
        SizedBox,
        Stack,
        StackFit,
        StatelessWidget,
        Widget;
import 'package:theme_variants/theme_variants.dart';

typedef BackgroundImagePicked = FutureOr<void> Function(PlatformFile file);

enum BackgroundImageEditButtonPosition { topRight, bottomRight }

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
    this.shape = SurfaceShape.sharp,
    this.fit = BoxFit.cover,
    this.imageAlignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.missingImageIcon = Icons.image_not_supported_outlined,
    this.missingImageIconSize = 40,
    this.isEditable = false,
    this.showCenteredEditButtonWhenChildPresent = false,
    this.useAddIconWhenNoImage = false,
    this.editButtonPosition = BackgroundImageEditButtonPosition.bottomRight,
    this.onImagePicked,
    this.border = SurfaceBorder.none,
    this.editIcon = Icons.edit,
  });

  final ImageProvider? image;
  final Widget? child;
  final SurfaceStyle? style;
  final SurfaceShape shape;
  final BoxFit fit;
  final AlignmentGeometry imageAlignment;
  final Clip clipBehavior;
  final IconData? missingImageIcon;
  final double missingImageIconSize;
  final bool isEditable;
  final bool showCenteredEditButtonWhenChildPresent;
  final bool useAddIconWhenNoImage;
  final BackgroundImageEditButtonPosition editButtonPosition;
  final BackgroundImagePicked? onImagePicked;
  final SurfaceBorder border;
  final IconData editIcon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedStyle =
        style ?? surfaceStyle.resolve(tokens, [shape, border]);
    final childPadding = resolvedStyle.padding ?? EdgeInsets.zero;
    final finalStyle = resolvedStyle.copyWith(
      padding: EdgeInsets.zero,
      clipBehavior: resolvedStyle.clipBehavior ?? clipBehavior,
    );
    final showEditButton = isEditable && onImagePicked != null;
    final showOverlayEditButton =
        showEditButton && (image != null || child != null);

    Widget getIcon() {
      if (isEditable &&
          (child == null || showCenteredEditButtonWhenChildPresent)) {
        return Button.iconOnly(
          tokens: tokens,
          icon: image == null && useAddIconWhenNoImage ? Icons.add : editIcon,
          onPressed: _pickImage,
        );
      }
      return missingImageIcon == null
          ? const SizedBox.shrink()
          : Icon(missingImageIcon, size: missingImageIconSize);
    }

    List<Widget> getStackChildren() {
      final children = <Widget>[];
      if (image != null) {
        children.add(
          Positioned.fill(
            child: Image(image: image!, fit: fit, alignment: imageAlignment),
          ),
        );
      } else {
        children.add(
          Center(
            child: IconTheme(
              data: finalStyle.iconTheme.copyWith(color: tokens.colorMuted),
              child: getIcon(),
            ),
          ),
        );
      }
      if (child != null) {
        children.add(
          Positioned.fill(
            child: Padding(padding: childPadding, child: child),
          ),
        );
      }
      return children;
    }

    final surface = Surface(
      style: finalStyle,
      child: Stack(fit: StackFit.expand, children: getStackChildren()),
    );

    if (!showOverlayEditButton) {
      return surface;
    }

    final editButtonPadding = tokens.spaceLayoutPaddingSm;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: surface),
        Positioned(
          top: editButtonPosition == BackgroundImageEditButtonPosition.topRight
              ? editButtonPadding
              : null,
          right: editButtonPadding,
          bottom:
              editButtonPosition ==
                  BackgroundImageEditButtonPosition.bottomRight
              ? editButtonPadding
              : null,
          child: Button.iconOnlySmall(
            icon: editIcon,
            tokens: tokens,
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final file = await pickBackgroundImageFile();
    if (file == null) return;

    await onImagePicked?.call(file);
  }
}
