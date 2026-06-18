import 'package:boo_mondai/core/controllers/cube.controller.dart'
    show CubeController;
import 'package:boo_mondai/lib.barrel.dart' show Cube;
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
