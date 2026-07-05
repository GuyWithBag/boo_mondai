import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShape,
        ToolBarController,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

enum ToolBarAction {
  attachment,
  heading1,
  heading2,
  bold,
  italic,
  strikethrough,
  inlineCode,
  codeBlock,
  blockQuote,
  indent,
  unindent,
  unorderedList,
  orderedList,
  taskList,
  camelCase,
  pascalCase,
  snakeCase,
  kebabCase,
  titleCase,
  toggleUpperLowerCase,
  link,
  image,
  horizontalRule,
  table,
}

class ToolBarScope extends InheritedWidget {
  const ToolBarScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final ToolBarController controller;

  static ToolBarController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ToolBarScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(ToolBarScope oldWidget) {
    return oldWidget.controller != controller;
  }
}

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolBar({
    super.key,
    this.actions = const [],
    this.preferredHeight = ToolBar.preferredHeightDefault,
    this.controller,
    this.showUnfocusButton = true,
  });

  ToolBar.withActions({
    required ToolBarController controller,
    List<ToolBarAction> exclude = const [],
    bool useAttachments = false,
    Future<void> Function()? onAttachmentPressed,
    double preferredHeight = ToolBar.preferredHeightDefault,
    bool showUnfocusButton = true,
    Key? key,
  }) : this(
         key: key,
         controller: controller,
         preferredHeight: preferredHeight,
         showUnfocusButton: showUnfocusButton,
         actions: [
           for (final action in ToolBarAction.values)
             if ((useAttachments || action != ToolBarAction.attachment) &&
                 !exclude.contains(action))
               ToolBarActionButton(
                 action: action,
                 controller: controller,
                 onAttachmentPressed: onAttachmentPressed,
               ),
         ],
       );

  final List<Widget> actions;
  final double preferredHeight;
  final ToolBarController? controller;
  final bool showUnfocusButton;

  static const double preferredHeightDefault = 72;
  static const double unfocusButtonHeight = 48;
  static const double unfocusButtonGap = 8;

  @override
  Size get preferredSize {
    final height = showUnfocusButton
        ? preferredHeight + unfocusButtonHeight + unfocusButtonGap
        : preferredHeight;
    return Size(0, height);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final shouldShowUnfocusButton =
        showUnfocusButton && MediaQuery.viewInsetsOf(context).bottom > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (shouldShowUnfocusButton) ...[
          SizedBox(
            height: unfocusButtonHeight,
            child: Center(
              child: Button.iconOnly(
                icon: Icons.keyboard_hide,
                tokens: tokens,
                onPressed: FocusManager.instance.primaryFocus?.unfocus,
              ),
            ),
          ),
          SizedBox(height: tokens.spaceLayoutGapSm),
        ],
        Surface(
          style: surfaceStyle.resolve(tokens, [
            SurfaceBorder.top,
            // SurfaceShape.topRounded,
            SurfacePadding.sm,
            SurfaceShape.roundedXsm,
          ]),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(spacing: tokens.spaceLayoutGapSm, children: actions),
            ),
          ),
        ),
      ],
    );
  }
}

class ToolBarActionButton extends StatelessWidget {
  const ToolBarActionButton({
    required this.action,
    required this.controller,
    this.onAttachmentPressed,
    super.key,
  });

  final ToolBarAction action;
  final ToolBarController controller;
  final Future<void> Function()? onAttachmentPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final onPressed = controller.hasActiveTextController
            ? _onPressed()
            : null;

        return Button.icon(icon: _icon, onPressed: onPressed, tokens: tokens);
      },
    );
  }

  VoidCallback? _onPressed() {
    return switch (action) {
      ToolBarAction.attachment => onAttachmentPressed,
      ToolBarAction.heading1 => () => controller.insertHeading(1),
      ToolBarAction.heading2 => () => controller.insertHeading(2),
      ToolBarAction.bold => controller.toggleBold,
      ToolBarAction.italic => controller.toggleItalic,
      ToolBarAction.strikethrough => controller.toggleStrikethrough,
      ToolBarAction.inlineCode => controller.toggleInlineCode,
      ToolBarAction.codeBlock => controller.insertCodeBlock,
      ToolBarAction.blockQuote => controller.insertBlockQuote,
      ToolBarAction.indent => controller.indentSelectedLines,
      ToolBarAction.unindent => controller.unindentSelectedLines,
      ToolBarAction.unorderedList => controller.insertUnorderedList,
      ToolBarAction.orderedList => controller.insertOrderedList,
      ToolBarAction.taskList => controller.insertTaskList,
      ToolBarAction.camelCase => controller.applyCamelCase,
      ToolBarAction.pascalCase => controller.applyPascalCase,
      ToolBarAction.snakeCase => controller.applySnakeCase,
      ToolBarAction.kebabCase => controller.applyKebabCase,
      ToolBarAction.titleCase => controller.applyTitleCase,
      ToolBarAction.toggleUpperLowerCase => controller.toggleUpperLowerCase,
      ToolBarAction.link => controller.insertLink,
      ToolBarAction.image => controller.insertImage,
      ToolBarAction.horizontalRule => controller.insertHorizontalRule,
      ToolBarAction.table => controller.insertTable,
    };
  }

  IconData get _icon {
    return switch (action) {
      ToolBarAction.attachment => Icons.image_outlined,
      ToolBarAction.heading1 => Icons.title,
      ToolBarAction.heading2 => Icons.format_size,
      ToolBarAction.bold => Icons.format_bold,
      ToolBarAction.italic => Icons.format_italic,
      ToolBarAction.strikethrough => Icons.format_strikethrough,
      ToolBarAction.inlineCode => Icons.code,
      ToolBarAction.codeBlock => Icons.data_object,
      ToolBarAction.blockQuote => Icons.format_quote,
      ToolBarAction.indent => Icons.format_indent_increase,
      ToolBarAction.unindent => Icons.format_indent_decrease,
      ToolBarAction.unorderedList => Icons.format_list_bulleted,
      ToolBarAction.orderedList => Icons.format_list_numbered,
      ToolBarAction.taskList => Icons.check_box_outlined,
      ToolBarAction.camelCase => Icons.text_fields,
      ToolBarAction.pascalCase => Icons.title,
      ToolBarAction.snakeCase => Icons.keyboard_double_arrow_down,
      ToolBarAction.kebabCase => Icons.horizontal_rule,
      ToolBarAction.titleCase => Icons.format_size,
      ToolBarAction.toggleUpperLowerCase => Icons.swap_vert,
      ToolBarAction.link => Icons.link,
      ToolBarAction.image => Icons.add_photo_alternate_outlined,
      ToolBarAction.horizontalRule => Icons.horizontal_rule,
      ToolBarAction.table => Icons.table_chart_outlined,
    };
  }
}
