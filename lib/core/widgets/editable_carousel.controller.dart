import 'dart:async' show Timer;

import 'package:flutter/material.dart' show CarouselController, ImageProvider;
import 'package:signals_hooks/signals_hooks.dart';

class EditableCarouselController {
  EditableCarouselController({
    required this.imageSources,
    required bool isEditable,
    required int? maxImageCount,
    required Duration? autoScrollInterval,
    required bool shouldLoop,
  }) : assert(maxImageCount == null || maxImageCount > 0),
       assert(
         autoScrollInterval == null || autoScrollInterval > Duration.zero,
         'autoScrollInterval must be greater than zero.',
       ),
       isEditable = signal(isEditable),
       maxImageCount = signal(maxImageCount),
       autoScrollInterval = signal(autoScrollInterval),
       shouldLoop = signal(shouldLoop);

  final carouselController = CarouselController();
  final Signal<List<ImageProvider>> imageSources;
  final Signal<bool> isEditable;
  final Signal<int?> maxImageCount;
  final Signal<Duration?> autoScrollInterval;
  final Signal<bool> shouldLoop;
  final autoScrollIndex = signal(0);
  bool _isDisposed = false;

  late final canAddImage = computed(
    () =>
        isEditable.value &&
        (maxImageCount.value == null ||
            imageSources.value.length < maxImageCount.value!),
  );

  late final itemCount = computed(
    () => imageSources.value.length + (canAddImage.value ? 1 : 0),
  );

  late final visibleItemCount = computed(
    () => itemCount.value == 0 ? 1 : itemCount.value,
  );

  late final flexWeights = computed(
    () => !isEditable.value && imageSources.value.length == 1
        ? const <int>[1]
        : const <int>[10, 1],
  );

  late final isInfinite = computed(
    () =>
        autoScrollInterval.value != null &&
        shouldLoop.value &&
        visibleItemCount.value > 1,
  );

  late final autoScrollEffect = effect(() {
    final interval = autoScrollInterval.value;
    final count = visibleItemCount.value;
    final loop = shouldLoop.value;

    if (interval == null || count <= 1) return null;

    Timer? timer;
    timer = Timer.periodic(interval, (_) {
      if (_isDisposed || !carouselController.hasClients) return;

      final nextIndex = autoScrollIndex.value + 1;
      if (nextIndex >= count) {
        if (!loop) {
          timer?.cancel();
          return;
        }

        autoScrollIndex.value = 0;
        carouselController.animateToItem(0);
        return;
      }

      autoScrollIndex.value = nextIndex;
      carouselController.animateToItem(nextIndex);
    });

    return timer.cancel;
  });

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    autoScrollEffect();
    isInfinite.dispose();
    flexWeights.dispose();
    visibleItemCount.dispose();
    itemCount.dispose();
    canAddImage.dispose();
    autoScrollIndex.dispose();
    shouldLoop.dispose();
    autoScrollInterval.dispose();
    maxImageCount.dispose();
    isEditable.dispose();
    carouselController.dispose();
  }
}
