import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        TextSize,
        TextColor,
        TextWeight,
        VariantTextField,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

enum MarkdownTextMode { input, raw, preview }

MarkdownStyleSheet _markdownStyleSheet(AppTokens tokens, TextStyle body) {
  final bodyFontSize = body.fontSize;
  final strong = body.copyWith(fontWeight: tokens.fontWeightTextStrong);
  final heading = body.copyWith(fontWeight: tokens.fontWeightTextHeavy);
  final code = body.copyWith(
    backgroundColor: tokens.colorMuted,
    color: tokens.colorTextBaseline,
    fontFamily: 'monospace',
    fontSize: tokens.textSizeLabelSmall.sp,
    height: tokens.lineHeightTextBody,
  );

  return MarkdownStyleSheet(
    a: body.copyWith(
      color: tokens.colorPrimary,
      decoration: TextDecoration.underline,
      decorationColor: tokens.colorPrimary,
    ),
    p: body,
    pPadding: EdgeInsets.zero,
    code: code,
    h1: heading.copyWith(
      fontSize: bodyFontSize == null ? null : bodyFontSize * 1.35,
    ),
    h1Padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
    h2: heading.copyWith(
      fontSize: bodyFontSize == null ? null : bodyFontSize * 1.2,
    ),
    h2Padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
    h3: heading.copyWith(
      fontSize: bodyFontSize == null ? null : bodyFontSize * 1.1,
    ),
    h3Padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
    h4: strong,
    h4Padding: EdgeInsets.zero,
    h5: strong,
    h5Padding: EdgeInsets.zero,
    h6: body.copyWith(
      color: tokens.colorTextSecondary,
      fontSize: bodyFontSize == null ? null : bodyFontSize * 0.9,
      fontWeight: tokens.fontWeightTextStrong,
    ),
    h6Padding: EdgeInsets.zero,
    em: body.copyWith(fontStyle: FontStyle.italic),
    strong: strong,
    del: body.copyWith(decoration: TextDecoration.lineThrough),
    blockquote: body.copyWith(color: tokens.colorTextSecondary),
    img: body,
    checkbox: body.copyWith(color: tokens.colorPrimary),
    blockSpacing: tokens.spaceLayoutGapMd,
    listIndent: tokens.spaceLayoutGapMd,
    listBullet: body,
    listBulletPadding: EdgeInsets.only(right: tokens.spaceLayoutGapSm),
    tableHead: strong,
    tableBody: body,
    tableHeadAlign: TextAlign.left,
    tablePadding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
    tableBorder: TableBorder.all(
      color: tokens.colorBorderNeutralSubtle,
      width: tokens.borderWidthDefault,
    ),
    tableCellsPadding: EdgeInsets.symmetric(
      horizontal: tokens.spaceLayoutGapMd,
      vertical: tokens.spaceLayoutGapSm,
    ),
    blockquotePadding: EdgeInsets.symmetric(
      horizontal: tokens.spaceLayoutGapMd,
      vertical: tokens.spaceLayoutGapSm,
    ),
    blockquoteDecoration: BoxDecoration(
      color: tokens.colorPrimarySoft,
      border: Border(
        left: BorderSide(
          color: tokens.colorPrimary,
          width: tokens.borderWidthDefault * 3,
        ),
      ),
      borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
    ),
    codeblockPadding: EdgeInsets.all(tokens.spaceLayoutGapMd),
    codeblockDecoration: BoxDecoration(
      color: tokens.colorMuted,
      borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
      border: Border.all(
        color: tokens.colorBorderNeutralSubtle,
        width: tokens.borderWidthDefault,
      ),
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
    ),
  );
}

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
    this.variants = const [
      TextFieldSize.normal,
      TextFieldFrame.outline,
      TextFieldTone.neutral,
    ],
    this.mode = MarkdownTextMode.raw,
    this.selectable = true,
    this.onTapLink,
    this.baseTextStyle,
    super.key,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle? baseTextStyle;
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

    final resolvedTextStyle =
        baseTextStyle ??
        textStyle.resolve(tokens, const [
          TextSize.label,
          TextWeight.body,
          TextColor.baseline,
        ]);

    if (mode == MarkdownTextMode.input) {
      final internalController = useTextEditingController(text: data);
      final effectiveController = controller ?? internalController;

      useEffect(() {
        if (effectiveController.text != data) {
          effectiveController.text = data;
        }
        return null;
      }, [data, effectiveController]);

      return VariantTextField(
        variants: variants,
        controller: effectiveController,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        textStyle: resolvedTextStyle,
        keyboardType: keyboardType ?? TextInputType.multiline,
        textInputAction: textInputAction ?? TextInputAction.newline,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
      );
    }

    return switch (mode) {
      MarkdownTextMode.raw => SelectableText(data, style: resolvedTextStyle),
      MarkdownTextMode.preview => MarkdownBody(
        data: data,
        selectable: selectable,
        onTapLink: onTapLink,
        styleSheet: _markdownStyleSheet(tokens, resolvedTextStyle),
      ),
      MarkdownTextMode.input => throw StateError('unreachable'),
    };
  }
}
