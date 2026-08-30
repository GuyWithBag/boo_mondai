import 'dart:async' show FutureOr, Timer;

import 'package:boo_mondai/lib.barrel.dart'
    show BackgroundImageSurface, ImageHelper, SurfaceBorder;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef EditableCarouselImagePicked =
    FutureOr<void> Function(int index, PlatformFile file);

class EditableCarousel extends HookWidget {
  const EditableCarousel({
    super.key,
    required this.imageSources,
    this.isEditable = false,
    this.maxImageCount,
    this.onImagePicked,
    this.autoScrollInterval,
    this.shouldLoop = true,
  }) : assert(maxImageCount == null || maxImageCount > 0),
       assert(
         autoScrollInterval == null || autoScrollInterval > Duration.zero,
         'autoScrollInterval must be greater than zero.',
       );

  final List<String> imageSources;
  final bool isEditable;
  final int? maxImageCount;
  final EditableCarouselImagePicked? onImagePicked;
  final Duration? autoScrollInterval;
  final bool shouldLoop;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(CarouselController.new);
    final autoScrollIndex = useRef(0);
    final canAddImage =
        isEditable &&
        (maxImageCount == null || imageSources.length < maxImageCount!);
    final itemCount = imageSources.length + (canAddImage ? 1 : 0);
    final visibleItemCount = itemCount == 0 ? 1 : itemCount;
    final flexWeights = !isEditable && imageSources.length == 1
        ? const <int>[1]
        : const <int>[10, 1];

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    useEffect(() {
      final interval = autoScrollInterval;
      if (interval == null || visibleItemCount <= 1) return null;

      Timer? timer;
      timer = Timer.periodic(interval, (_) {
        final nextIndex = autoScrollIndex.value + 1;
        if (nextIndex >= visibleItemCount) {
          if (!shouldLoop) {
            timer?.cancel();
            return;
          }

          autoScrollIndex.value = 0;
          controller.animateToItem(0);
          return;
        }

        autoScrollIndex.value = nextIndex;
        controller.animateToItem(nextIndex);
      });

      return timer.cancel;
    }, [controller, autoScrollInterval, shouldLoop, visibleItemCount]);

    return CarouselView.weighted(
      controller: controller,
      scrollDirection: Axis.horizontal,
      flexWeights: flexWeights,
      enableSplash: false,
      itemSnapping: true,
      infinite:
          autoScrollInterval != null && shouldLoop && visibleItemCount > 1,
      children: List<Widget>.generate(visibleItemCount, (int index) {
        final imageSource = index < imageSources.length
            ? imageSources[index]
            : null;
        final isAddItem = imageSource == null && canAddImage;

        return BackgroundImageSurface(
          border: SurfaceBorder.baseline,
          image: imageSource != null
              ? ImageHelper.getImageProviderFromSource(imageSource)
              : null,
          missingImageIcon: isAddItem
              ? Icons.add_photo_alternate_outlined
              : null,
          isEditable: isEditable,
          useAddIconWhenNoImage: true,
          onImagePicked: onImagePicked == null
              ? null
              : (file) => onImagePicked!(index, file),
        );
      }),
    );
  }
}
