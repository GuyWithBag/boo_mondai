import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        MainController,
        SurfaceBorder,
        SurfaceColor,
        SurfaceShape,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart' hide AppBar;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart';

class AppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.bottom,
    this.transparentBackground = false,
    this.padding,
    this.actionsSpacing,
    this.automaticallyImplyPopButton = true,
    this.popButton,
    this.onPop,
    this.collapsible = false,
    this.scrollController,
    this.collapseDistance = 0,
    this.height = 138,
    this.bottomHeight = 50,
    this.showBottomBorder = false,
    this.child,
    this.subSection,
  });

  final String? title;
  final Widget? child;
  final List<Widget> actions;
  final Widget? bottom;
  final Widget? subSection;
  final bool transparentBackground;
  final EdgeInsetsGeometry? padding;
  final double? actionsSpacing;
  final bool automaticallyImplyPopButton;
  final IconData? popButton;
  final VoidCallback? onPop;
  final bool collapsible;
  final ScrollController? scrollController;
  final double collapseDistance;

  /// This is the height required. This is needed for scrolling purposes for Scaffold.
  final double height;
  final double bottomHeight;
  final bool showBottomBorder;

  double _getTotalHeight() {
    final total = height + (bottom == null ? bottomHeight : 0);

    return total;
  }

  @override
  Size get preferredSize => Size(0, _getTotalHeight());

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final mainController = context.read<MainController>();
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
            onPressed:
                onPop ??
                () {
                  context.pop();
                  mainController.setBottomNavbarVisible(true);
                },
            tokens: tokens,
          )
        : null;
    final totalHeight = _getTotalHeight();
    final effectivePopButton = popButtonWidget;
    final effectiveActions = [for (final action in actions) action];
    final effectiveBottom = bottom;

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Surface(
              style: surfaceStyle.resolve(tokens, [
                SurfaceShape.sharp,
                SurfaceBorder.bottom,
                if (transparentBackground) SurfaceColor.invisible,
              ]),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ),
          if (effectiveBottom != null)
            SizedBox(
              height: bottomHeight,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: tokens.spaceScaffoldPadding,
                  end: tokens.spaceScaffoldPadding,
                  bottom: tokens.spaceScaffoldPadding,
                ),
                child: effectiveBottom,
              ),
            ),
        ],
      ),
    );
  }
}

//   Widget? _maybeCollapse({
//     required Widget? child,
//     required Alignment alignment,
//   }) {
//     final controller = scrollController;

//     if (child == null) {
//       return null;
//     }

//     if (!collapsible || controller == null) {
//       return child;
//     }

//     return CollapsingHeaderItem(
//       scrollController: controller,
//       collapseDistance: collapseDistance,
//       alignment: alignment,
//       child: child,
//     );
//   }
