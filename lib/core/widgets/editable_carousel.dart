import 'dart:async' show FutureOr;

import 'package:boo_mondai/lib.barrel.dart'
    show BackgroundImageSurface, ImageHelper, SurfaceBorder;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart'
    show Axis, BuildContext, CarouselView, Icons, StatelessWidget, Widget;

typedef EditableCarouselImagePicked =
    FutureOr<void> Function(int index, PlatformFile file);

class EditableCarousel extends StatelessWidget {
  const EditableCarousel({
    super.key,
    required this.imageSources,
    this.isEditable = false,
    this.maxImageCount,
    this.onImagePicked,
  }) : assert(maxImageCount == null || maxImageCount > 0);

  final List<String> imageSources;
  final bool isEditable;
  final int? maxImageCount;
  final EditableCarouselImagePicked? onImagePicked;

  @override
  Widget build(BuildContext context) {
    final canAddImage =
        isEditable &&
        (maxImageCount == null || imageSources.length < maxImageCount!);
    final itemCount = imageSources.length + (canAddImage ? 1 : 0);
    final visibleItemCount = itemCount == 0 ? 1 : itemCount;

    return CarouselView.weighted(
      scrollDirection: Axis.horizontal,
      flexWeights: const <int>[1],
      children: List<Widget>.generate(visibleItemCount, (int index) {
        final imageSource = index < imageSources.length
            ? imageSources[index]
            : null;
        final isAddItem = imageSource == null && canAddImage;

        return BackgroundImageSurface(
          border: SurfaceBorder.baseline,
          image: ImageHelper.getImageProviderFromSource(imageSource),
          missingImageIcon: isAddItem
              ? Icons.add_photo_alternate_outlined
              : null,
          isEditable: isEditable,
          onImagePicked: onImagePicked == null
              ? null
              : (file) => onImagePicked!(index, file),
        );
      }),
    );
  }
}
