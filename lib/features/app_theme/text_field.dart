import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:boo_mondai/lib.barrel.dart' show AppTokens, textFieldStyle;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    as material
    show TextField, InputDecoration, InputCounterWidgetBuilder;
import 'package:flutter/material.dart'
    hide TextField, InputDecoration, InputCounterWidgetBuilder;
import 'package:flutter/services.dart';
import 'package:theme_variants/theme_variants.dart';

/// A drop-in replacement for [material.TextField] that resolves its visual
/// style from [textFieldStyle] based on [variants], while exposing every
/// parameter that [material.TextField] exposes.
///
/// Import this file and use [TextField] exactly as you would
/// [material.TextField]; the only extra required argument is [variants].
///
/// ```dart
/// TextField(
///   variants: [TextFieldSize.normal, TextFieldFrame.outline, TextFieldColor.neutral],
///   controller: _controller,
///   placeholder: 'Search…',
/// )
/// ```
class TextField extends StatelessWidget {
  const TextField({
    super.key,
    this.variants = const [],
    this.groupId = EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    // Intentionally omitted: decoration — use [placeholder] and the token
    // system instead. Pass [decorationOverride] for one-off overrides.
    this.placeholder,
    this.decorationOverride,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.statesController,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectAllOnFocus,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onTapUpOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.enableInlinePrediction,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.hintLocales,
    this.placeholderTextStyle,
  }) : assert(obscuringCharacter.length == 1),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         (maxLines == null) || (minLines == null) || (maxLines >= minLines),
         "minLines can't be greater than maxLines",
       ),
       assert(
         !expands || (maxLines == null && minLines == null),
         'minLines and maxLines must be null when expands is true.',
       ),
       assert(
         !obscureText || maxLines == 1,
         'Obscured fields cannot be multiline.',
       ),
       assert(maxLength == null || maxLength == noMaxLength || maxLength > 0);

  // ---------------------------------------------------------------------------
  // BooMondai-specific
  // ---------------------------------------------------------------------------

  /// Variant tokens that drive visual style (size, frame, tone).
  final Iterable<Object> variants;

  /// Hint text rendered by [InputDecoration.hintText].
  /// Prefer this over putting hint text inside [decorationOverride].
  final String? placeholder;

  /// Optional override applied on top of the token-derived [InputDecoration].
  /// Use sparingly — prefer [variants] for systematic styling.
  final material.InputDecoration? decorationOverride;

  // ---------------------------------------------------------------------------
  // Material TextField params (mirrors flutter/material/text_field.dart)
  // ---------------------------------------------------------------------------

  /// See [material.TextField.groupId].
  final Object groupId;

  /// See [material.TextField.controller].
  final TextEditingController? controller;

  /// See [material.TextField.focusNode].
  final FocusNode? focusNode;

  /// See [material.TextField.undoController].
  final UndoHistoryController? undoController;

  /// See [material.TextField.keyboardType].
  final TextInputType? keyboardType;

  /// See [material.TextField.textInputAction].
  final TextInputAction? textInputAction;

  /// See [material.TextField.textCapitalization].
  final TextCapitalization textCapitalization;

  /// See [material.TextField.style].
  final TextStyle? placeholderTextStyle;

  /// See [material.TextField.style].
  final TextStyle? style;

  /// See [material.TextField.strutStyle].
  final StrutStyle? strutStyle;

  /// See [material.TextField.textAlign].
  final TextAlign textAlign;

  /// See [material.TextField.textAlignVertical].
  final TextAlignVertical? textAlignVertical;

  /// See [material.TextField.textDirection].
  final TextDirection? textDirection;

  /// See [material.TextField.readOnly].
  final bool readOnly;

  /// See [material.TextField.showCursor].
  final bool? showCursor;

  /// See [material.TextField.autofocus].
  final bool autofocus;

  /// See [material.TextField.statesController].
  final MaterialStatesController? statesController;

  /// See [material.TextField.obscuringCharacter].
  final String obscuringCharacter;

  /// See [material.TextField.obscureText].
  final bool obscureText;

  /// See [material.TextField.autocorrect].
  final bool? autocorrect;

  /// See [material.TextField.smartDashesType].
  final SmartDashesType? smartDashesType;

  /// See [material.TextField.smartQuotesType].
  final SmartQuotesType? smartQuotesType;

  /// See [material.TextField.enableSuggestions].
  final bool enableSuggestions;

  /// See [material.TextField.maxLines].
  final int? maxLines;

  /// See [material.TextField.minLines].
  final int? minLines;

  /// See [material.TextField.expands].
  final bool expands;

  /// See [material.TextField.maxLength].
  final int? maxLength;

  /// See [material.TextField.maxLengthEnforcement].
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// See [material.TextField.onChanged].
  final ValueChanged<String>? onChanged;

  /// See [material.TextField.onEditingComplete].
  final VoidCallback? onEditingComplete;

  /// See [material.TextField.onSubmitted].
  final ValueChanged<String>? onSubmitted;

  /// See [material.TextField.onAppPrivateCommand].
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// See [material.TextField.inputFormatters].
  final List<TextInputFormatter>? inputFormatters;

  /// See [material.TextField.enabled].
  final bool? enabled;

  /// See [material.TextField.ignorePointers].
  final bool? ignorePointers;

  /// See [material.TextField.cursorWidth].
  final double cursorWidth;

  /// See [material.TextField.cursorHeight].
  final double? cursorHeight;

  /// See [material.TextField.cursorRadius].
  final Radius? cursorRadius;

  /// See [material.TextField.cursorOpacityAnimates].
  final bool? cursorOpacityAnimates;

  /// See [material.TextField.cursorColor]. Defaults to token-derived value
  /// when null.
  final Color? cursorColor;

  /// See [material.TextField.cursorErrorColor].
  final Color? cursorErrorColor;

  /// See [material.TextField.selectionHeightStyle].
  final BoxHeightStyle? selectionHeightStyle;

  /// See [material.TextField.selectionWidthStyle].
  final BoxWidthStyle? selectionWidthStyle;

  /// See [material.TextField.keyboardAppearance].
  final Brightness? keyboardAppearance;

  /// See [material.TextField.scrollPadding].
  final EdgeInsets scrollPadding;

  /// See [material.TextField.dragStartBehavior].
  final DragStartBehavior dragStartBehavior;

  /// See [material.TextField.enableInteractiveSelection].
  final bool? enableInteractiveSelection;

  /// See [material.TextField.selectAllOnFocus].
  final bool? selectAllOnFocus;

  /// See [material.TextField.selectionControls].
  final TextSelectionControls? selectionControls;

  /// See [material.TextField.onTap].
  final GestureTapCallback? onTap;

  /// See [material.TextField.onTapAlwaysCalled].
  final bool onTapAlwaysCalled;

  /// See [material.TextField.onTapOutside].
  final TapRegionCallback? onTapOutside;

  /// See [material.TextField.onTapUpOutside].
  final TapRegionUpCallback? onTapUpOutside;

  /// See [material.TextField.mouseCursor].
  final MouseCursor? mouseCursor;

  /// See [material.TextField.buildCounter].
  final material.InputCounterWidgetBuilder? buildCounter;

  /// See [material.TextField.scrollController].
  final ScrollController? scrollController;

  /// See [material.TextField.scrollPhysics].
  final ScrollPhysics? scrollPhysics;

  /// See [material.TextField.autofillHints].
  final Iterable<String>? autofillHints;

  /// See [material.TextField.contentInsertionConfiguration].
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// See [material.TextField.clipBehavior].
  final Clip clipBehavior;

  /// See [material.TextField.restorationId].
  final String? restorationId;

  /// See [material.TextField.stylusHandwritingEnabled].
  final bool stylusHandwritingEnabled;

  /// See [material.TextField.enableIMEPersonalizedLearning].
  final bool enableIMEPersonalizedLearning;

  /// See [material.TextField.enableInlinePrediction].
  final bool? enableInlinePrediction;

  /// See [material.TextField.contextMenuBuilder].
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// See [material.TextField.canRequestFocus].
  final bool canRequestFocus;

  /// See [material.TextField.spellCheckConfiguration].
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// See [material.TextField.magnifierConfiguration].
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// See [material.TextField.hintLocales].
  final List<Locale>? hintLocales;

  /// Equivalent to [material.TextField.noMaxLength].
  static const int noMaxLength = -1;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final tokenStyle = textFieldStyle.resolve(tokens, variants);

    final baseDecoration = material.InputDecoration(
      hintText: placeholder,
      hintStyle: placeholderTextStyle,
    ).applyDefaults(tokenStyle.decorationTheme);

    final effectiveDecoration = decorationOverride != null
        ? baseDecoration.copyWith()
        : baseDecoration;

    return material.TextField(
      groupId: groupId,

      controller: controller,
      focusNode: focusNode,
      undoController: undoController,
      decoration: effectiveDecoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style ?? tokenStyle.textStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      statesController: statesController,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect ?? true,
      smartDashesType:
          smartDashesType ??
          (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
      smartQuotesType:
          smartQuotesType ??
          (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand,
      inputFormatters: inputFormatters,
      enabled: enabled,
      ignorePointers: ignorePointers,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorColor: cursorColor ?? tokenStyle.cursorColor,
      cursorErrorColor: cursorErrorColor,
      selectionHeightStyle: selectionHeightStyle ?? BoxHeightStyle.tight,
      selectionWidthStyle: selectionWidthStyle ?? BoxWidthStyle.tight,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectAllOnFocus: selectAllOnFocus,
      selectionControls: selectionControls,
      onTap: onTap,
      onTapAlwaysCalled: onTapAlwaysCalled,
      onTapOutside: onTapOutside,
      onTapUpOutside: onTapUpOutside,
      mouseCursor: mouseCursor,
      buildCounter: buildCounter,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      enableInlinePrediction: enableInlinePrediction,
      contextMenuBuilder: contextMenuBuilder,
      canRequestFocus: canRequestFocus,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      hintLocales: hintLocales,
    );
  }
}
