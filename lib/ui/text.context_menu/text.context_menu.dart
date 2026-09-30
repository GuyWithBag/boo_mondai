import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonPadding,
        ButtonSize,
        ButtonVariant,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        surfaceStyle;
import 'package:boo_mondai/ui/text.context_menu/text.context_menu.controller.dart';
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class TextContextMenu extends SignalHookWidget {
  const TextContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextContextMenuController.instance;
    final isVisible = controller.isVisible.value;
    final editableTextState = controller.editableTextState.value;

    if (!isVisible || editableTextState == null) {
      return const SizedBox.shrink();
    }

    if (!controller.hasButtonItems.value) return const SizedBox.shrink();

    controller.updatePosition(context);

    return Positioned(
      left: controller.left.value,
      top: controller.top.value,
      child: TextFieldTapRegion(child: const _TextContextMenuBody()),
    );
  }
}

class _TextContextMenuBody extends SignalHookWidget {
  const _TextContextMenuBody();

  @override
  Widget build(BuildContext context) {
    final controller = TextContextMenuController.instance;
    final tokens = context.themeTokens<AppTokens>();
    final quickItems = controller.quickItems.value;
    final dropdownItems = controller.dropdownItems.value;
    final isDropdownOpen = controller.isDropdownOpen.value;

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceColor.baseline,
        SurfaceShape.roundedXsm,
        SurfacePadding.none,
        SurfaceBorder.baseline,
        SurfaceShadow.baseline,
      ]),
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceLayoutGapXsm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in quickItems)
                  Button.iconSmall(
                    icon: controller.iconFor(item),
                    onPressed: item.onPressed == null
                        ? null
                        : () => controller.press(item),
                    color: ButtonColor.baseline,
                    variant: ButtonVariant.flat,
                  ),
                Button.iconSmall(
                  icon: Icons.more_horiz,
                  onPressed: controller.toggleDropdown,
                  selected: isDropdownOpen,
                  color: ButtonColor.baseline,
                  variant: ButtonVariant.flat,
                ),
              ],
            ),
            if (isDropdownOpen) ...[
              SizedBox(height: tokens.spaceLayoutGapXsm),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: TextContextMenuController.dropdownMaxHeight,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in dropdownItems)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: tokens.spaceLayoutGapXsm,
                          ),
                          child: Button(
                            leading: Icon(controller.iconFor(item)),
                            onPressed: item.onPressed == null
                                ? null
                                : () => controller.press(item),
                            mainAxisAlignment: MainAxisAlignment.start,
                            variants: const [
                              ButtonColor.baseline,
                              ButtonSize.sm,
                              ButtonPadding.sm,
                              ButtonVariant.flat,
                            ],
                            child: Text(
                              controller.labelFor(context, item),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
