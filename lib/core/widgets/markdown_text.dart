import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        TextSize,
        TextTone,
        TextWeight,
        VariantTextField,
        appTextStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum MarkdownTextMode { input, raw, preview }

class MarkdownText extends HookWidget {
  const MarkdownText({
    required this.data,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.textStyle,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
    this.variants = const [
      TextFieldSize.normal,
      TextFieldFrame.outline,
      TextFieldTone.neutral,
    ],
    this.mode = MarkdownTextMode.preview,
    this.selectable = true,
    this.onTapLink,
    super.key,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final Iterable<Object> variants;
  final MarkdownTextMode mode;
  final bool selectable;
  final MarkdownTapLinkCallback? onTapLink;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;
    final defaultTextStyle = appTextStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.body,
      TextTone.primary,
    ]);
    final rawStyle = (textStyle ?? defaultTextStyle).copyWith(
      fontFamily: 'monospace',
    );
    final placeholderStyle = appTextStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.body,
      TextTone.muted,
    ]);

    useEffect(() {
      if (effectiveController.text != data) {
        effectiveController.text = data;
      }
      return null;
    }, [data, effectiveController]);

    final body = _MarkdownBody(
      data: data,
      textStyle: textStyle,
      selectable: selectable,
      onTapLink: onTapLink,
    );

    return switch (mode) {
      MarkdownTextMode.input => VariantTextField(
        variants: variants,
        controller: effectiveController,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        textStyle: textStyle,
        keyboardType: keyboardType ?? TextInputType.multiline,
        textInputAction: textInputAction ?? TextInputAction.newline,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
      ),
      MarkdownTextMode.raw => _MarkdownRawView(
        value: data,
        placeholder: placeholder,
        textStyle: rawStyle,
        placeholderStyle: placeholderStyle,
      ),
      MarkdownTextMode.preview =>
        data.trim().isEmpty
            ? _MarkdownEmptyPreview(
                placeholder: placeholder,
                style: placeholderStyle,
              )
            : body,
    };
  }
}

class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({
    required this.data,
    required this.textStyle,
    required this.selectable,
    required this.onTapLink,
  });

  final String data;
  final TextStyle? textStyle;
  final bool selectable;
  final MarkdownTapLinkCallback? onTapLink;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return MarkdownBody(
      data: data,
      selectable: selectable,
      onTapLink: onTapLink,
      styleSheet: _styleSheet(tokens, textStyle),
    );
  }

  MarkdownStyleSheet _styleSheet(AppTokens tokens, TextStyle? baseTextStyle) {
    final body =
        baseTextStyle ??
        appTextStyle.resolve(tokens, const [
          TextSize.label,
          TextWeight.body,
          TextTone.primary,
        ]);
    final bodyFontSize = body.fontSize;
    final strong = body.copyWith(fontWeight: tokens.fontWeightTextStrong);
    final heading = body.copyWith(fontWeight: tokens.fontWeightTextHeavy);
    final code = body.copyWith(
      backgroundColor: tokens.softGray,
      color: tokens.textPrimary,
      fontFamily: 'monospace',
      fontSize: tokens.textSizeLabelSmall.sp,
      height: tokens.lineHeightTextBody,
    );

    return MarkdownStyleSheet(
      a: body.copyWith(
        color: tokens.primary,
        decoration: TextDecoration.underline,
        decorationColor: tokens.primary,
      ),
      p: body,
      pPadding: EdgeInsets.zero,
      code: code,
      h1: heading.copyWith(
        fontSize: bodyFontSize == null ? null : bodyFontSize * 1.35,
      ),
      h1Padding: EdgeInsets.only(bottom: tokens.spacePanelGapSm),
      h2: heading.copyWith(
        fontSize: bodyFontSize == null ? null : bodyFontSize * 1.2,
      ),
      h2Padding: EdgeInsets.only(bottom: tokens.spacePanelGapSm),
      h3: heading.copyWith(
        fontSize: bodyFontSize == null ? null : bodyFontSize * 1.1,
      ),
      h3Padding: EdgeInsets.only(bottom: tokens.spacePanelGapSm),
      h4: strong,
      h4Padding: EdgeInsets.zero,
      h5: strong,
      h5Padding: EdgeInsets.zero,
      h6: body.copyWith(
        color: tokens.textSecondary,
        fontSize: bodyFontSize == null ? null : bodyFontSize * 0.9,
        fontWeight: tokens.fontWeightTextStrong,
      ),
      h6Padding: EdgeInsets.zero,
      em: body.copyWith(fontStyle: FontStyle.italic),
      strong: strong,
      del: body.copyWith(decoration: TextDecoration.lineThrough),
      blockquote: body.copyWith(color: tokens.textSecondary),
      img: body,
      checkbox: body.copyWith(color: tokens.primary),
      blockSpacing: tokens.spacePanelGapMd,
      listIndent: tokens.spacePanelPadding,
      listBullet: body,
      listBulletPadding: EdgeInsets.only(right: tokens.spacePanelGapSm),
      tableHead: strong,
      tableBody: body,
      tableHeadAlign: TextAlign.left,
      tablePadding: EdgeInsets.only(bottom: tokens.spacePanelGapSm),
      tableBorder: TableBorder.all(
        color: tokens.borderNeutralSubtle,
        width: tokens.borderWidthDefault,
      ),
      tableCellsPadding: EdgeInsets.symmetric(
        horizontal: tokens.spacePanelGapMd,
        vertical: tokens.spacePanelGapSm,
      ),
      blockquotePadding: EdgeInsets.symmetric(
        horizontal: tokens.spacePanelGapMd,
        vertical: tokens.spacePanelGapSm,
      ),
      blockquoteDecoration: BoxDecoration(
        color: tokens.primarySoft,
        border: Border(
          left: BorderSide(
            color: tokens.primary,
            width: tokens.borderWidthDefault * 3,
          ),
        ),
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
      ),
      codeblockPadding: EdgeInsets.all(tokens.spacePanelGapMd),
      codeblockDecoration: BoxDecoration(
        color: tokens.softGray,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
        border: Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
      ),
    );
  }
}

class _MarkdownRawView extends StatelessWidget {
  const _MarkdownRawView({
    required this.value,
    required this.placeholder,
    required this.textStyle,
    required this.placeholderStyle,
  });

  final String value;
  final String? placeholder;
  final TextStyle textStyle;
  final TextStyle placeholderStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final text = value.isEmpty ? placeholder ?? '' : value;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacePanelPaddingSm),
      decoration: BoxDecoration(
        color: tokens.softGray,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
        border: Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
      child: SelectableText(
        text,
        style: value.isEmpty ? placeholderStyle : textStyle,
      ),
    );
  }
}

class _MarkdownEmptyPreview extends StatelessWidget {
  const _MarkdownEmptyPreview({required this.placeholder, required this.style});

  final String? placeholder;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(placeholder ?? '', style: style);
  }
}
