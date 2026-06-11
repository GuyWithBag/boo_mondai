import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Alignment,
        ScrollController,
        Widget,
        BuildContext,
        Curves,
        Transform,
        Opacity,
        IgnorePointer,
        AnimatedBuilder;

class CollapsingHeaderItem extends StatelessWidget {
  const CollapsingHeaderItem({
    super.key,
    required this.scrollController,
    required this.collapseDistance,
    required this.child,
    this.alignment = Alignment.center,
  });

  final ScrollController scrollController;
  final double collapseDistance;
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      child: child,
      builder: (context, child) {
        final offset = scrollController.hasClients
            ? scrollController.offset
            : 0;
        final collapseProgress = (offset / collapseDistance).clamp(0.0, 1.0);
        final visibility = Curves.easeOutCubic.transform(1 - collapseProgress);
        final scale = 0.82 + (0.18 * visibility);

        return IgnorePointer(
          ignoring: visibility <= 0.05,
          child: Opacity(
            opacity: visibility,
            child: Transform.scale(
              alignment: alignment,
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
