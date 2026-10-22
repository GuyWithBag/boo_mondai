import 'dart:async' show FutureOr;

import 'package:boo_mondai/lib.barrel.dart'
    show BackgroundImageSurface, SurfaceBorder;
import 'package:boo_mondai/core/widgets/editable_carousel.controller.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

typedef EditableCarouselImagePicked =
    FutureOr<void> Function(int index, PlatformFile file);

class EditableCarousel extends SignalHookWidget {
  const EditableCarousel({
    super.key,
    required this.controller,
    this.onImagePicked,
  });

  final EditableCarouselController controller;
  final EditableCarouselImagePicked? onImagePicked;

  @override
  Widget build(BuildContext context) {
    return CarouselView.weighted(
      controller: controller.carouselController,
      scrollDirection: Axis.horizontal,
      flexWeights: controller.flexWeights.value,
      enableSplash: false,
      itemSnapping: true,
      infinite: controller.isInfinite.value,
      children: List<Widget>.generate(controller.visibleItemCount.value, (
        int index,
      ) {
        final image = index < controller.imageSources.value.length
            ? controller.imageSources.value[index]
            : null;
        final isAddItem = image == null && controller.canAddImage.value;

        return BackgroundImageSurface(
          border: SurfaceBorder.baseline,
          image: image,
          missingImageIcon: isAddItem
              ? Icons.add_photo_alternate_outlined
              : null,
          isEditable: controller.isEditable.value,
          useAddIconWhenNoImage: true,
          onImagePicked: onImagePicked == null
              ? null
              : (file) => onImagePicked!(index, file),
        );
      }),
    );
  }
}
