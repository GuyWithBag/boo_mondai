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
        ImageHelper,
        textStyle,
        MarkdownHelper,
        MediaHelper,
        StoredMediaService,
        StoredMediaKind;
import 'package:boo_mondai/features/markdown_audio_player/markdown_audio_player.dart';
import 'package:boo_mondai/features/stored_media/models/stored_media.dto.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
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
    this.scrollPadding = const EdgeInsets.all(20),
    this.variants = const [TextFieldSize.normal, TextFieldFrame.outline],
    this.mode = MarkdownTextMode.raw,
    this.onTapLink,
    this.resolveAttachmentUrl,
    this.baseTextStyle,
    this.defaultMarkdownAlignment = WrapAlignment.center,
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
      onTapLink: onTapLink ?? _buildLaunchLink(resolveAttachmentUrl),
      resolveAttachmentUrl: resolveAttachmentUrl,
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
      onTapLink: onTapLink ?? _buildLaunchLink(resolveAttachmentUrl),
      resolveAttachmentUrl: resolveAttachmentUrl,
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
// Markdown rendering extensions
// =============================================================================

const _alignedLineTag = 'aligned-line';

Widget _buildMarkdownBody({
  required AppTokens tokens,
  required TextStyle resolvedTextStyle,
  required String data,
  required bool selectable,
  required WrapAlignment defaultAlignment,
  required MarkdownTapLinkCallback onTapLink,
  required MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
}) {
  final styleSheet = _copyStyleSheetWithAlignment(
    MarkdownHelper.getMarkdownStyleSheet(tokens, resolvedTextStyle),
    defaultAlignment,
  );
  final imageBuilder = _buildImageBuilder(tokens, resolveAttachmentUrl);

  return Align(
    alignment: _alignmentForWrapAlignment(defaultAlignment),
    child: MarkdownBody(
      data: _rewriteImageAttributeSyntax(data),
      selectable: selectable,
      fitContent: false,
      blockSyntaxes: [_AlignedLineSyntax()],
      builders: {
        'a': _MarkdownLinkBuilder(
          onTapLink: onTapLink,
          resolveAttachmentUrl: resolveAttachmentUrl,
        ),
        _alignedLineTag: _AlignedLineBuilder(
          selectable: selectable,
          onTapLink: onTapLink,
          resolveAttachmentUrl: resolveAttachmentUrl,
          imageBuilder: imageBuilder,
          styleSheet: styleSheet,
        ),
      },
      onTapLink: onTapLink,
      imageBuilder: imageBuilder,
      styleSheet: styleSheet,
    ),
  );
}

class _AlignedLineSyntax extends md.BlockSyntax {
  static final _pattern = RegExp(r'^\](<|=|>)\s*(.+)$');

  @override
  RegExp get pattern => _pattern;

  @override
  md.Node parse(md.BlockParser parser) {
    final match = _pattern.firstMatch(parser.current.content)!;
    parser.advance();

    return md.Element.empty(_alignedLineTag)
      ..attributes['align'] = match.group(1)!
      ..attributes['content'] = match.group(2)!;
  }
}

class _AlignedLineBuilder extends MarkdownElementBuilder {
  _AlignedLineBuilder({
    required this.selectable,
    required this.onTapLink,
    required this.resolveAttachmentUrl,
    required this.imageBuilder,
    required this.styleSheet,
  });

  final bool selectable;
  final MarkdownTapLinkCallback onTapLink;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final MarkdownImageBuilder? imageBuilder;
  final MarkdownStyleSheet styleSheet;

  @override
  bool isBlockElement() => true;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return Align(
      alignment: _alignmentForWrapAlignment(
        _wrapAlignmentForMarker(element.attributes['align']),
      ),
      child: MarkdownBody(
        data: _rewriteImageAttributeSyntax(element.attributes['content'] ?? ''),
        selectable: selectable,
        fitContent: false,
        onTapLink: onTapLink,
        builders: {
          'a': _MarkdownLinkBuilder(
            onTapLink: onTapLink,
            resolveAttachmentUrl: resolveAttachmentUrl,
          ),
        },
        imageBuilder: imageBuilder,
        styleSheet: _alignStyleSheet(styleSheet, element.attributes['align']),
      ),
    );
  }
}

