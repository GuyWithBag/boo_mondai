import 'package:boo_mondai/lib.barrel.dart' show AppTokens, BackButton;
import 'package:flutter/material.dart' as material hide BackButton;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

/// Shared sliver app bar with fixed custom back button and flexible background.
class SliverAppBar extends material.StatelessWidget {
  const SliverAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.expandedHeight,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
    this.centerTitle = false,
    this.flexibleBackground,
    this.flexibleGradient,
    this.forceMaterialTransparency = true,
    this.leadingWidth,
    this.flexibleTitle,
    this.collapsedHeight = 100,
  });

  final material.Widget title;
  final List<material.Widget> actions;
  final double? expandedHeight;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final bool centerTitle;
  final material.Widget? flexibleBackground;
  final material.Gradient? flexibleGradient;
  final material.Widget? flexibleTitle;
  final bool forceMaterialTransparency;
  final double? collapsedHeight;
  final double? leadingWidth;

  @override
  material.Widget build(material.BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final hasFlexibleContent =
        flexibleBackground != null || flexibleGradient != null;

    return material.SliverAppBar(
      pinned: pinned,
      floating: floating,
      snap: snap,
      stretch: stretch,
      collapsedHeight: collapsedHeight,
      centerTitle: centerTitle,
      expandedHeight: expandedHeight,
      leadingWidth: leadingWidth ?? 100.w,
      leading: const BackButton(),
      title: title,
      actions: actions,
      backgroundColor: tokens.backgroundSurface,
      surfaceTintColor: material.Colors.transparent,
      forceMaterialTransparency: forceMaterialTransparency,
      flexibleSpace: hasFlexibleContent
          ? material.FlexibleSpaceBar(
              title: flexibleTitle,
              background: material.Stack(
                fit: material.StackFit.expand,
                children: [
                  ?flexibleBackground,
                  if (flexibleGradient case final gradient)
                    material.DecoratedBox(
                      decoration: material.BoxDecoration(gradient: gradient),
                    ),
                ],
              ),
            )
          : null,
    );
  }
}
