import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/widgets/cube.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhysicalCard extends HookWidget {
  const PhysicalCard({
    super.key,
    required this.controller,
    required this.front,
    this.back,
    this.tapToFlip = false,
    this.onTap,
    this.animateChanges = true,
  });

  final CubeController controller;
  final Widget front;
  final Widget? back;
  final bool tapToFlip;
  final VoidCallback? onTap;
  final bool animateChanges;

  @override
  Widget build(BuildContext context) {
    useListenable(controller);

    final cube = Cube(
      controller: controller,
      front: front,
      back: back,
      // right: const SizedBox.expand(),
      // left: const SizedBox.expand(),
      // top: const SizedBox.expand(),
      // bottom: const SizedBox.expand(),
      depth: controller.depth == 0 ? 10 : controller.depth,
    );

    if (!tapToFlip && onTap == null) {
      return cube;
    }

    return GestureDetector(
      onTap: () {
        onTap?.call();
        if (tapToFlip) {
          controller.flip();
        }
      },
      child: cube,
    );
  }
}