class _MarkdownLinkBuilder extends MarkdownElementBuilder {
  _MarkdownLinkBuilder({
    required this.onTapLink,
    required this.resolveAttachmentUrl,
  });

  final MarkdownTapLinkCallback onTapLink;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final href = element.attributes['href'];
    final title = element.attributes['title'] ?? '';
    final label = element.textContent.trim().isEmpty
        ? href ?? 'Audio'
        : element.textContent.trim();
    final audioSource = _resolveAudioSource(href, resolveAttachmentUrl);

    if (audioSource != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: MarkdownAudioPlayer(source: audioSource, label: label),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTapLink(label, href, title),
      child: Text(label, style: preferredStyle ?? parentStyle),
    );
  }
}

String? _resolveAudioSource(
  String? href,
  MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
) {
  if (href == null) return null;
  final uri = Uri.tryParse(href);
  if (uri == null) return null;

  final storedMedia = _storedMediaFromUri(uri);
  if (storedMedia != null &&
      MediaHelper.isAudioMimeType(storedMedia.mimeType)) {
    return _resolveAttachmentHref(uri, resolveAttachmentUrl);
  }

  final resolvedHref = _resolveAttachmentHref(uri, resolveAttachmentUrl);
  if (resolvedHref == null) return null;

  final kind = MediaHelper.kindFromSource(resolvedHref);
  return kind == StoredMediaKind.audio ? resolvedHref : null;
}

StoredMedia? _storedMediaFromUri(Uri uri) {
  if (uri.scheme == 'local') {
    final id = uri.path.isNotEmpty ? uri.path : uri.host;
    return StoredMediaService.getById(id);
  }

  final normalizedSource = MarkdownHelper.normalizeMediaSource(uri.toString());
  return StoredMediaService.getByRemoteUrl(normalizedSource);
}

MarkdownStyleSheet _alignStyleSheet(
  MarkdownStyleSheet styleSheet,
  String? marker,
) {
  return _copyStyleSheetWithAlignment(
    styleSheet,
    _wrapAlignmentForMarker(marker),
  );
}

WrapAlignment _wrapAlignmentForMarker(String? marker) {
  return switch (marker) {
    '=' => WrapAlignment.center,
    '>' => WrapAlignment.end,
    _ => WrapAlignment.start,
  };
}

Alignment _alignmentForWrapAlignment(WrapAlignment alignment) {
  return switch (alignment) {
    WrapAlignment.center => Alignment.center,
    WrapAlignment.end => Alignment.centerRight,
    _ => Alignment.centerLeft,
  };
}

MarkdownStyleSheet _copyStyleSheetWithAlignment(
  MarkdownStyleSheet styleSheet,
  WrapAlignment alignment,
) {
  return styleSheet.copyWith(
    textAlign: alignment,
    h1Align: alignment,
    h2Align: alignment,
    h3Align: alignment,
    h4Align: alignment,
    h5Align: alignment,
    h6Align: alignment,
    unorderedListAlign: alignment,
    orderedListAlign: alignment,
    blockquoteAlign: alignment,
    codeblockAlign: alignment,
  );
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
  return (Uri uri, String? title, String? alt) {
    final src = _resolveAttachmentHref(uri, resolveAttachmentUrl);
    if (src == null) return const SizedBox.shrink();

    final image = ImageHelper.getImageProviderFromSource(src);
    if (image == null) return const SizedBox.shrink();
    final options = _MarkdownImageOptions.parse(title);
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
      child: Image(
        image: image,
        width: options.pixelWidth,
        height: options.pixelHeight,
        fit: options.fit,
        semanticLabel: alt,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );

    return Align(
      alignment: options.alignment,
      child: FractionallySizedBox(
        widthFactor: options.widthFactor,
        heightFactor: options.heightFactor,
        child: child,
      ),
    );
  };
}

String? _resolveAttachmentHref(
  Uri uri,
  MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
) {
  return resolveAttachmentUrl?.call(uri) ??
      MarkdownHelper.resolveMediaSourceUri(uri);
}

