import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShape,
        StoredMediaPath,
        surfaceStyle,
        ToolBarController,
        AttachmentToolBarAction,
        defaultToolBarActions,
        ToolBarActionButton;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:theme_variants/theme_variants.dart';

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolBar({
    super.key,
    this.actions = const [],
    this.preferredHeight = ToolBar.preferredHeightDefault,
    this.controller,
  });

  ToolBar.withActions({
    required ToolBarController controller,
    List<Type> exclude = const [],
    bool useAttachments = false,
    StoredMediaPath? Function(PlatformFile file)? createAttachmentPath,
    VoidCallback? onAttachmentInserted,
    double preferredHeight = ToolBar.preferredHeightDefault,
    Key? key,
  }) : this(
         key: key,
         controller: controller,
         preferredHeight: preferredHeight,
         actions: [
           if (useAttachments && !exclude.contains(AttachmentToolBarAction))
             ToolBarActionButton(
               action: AttachmentToolBarAction(
                 createPath: createAttachmentPath,
                 onInserted: onAttachmentInserted,
               ),
               controller: controller,
             ),
           for (final action in defaultToolBarActions)
             if (!exclude.contains(action.runtimeType))
               ToolBarActionButton(action: action, controller: controller),
         ],
       );

  final List<Widget> actions;
  final double preferredHeight;
  final ToolBarController? controller;

  static const double preferredHeightDefault = 82;
  static const double unfocusButtonHeight = 48;

  @override
  Size get preferredSize {
    return Size(0, preferredHeight);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    // FocusManager.instance.primaryFocus?.unfocus
    return Surface(
      style: surfaceStyle.resolve(tokens, [
        SurfaceBorder.top,
        SurfacePadding.none,
        SurfaceShape.roundedXsm,
      ]),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spaceLayoutPaddingSm),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: tokens.spaceLayoutGapSm),
                Row(spacing: tokens.spaceLayoutGapSm, children: [...actions]),
                SizedBox(width: tokens.spaceLayoutGapSm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
