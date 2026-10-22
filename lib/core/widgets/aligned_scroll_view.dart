import 'package:flutter/material.dart';

class AlignedScrollView extends StatelessWidget {
  const AlignedScrollView({
    required this.child,
    this.verticallyCentered = false,
    this.padding,
    this.controller,
    this.physics,
    super.key,
  });

  final Widget child;
  final bool verticallyCentered;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0.0;
        final minWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 0.0;

        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              minWidth: minWidth,
            ),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Align(
                alignment: verticallyCentered
                    ? Alignment.center
                    : Alignment.topCenter,
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}