String _rewriteImageAttributeSyntax(String data) {
  return data.replaceAllMapped(
    RegExp(r'!\[([^\]\r\n]*)\]\(([^)\r\n]+)\)\{([^}\r\n]+)\}'),
    (match) {
      final alt = match.group(1) ?? '';
      final source = match.group(2) ?? '';
      final params = match.group(3) ?? '';
      final escapedParams = params
          .replaceAll(r'\', r'\\')
          .replaceAll('"', r'\"');
      return '![$alt]($source "__bm_image_options:$escapedParams")';
    },
  );
}

class _MarkdownImageOptions {
  const _MarkdownImageOptions({
    this.pixelWidth,
    this.pixelHeight,
    this.widthFactor,
    this.heightFactor,
    required this.fit,
    required this.alignment,
  });

  final double? pixelWidth;
  final double? pixelHeight;
  final double? widthFactor;
  final double? heightFactor;
  final BoxFit fit;
  final Alignment alignment;

  static _MarkdownImageOptions parse(String? title) {
    final raw = title?.trim();
    if (raw == null || !raw.startsWith('__bm_image_options:')) {
      return const _MarkdownImageOptions(
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    }

    final params = _parseParams(raw.substring('__bm_image_options:'.length));
    final size = params['size'];
    final width = _dimension(params['w'] ?? params['width']);
    final height = _dimension(params['h'] ?? params['height']);

    return _MarkdownImageOptions(
      pixelWidth: width.pixelValue ?? _sizeWidth(size),
      pixelHeight: height.pixelValue,
      widthFactor: width.factorValue ?? _sizeWidthFactor(size),
      heightFactor: height.factorValue,
      fit: _fit(params['fit']),
      alignment: _alignment(params['align']),
    );
  }

  static Map<String, String> _parseParams(String raw) {
    final params = <String, String>{};
    for (final match in RegExp(
      r'([A-Za-z][\w-]*)\s*=\s*("[^"]*"|[^\s]+)',
    ).allMatches(raw)) {
      final key = match.group(1)?.trim().toLowerCase();
      var value = match.group(2)?.trim();
      if (key == null || value == null || key.isEmpty) continue;
      if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      params[key] = value;
    }
    return params;
  }

  static _Dimension _dimension(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return const _Dimension();

    if (value.endsWith('%')) {
      final percent = double.tryParse(
        value.substring(0, value.length - 1).trim(),
      );
      if (percent == null) return const _Dimension();
      return _Dimension(factorValue: (percent / 100).clamp(0, 1));
    }

    final pixels = double.tryParse(value);
    return _Dimension(pixelValue: pixels);
  }

  static double? _sizeWidth(String? size) {
    return switch (size?.trim().toLowerCase()) {
      'xs' => 96,
      'sm' || 'small' => 160,
      'md' || 'medium' => 240,
      'lg' || 'large' => 360,
      _ => null,
    };
  }

  static double? _sizeWidthFactor(String? size) {
    return switch (size?.trim().toLowerCase()) {
      'full' => 1,
      _ => null,
    };
  }

  static BoxFit _fit(String? fit) {
    return switch (fit?.trim().toLowerCase()) {
      'cover' => BoxFit.cover,
      'fill' => BoxFit.fill,
      'fitwidth' || 'fit_width' || 'fit-width' => BoxFit.fitWidth,
      'fitheight' || 'fit_height' || 'fit-height' => BoxFit.fitHeight,
      _ => BoxFit.contain,
    };
  }

  static Alignment _alignment(String? align) {
    return switch (align?.trim().toLowerCase()) {
      'left' || 'start' => Alignment.centerLeft,
      'right' || 'end' => Alignment.centerRight,
      _ => Alignment.center,
    };
  }
}

class _Dimension {
  const _Dimension({this.pixelValue, this.factorValue});

  final double? pixelValue;
  final double? factorValue;
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
        onTapLink: onTapLink ?? _buildLaunchLink(resolveAttachmentUrl),
        resolveAttachmentUrl: resolveAttachmentUrl,
      ),
    );
  }
}
