import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ButtonColor,
        SelectionController,
        SurfaceBorder,
        SurfaceColor,
        SurfaceShape,
        TextColor,
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
    this.transparentBackground = false,
    this.padding,
    this.actionsSpacing,
    this.automaticallyImplyPopButton = true,
    this.popButton,
    this.onPop,
    this.collapsible = false,
    this.scrollController,
    this.collapseDistance = 0,
    this.preferredHeight = AppBar.preferredHeightDefault,
    this.preferredBottomHeight = 45,
    this.showBottomBorder = false,
    this.child,
    this.header,
    this.preferredHeaderHeight = 62,
    this.selectionController,
    this.onSelectedDelete,
    this.selectedActions = const [],
    this.subTitle,
    this.leading,
  });

  final String? title;
  final Widget? child;
  final List<Widget> actions;
  final Widget? bottom;
  final Widget? header;
  final double preferredHeaderHeight;
  final bool transparentBackground;
  final EdgeInsetsGeometry? padding;
  final double? actionsSpacing;
  final bool automaticallyImplyPopButton;
  final IconData? popButton;
  final VoidCallback? onPop;
  final bool collapsible;
  final ScrollController? scrollController;
  final double collapseDistance;
  final SelectionController? selectionController;
  final VoidCallback? onSelectedDelete;
  final List<Widget> selectedActions;
  final String? subTitle;
  final Widget? leading;

  /// This is the preferredHeight required. This is needed for scrolling purposes for Scaffold.
  final double preferredHeight;
  final double preferredBottomHeight;
  final bool showBottomBorder;

  double _getTotalHeight() {
    final isSelecting = selectionController?.isEnabled ?? false;

    return preferredHeight +
        (!isSelecting && bottom != null ? preferredBottomHeight : 0) +
        (header != null ? preferredHeaderHeight : 0);
  }

  static const double preferredHeightDefault = 90;

  @override
  Size get preferredSize => Size(0, _getTotalHeight());

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
    final effectivePopButton = canPop
        ? Button.icon(
            icon: popButton ?? inferredPopButton,
            onPressed:
                onPop ??
                () {
                  context.pop();
                },
            tokens: tokens,
          )
        : null;

    final isSelectionState = selectionController?.isEnabled ?? false;
    final effectiveActions = [for (final action in actions) action];
    final effectiveSelectionActions = <Widget>[
      if (onSelectedDelete != null)
        Button.icon(
          icon: Icons.delete,
          color: ButtonColor.error,
          onPressed: onSelectedDelete,
          tokens: tokens,
        ),
      if (isSelectionState) ...selectedActions,
    ];

    final effectiveBottom = bottom;
    final resolvedSurfaceStyle = surfaceStyle
        .resolve(tokens, [
          SurfaceShape.sharp,
          SurfaceBorder.bottom,
          if (isSelectionState) SurfaceColor.muted,
          if (transparentBackground) SurfaceColor.invisible,
        ])
        .copyWith(
          padding: EdgeInsets.only(
            left: tokens.spaceLayoutPadding,
            right: tokens.spaceLayoutPadding,
            top: tokens.spaceLayoutPadding,
            bottom: transparentBackground
                ? tokens.spaceLayoutPadding / 2
                : tokens.spaceLayoutPadding,
          ),
        );
    final spacing = tokens.spaceLayoutGapSm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: Surface(
            style: resolvedSurfaceStyle,
            child: SafeArea(
              bottom: false,
              child: Column(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height:
                        preferredHeight -
                        resolvedSurfaceStyle.padding!.vertical -
                        spacing,
                    child: Row(
                      spacing: tokens.spaceLayoutGapSm,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: tokens.spaceLayoutGapMd,
                          children: [
                            if (isSelectionState)
                              Button.icon(
                                tokens: tokens,
                                icon: Icons.cancel,
                                onPressed: () {
                                  selectionController!.clear();
                                  selectionController!.isEnabled = false;
                                },
                              )
                            else
                              ?effectivePopButton,
                            ?leading,
                            if (isSelectionState || title != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isSelectionState ? 'Selecting' : title!,
                                    style: textStyle.resolve(tokens, const [
                                      TextSize.header,
                                      TextWeight.heavy,
                                    ]),
                                  ),
                                  if (subTitle != null)
                                    // TODO: Add styling where the characters are fare apart
                                    Text(
                                      subTitle!,
                                      style: textStyle.resolve(tokens, const [
                                        TextSize.label,
                                        TextColor.muted,
                                      ]),
                                    ),
                                ],
                              ),
                          ],
                        ),
                        if (child != null) Expanded(child: child!),
                        if (effectiveActions.isNotEmpty)
                          Row(
                            spacing: tokens.spaceLayoutGapSm,
                            mainAxisSize: MainAxisSize.min,
                            children: isSelectionState
                                ? effectiveSelectionActions
                                : effectiveActions,
                          ),
                      ],
                    ),
                  ),
                  ?header,
                ],
              ),
            ),
          ),
        ),
        if (effectiveBottom != null && !isSelectionState)
          SizedBox(height: preferredBottomHeight, child: effectiveBottom),
      ],
    );
  }
}
