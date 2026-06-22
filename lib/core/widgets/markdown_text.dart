import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextColor,
        TextFieldFrame,
        TextFieldSize,
        TextFieldColor,
        TextSize,
        TextWeight,
        TextField,
        textStyle,
        MarkdownHelper;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:theme_variants/theme_variants.dart';
import 'package:url_launcher/url_launcher.dart';

typedef MarkdownAttachmentUrlResolver = String? Function(Uri uri);

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
    this.variants = const [TextFieldSize.normal, TextFieldFrame.outline],
    this.mode = MarkdownTextMode.raw,
    this.onTapLink,
    this.resolveAttachmentUrl,
    this.baseTextStyle,
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
  final Iterable<Object> variants;
  final MarkdownTextMode mode;

  /// Called when a link is tapped in preview modes. When null, links are
  /// opened via [url_launcher] automatically.
  final MarkdownTapLinkCallback? onTapLink;

  /// Resolves markdown attachment URIs like `attachment:<id>` to displayable
  /// URLs. Used for images and by the default link launcher.
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
        variants: variants,
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
        variants: variants,
        onTapLink: onTapLink,
        resolveAttachmentUrl: resolveAttachmentUrl,
        tokens: tokens,
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
    return MarkdownBody(
      data: data,
      selectable: true,
      onTapLink: onTapLink ?? _buildLaunchLink(resolveAttachmentUrl),
      imageBuilder: _buildImageBuilder(tokens, resolveAttachmentUrl),
      styleSheet: MarkdownHelper.getMarkdownStyleSheet(
        tokens,
        resolvedTextStyle,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // preview — MarkdownBody, selectable: false
  // ---------------------------------------------------------------------------

  Widget _buildPreview(AppTokens tokens, TextStyle resolvedTextStyle) {
    return MarkdownBody(
      data: data,
      selectable: false,
      onTapLink: onTapLink ?? _buildLaunchLink(resolveAttachmentUrl),
      imageBuilder: _buildImageBuilder(tokens, resolveAttachmentUrl),
      styleSheet: MarkdownHelper.getMarkdownStyleSheet(
        tokens,
        resolvedTextStyle,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // raw — plain Text (not selectable)
  // ---------------------------------------------------------------------------

  Widget _buildRaw(TextStyle resolvedTextStyle) {
    return Text(data, style: resolvedTextStyle, maxLines: maxLines);
  }
}

// =============================================================================
// Link handler
// =============================================================================

/// Default link handler used by preview modes when [MarkdownText.onTapLink]
/// is null. Launches [href] via url_launcher, ignoring null or un-launchable
/// URIs silently.
MarkdownTapLinkCallback _buildLaunchLink(
  MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
) {
  return (String text, String? href, String title) async {
    if (href == null) return;
    final uri = Uri.tryParse(href);
    if (uri == null) return;

    final resolvedHref = _resolveAttachmentHref(uri, resolveAttachmentUrl);
    if (resolvedHref == null) return;

    await _launchLink(resolvedHref);
  };
}

Future<void> _launchLink(String href) async {
  final uri = Uri.tryParse(href);
  if (uri == null) return;
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

MarkdownImageBuilder? _buildImageBuilder(
  AppTokens tokens,
  MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
) {
  if (resolveAttachmentUrl == null) return null;

  return (Uri uri, String? title, String? alt) {
    final src = _resolveAttachmentHref(uri, resolveAttachmentUrl);
    if (src == null) return const SizedBox.shrink();

    final resolvedUri = Uri.tryParse(src);
    if (resolvedUri == null || !resolvedUri.hasScheme) {
      return const SizedBox.shrink();
    }

    if (resolvedUri.scheme == 'http' || resolvedUri.scheme == 'https') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
        child: Image.network(
          src,
          fit: BoxFit.contain,
          semanticLabel: alt,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      );
    }

    return const SizedBox.shrink();
  };
}

String? _resolveAttachmentHref(
  Uri uri,
  MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
) {
  if (uri.scheme != 'attachment') return uri.toString();
  return resolveAttachmentUrl?.call(uri);
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
    required this.placeholderTextStyle,
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
  final Iterable<Object> variants;

  @override
  Widget build(BuildContext context) {
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;

    useEffect(() {
      if (effectiveController.text != data) {
        effectiveController.text = data;
      }
      return null;
    }, [data, effectiveController]);

    return TextField(
      variants: variants,
      controller: effectiveController,
      focusNode: focusNode,
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
    this.onTapLink,
    this.resolveAttachmentUrl,
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
  final Iterable<Object> variants;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;

    final internalFocusNode = useFocusNode();
    final effectiveFocusNode = focusNode ?? internalFocusNode;

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
        autofocus: true,
      );
    }

    return GestureDetector(
      onTap: () {
        isEditing.value = true;
        effectiveFocusNode.requestFocus();
      },
      child: MarkdownBody(
        data: effectiveController.text,
        selectable: false,
        // Links in inputPreview use the caller's handler or the default
        // launcher. Tapping a link should NOT switch to edit mode, so
        // the GestureDetector above won't interfere because MarkdownBody
        // calls onTapLink and stops the gesture from bubbling.
        onTapLink: onTapLink ?? _buildLaunchLink(resolveAttachmentUrl),
        imageBuilder: _buildImageBuilder(tokens, resolveAttachmentUrl),
        styleSheet: MarkdownHelper.getMarkdownStyleSheet(
          tokens,
          resolvedTextStyle,
        ),
      ),
    );
  }
}
