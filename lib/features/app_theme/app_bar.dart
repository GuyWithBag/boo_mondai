import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        CollapsingHeaderItem,
        SurfaceColor,
        SurfaceShape,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart' hide AppBar;
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class AppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.bottom,
    this.backgroundColor,
    this.padding,
    this.actionsSpacing,
    this.automaticallyImplyPopButton = true,
    this.popButton,
    this.onPop,
    this.collapsible = false,
    this.scrollController,
    this.collapseDistance = 0,
    this.preferredHeight = 100,
    this.bottomHeight = 0,
    this.showBottomBorder = false,
    this.child,
    this.subSection,
  });

  final String? title;
  final Widget? child;
  final List<Widget> actions;
  final Widget? bottom;
  final Widget? subSection;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? actionsSpacing;
  final bool automaticallyImplyPopButton;
  final IconData? popButton;
  final VoidCallback? onPop;
  final bool collapsible;
  final ScrollController? scrollController;
  final double collapseDistance;
  final double preferredHeight;
  final double bottomHeight;
  final bool showBottomBorder;

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight + bottomHeight);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final route = ModalRoute.of(context);
    final canPop =
        automaticallyImplyPopButton &&
        (route?.impliesAppBarDismissal ?? Navigator.of(context).canPop());
    final inferredPopButton = route is PopupRoute
        ? Icons.close
        : Icons.arrow_back;
    final popButtonWidget = canPop
        ? Button.icon(
            icon: popButton ?? inferredPopButton,
            onPressed: onPop ?? () => context.pop(),
          )
        : null;
    final effectivePopButton = _maybeCollapse(
      child: popButtonWidget,
      alignment: Alignment.topLeft,
    );
    final effectiveActions = [
      for (final action in actions)
        _maybeCollapse(child: action, alignment: Alignment.topRight)!,
    ];
    final effectiveBottom = _maybeCollapse(
      child: bottom,
      alignment: Alignment.topRight,
    );
    return SizedBox(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Surface(
              style: surfaceStyle.resolve(tokens, const [
                SurfaceShape.sharp,
                SurfaceColor.invisible,
              ]),
              child: Column(
                children: [
                  Row(
                    spacing: tokens.spaceLayoutGapSm,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ?effectivePopButton,
                      if (title != null)
                        Text(
                          title!,
                          style: textStyle.resolve(tokens, const [
                            TextSize.header,
                            TextWeight.heavy,
                          ]),
                        ),
                      if (child != null) Expanded(child: child!),
                      if (effectiveActions.isNotEmpty) ...[
                        Row(
                          spacing: tokens.spaceLayoutGapSm,
                          mainAxisSize: MainAxisSize.min,
                          children: effectiveActions,
                        ),
                      ],
                    ],
                  ),
                  // subSection ?? SizedBox.shrink(),
                ],
              ),
            ),
            if (effectiveBottom != null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: tokens.spaceScaffoldPadding,
                  end: tokens.spaceScaffoldPadding,
                  bottom: tokens.spaceScaffoldPadding,
                ),
                child: effectiveBottom,
              ),
          ],
        ),
      ),
    );
  }

  Widget? _maybeCollapse({
    required Widget? child,
    required Alignment alignment,
  }) {
    final controller = scrollController;

    if (child == null) {
      return null;
    }

    if (!collapsible || controller == null) {
      return child;
    }

    return CollapsingHeaderItem(
      scrollController: controller,
      collapseDistance: collapseDistance,
      alignment: alignment,
      child: child,
    );
  }
}
