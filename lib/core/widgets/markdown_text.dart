import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextColor,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        TextField,
        ToolBarScope,
        textStyle;
import 'package:boo_mondai/core/widgets/markdown_attachment_url_resolver.dart';
import 'package:boo_mondai/core/widgets/markdown_body.builder.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:theme_variants/theme_variants.dart';

enum MarkdownTextMode {
  /// Renders markdown as styled preview. Text is selectable but not editable.
  previewSelectable,

  /// Renders markdown as styled preview. Text is not selectable.
  preview,

  /// Shows the raw markdown string as non-selectable [Text].
  raw,

  /// Shows the raw markdown string in an editable [TextField].
  input,

  /// Obsidian-style live preview. Renders markdown at rest; switches to an
  /// editable [TextField] while focused. Tapping anywhere in the preview
  /// activates edit mode; losing focus returns to preview.
  inputPreview,
}

/// Displays or edits markdown content according to [mode].
///
/// Link taps in [MarkdownTextMode.preview] and [MarkdownTextMode.previewSelectable]
/// are handled automatically via `url_launcher`. Supply [onTapLink] to
/// intercept or override that behaviour.
class MarkdownText extends HookWidget {
  const MarkdownText({
    required this.data,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
    this.scrollPadding = const EdgeInsets.all(20),
    this.variants = const [TextFieldSize.normal, TextFieldFrame.outline],
    this.mode = MarkdownTextMode.raw,
    this.onTapLink,
    this.resolveAttachmentUrl,
    this.baseTextStyle,
    this.defaultMarkdownAlignment = WrapAlignment.center,
    this.contentScale = 1,
    this.useToolBar = true,
    this.allowAttachments = false,
    super.key,
    this.placeholderTextStyle,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle? baseTextStyle;
  final TextStyle? placeholderTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets scrollPadding;
  final Iterable<Object> variants;
  final MarkdownTextMode mode;
  final WrapAlignment defaultMarkdownAlignment;
  final double contentScale;
  final bool useToolBar;
  final bool allowAttachments;

  /// Called when a link is tapped in preview modes. When null, links are
  /// opened via [url_launcher] automatically.
  final MarkdownTapLinkCallback? onTapLink;

  /// Resolves markdown media URIs like `local:<id>` to displayable URLs. Used
  /// for images and by the default link launcher.
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedTextStyle =
        baseTextStyle ??
        textStyle.resolve(tokens, const [
          TextSize.label,
          TextWeight.body,
          TextColor.baseline,
        ]);
    final resolvedPlaceholderTextStyle =
        placeholderTextStyle ??
        textStyle.resolve(tokens, const [
          TextSize.label,
          TextWeight.body,
          TextColor.muted,
        ]);
    return switch (mode) {
      MarkdownTextMode.previewSelectable => _buildPreviewSelectable(
        tokens,
        resolvedTextStyle,
      ),
      MarkdownTextMode.preview => _buildPreview(tokens, resolvedTextStyle),
      MarkdownTextMode.raw => _buildRaw(resolvedTextStyle),
      MarkdownTextMode.input => _InputField(
        data: data,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        placeholderTextStyle: resolvedPlaceholderTextStyle,
        resolvedTextStyle: resolvedTextStyle,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
        scrollPadding: scrollPadding,
        variants: variants,
        useToolBar: useToolBar,
        allowAttachments: allowAttachments,
      ),
      MarkdownTextMode.inputPreview => _InputPreviewField(
        data: data,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        resolvedTextStyle: resolvedTextStyle,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
        scrollPadding: scrollPadding,
        variants: variants,
        onTapLink: onTapLink,
        resolveAttachmentUrl: resolveAttachmentUrl,
        tokens: tokens,
        defaultMarkdownAlignment: defaultMarkdownAlignment,
        contentScale: contentScale,
        useToolBar: useToolBar,
        allowAttachments: allowAttachments,
      ),
    };
  }

  // ---------------------------------------------------------------------------
  // previewSelectable — MarkdownBody, selectable: true
  // ---------------------------------------------------------------------------

  Widget _buildPreviewSelectable(
    AppTokens tokens,
    TextStyle resolvedTextStyle,
  ) {
    return _buildMarkdownBody(
      tokens: tokens,
      resolvedTextStyle: resolvedTextStyle,
      data: data,
      selectable: true,
      defaultAlignment: defaultMarkdownAlignment,
      onTapLink: onTapLink ?? buildMarkdownLaunchLink(resolveAttachmentUrl),
      resolveAttachmentUrl: resolveAttachmentUrl,
      contentScale: contentScale,
    );
  }

  // ---------------------------------------------------------------------------
  // preview — MarkdownBody, selectable: false
  // ---------------------------------------------------------------------------

  Widget _buildPreview(AppTokens tokens, TextStyle resolvedTextStyle) {
    return _buildMarkdownBody(
      tokens: tokens,
      resolvedTextStyle: resolvedTextStyle,
      data: data,
      selectable: false,
      defaultAlignment: defaultMarkdownAlignment,
      onTapLink: onTapLink ?? buildMarkdownLaunchLink(resolveAttachmentUrl),
      resolveAttachmentUrl: resolveAttachmentUrl,
      contentScale: contentScale,
    );
  }

  // ---------------------------------------------------------------------------
  // raw — plain Text (not selectable)
  // ---------------------------------------------------------------------------

  Widget _buildRaw(TextStyle resolvedTextStyle) {
    return Text(data, style: resolvedTextStyle, maxLines: maxLines);
  }
}

Widget _buildMarkdownBody({
  required AppTokens tokens,
  required TextStyle resolvedTextStyle,
  required String data,
  required bool selectable,
  required WrapAlignment defaultAlignment,
  required MarkdownTapLinkCallback onTapLink,
  required MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
  double contentScale = 1,
}) {
  return buildMarkdownBody(
    tokens: tokens,
    resolvedTextStyle: resolvedTextStyle,
    data: data,
    selectable: selectable,
    defaultAlignment: defaultAlignment,
    onTapLink: onTapLink,
    resolveAttachmentUrl: resolveAttachmentUrl,
    contentScale: contentScale,
  );
}

// =============================================================================
// _InputField
// =============================================================================

class _InputField extends HookWidget {
  const _InputField({
    required this.data,
    required this.resolvedTextStyle,
    required this.variants,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines,
    this.expands = false,
    this.textAlignVertical,
    required this.scrollPadding,
    required this.placeholderTextStyle,
    required this.useToolBar,
    required this.allowAttachments,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle placeholderTextStyle;
  final TextStyle resolvedTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets scrollPadding;
  final Iterable<Object> variants;
  final bool useToolBar;
  final bool allowAttachments;

  @override
  Widget build(BuildContext context) {
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;
    final internalFocusNode = useFocusNode();
    final effectiveFocusNode = focusNode ?? internalFocusNode;
    final toolBarController = useToolBar ? ToolBarScope.maybeOf(context) : null;

    useEffect(() {
      if (effectiveController.text != data) {
        effectiveController.text = data;
      }
      return null;
    }, [data, effectiveController]);

    useEffect(
      () {
        if (toolBarController == null) return null;

        void listener() {
          if (effectiveFocusNode.hasFocus) {
            toolBarController.setActiveTextController(
              effectiveController,
              allowAttachments: allowAttachments,
            );
          } else {
            toolBarController.clearActiveTextController(effectiveController);
          }
        }

        effectiveFocusNode.addListener(listener);
        listener();
        return () {
          effectiveFocusNode.removeListener(listener);
          toolBarController.clearActiveTextController(effectiveController);
        };
      },
      [
        effectiveFocusNode,
        effectiveController,
        toolBarController,
        allowAttachments,
      ],
    );

    return TextField(
      variants: variants,
      controller: effectiveController,
      focusNode: effectiveFocusNode,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      placeholder: placeholder,
      placeholderTextStyle: placeholderTextStyle,
      style: resolvedTextStyle,
      keyboardType: keyboardType ?? TextInputType.multiline,
      textInputAction: textInputAction ?? TextInputAction.newline,
      obscureText: obscureText,
      maxLines: maxLines,
      expands: expands,
      textAlignVertical: textAlignVertical,
      scrollPadding: scrollPadding,
    );
  }
}

// =============================================================================
// _InputPreviewField
// =============================================================================

class _InputPreviewField extends HookWidget {
  const _InputPreviewField({
    required this.data,
    required this.resolvedTextStyle,
    required this.variants,
    required this.tokens,
    required this.contentScale,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines,
    this.expands = false,
    this.textAlignVertical,
    required this.scrollPadding,
    this.onTapLink,
    this.resolveAttachmentUrl,
    required this.defaultMarkdownAlignment,
    required this.useToolBar,
    required this.allowAttachments,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle resolvedTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets scrollPadding;
  final Iterable<Object> variants;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final AppTokens tokens;
  final WrapAlignment defaultMarkdownAlignment;
  final double contentScale;
  final bool useToolBar;
  final bool allowAttachments;

  @override
  Widget build(BuildContext context) {
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;

    final internalFocusNode = useFocusNode();
    final effectiveFocusNode = focusNode ?? internalFocusNode;
    final toolBarController = useToolBar ? ToolBarScope.maybeOf(context) : null;

    final isEditing = useState(effectiveFocusNode.hasFocus);

    useEffect(() {
      if (effectiveController.text != data) {
        effectiveController.text = data;
      }
      return null;
    }, [data, effectiveController]);

    useEffect(() {
      void listener() => isEditing.value = effectiveFocusNode.hasFocus;
      effectiveFocusNode.addListener(listener);
      return () => effectiveFocusNode.removeListener(listener);
    }, [effectiveFocusNode]);

    useEffect(
      () {
        if (toolBarController == null) return null;

        void listener() {
          if (effectiveFocusNode.hasFocus) {
            toolBarController.setActiveTextController(
              effectiveController,
              allowAttachments: allowAttachments,
            );
          } else {
            toolBarController.clearActiveTextController(effectiveController);
          }
        }

        effectiveFocusNode.addListener(listener);
        listener();
        return () {
          effectiveFocusNode.removeListener(listener);
          toolBarController.clearActiveTextController(effectiveController);
        };
      },
      [
        effectiveFocusNode,
        effectiveController,
        toolBarController,
        allowAttachments,
      ],
    );

    if (isEditing.value) {
      return TextField(
        variants: variants,
        controller: effectiveController,
        focusNode: effectiveFocusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        style: resolvedTextStyle,
        keyboardType: keyboardType ?? TextInputType.multiline,
        textInputAction: textInputAction ?? TextInputAction.newline,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
        scrollPadding: scrollPadding,
        autofocus: true,
      );
    }

    return GestureDetector(
      onTap: () {
        isEditing.value = true;
        effectiveFocusNode.requestFocus();
      },
      child: _buildMarkdownBody(
        tokens: tokens,
        resolvedTextStyle: resolvedTextStyle,
        data: effectiveController.text,
        selectable: false,
        defaultAlignment: defaultMarkdownAlignment,
        // Links in inputPreview use the caller's handler or the default
        // launcher. Tapping a link should NOT switch to edit mode, so
        // the GestureDetector above won't interfere because MarkdownBody
        // calls onTapLink and stops the gesture from bubbling.
        onTapLink: onTapLink ?? buildMarkdownLaunchLink(resolveAttachmentUrl),
        resolveAttachmentUrl: resolveAttachmentUrl,
        contentScale: contentScale,
      ),
    );
  }
}
