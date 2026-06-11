import 'package:boo_mondai/lib.barrel.dart'
    show
        TextFieldFrame,
        TextFieldTone,
        AppTokens,
        ChipTone,
        TextFieldSize,
        appChipStyle,
        appTextFieldStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

typedef ChipInputNormalizer = String Function(String value);

class ChipInput extends StatefulWidget {
  const ChipInput({
    required this.values,
    required this.onChanged,
    this.onChipPressed,
    this.onChipDeleted,
    this.placeholder,
    this.enabled = true,
    this.separatorPattern,
    this.allowDuplicates = false,
    this.createChipOnSubmit = true,
    this.chipTone = ChipTone.ghost,
    this.textFieldVariants = const [
      TextFieldSize.normal,
      TextFieldFrame.outline,
      TextFieldTone.neutral,
    ],
    this.normalizer,
    this.focusNode,
    this.controller,
    super.key,
  });

  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final ValueChanged<String>? onChipPressed;
  final ValueChanged<String>? onChipDeleted;
  final String? placeholder;
  final bool enabled;
  final Pattern? separatorPattern;
  final bool allowDuplicates;
  final bool createChipOnSubmit;
  final ChipTone chipTone;
  final Iterable<Object> textFieldVariants;
  final ChipInputNormalizer? normalizer;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<ChipInput> createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  late _ChipInputEditingController _controller;
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  bool _syncingExternalController = false;

  Pattern get _separatorPattern => widget.separatorPattern ?? RegExp(r'[,;\n]');

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _controller = _createController(widget.values);
    _focusNode = widget.focusNode ?? FocusNode();
    widget.controller?.addListener(_handleExternalTextChanged);
  }

  @override
  void didUpdateWidget(covariant ChipInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleExternalTextChanged);
      widget.controller?.addListener(_handleExternalTextChanged);
      _controller.setTextWithoutReplacements(widget.controller?.text ?? '');
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalTextChanged);
    _controller.dispose();
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  _ChipInputEditingController _createController(List<String> values) {
    return _ChipInputEditingController(
      values: values,
      chipBuilder: _buildChip,
      text: widget.controller?.text ?? '',
    );
  }

  void _handleExternalTextChanged() {
    if (_syncingExternalController) {
      return;
    }
    _controller.setTextWithoutReplacements(widget.controller?.text ?? '');
  }

  void _handleTextChanged(String _) {
    _syncExternalText();
    _handleChipDeletionFromKeyboard();
    final inputText = _controller.textWithoutReplacements;
    if (!inputText.contains(_separatorPattern)) {
      return;
    }

    final keepTrailingText = !_endsWithSeparator(inputText);
    final parts = inputText.split(_separatorPattern);
    final chipParts = keepTrailingText ? parts.take(parts.length - 1) : parts;
    final trailingText = keepTrailingText ? parts.last : '';

    _addValues(chipParts);
    _setInputText(trailingText);
  }

  void _handleSubmitted(String value) {
    if (!widget.createChipOnSubmit) {
      return;
    }
    _addValues([_controller.textWithoutReplacements]);
    _setInputText('');
  }

  void _addValues(Iterable<String> rawValues) {
    final nextValues = [...widget.values];
    var changed = false;

    for (final rawValue in rawValues) {
      final value = _normalize(rawValue);
      if (value.isEmpty) {
        continue;
      }
      if (!widget.allowDuplicates && nextValues.contains(value)) {
        continue;
      }
      nextValues.add(value);
      changed = true;
    }

    if (changed) {
      widget.onChanged(nextValues);
    }
  }

  void _removeValue(String value) {
    widget.onChipDeleted?.call(value);
    widget.onChanged(widget.values.where((item) => item != value).toList());
  }

  void _handleChipDeletionFromKeyboard() {
    final replacementCount = _controller.replacementCount;
    if (replacementCount >= widget.values.length) {
      return;
    }

    final nextValues = widget.values.take(replacementCount).toList();
    for (final value in widget.values.skip(replacementCount)) {
      widget.onChipDeleted?.call(value);
    }
    widget.onChanged(nextValues);
  }

  String _normalize(String value) {
    final normalized = widget.normalizer?.call(value) ?? value.trim();
    return normalized.trim();
  }

  bool _endsWithSeparator(String value) {
    final separatorPattern = _separatorPattern;
    if (separatorPattern is String) {
      return value.endsWith(separatorPattern);
    }
    return separatorPattern
        .allMatches(value)
        .any((match) => match.end == value.length);
  }

  void _setInputText(String value) {
    _controller.setTextWithoutReplacements(value);
    _syncExternalText();
  }

  void _syncExternalText() {
    final externalController = widget.controller;
    if (externalController == null) {
      return;
    }

    final text = _controller.textWithoutReplacements;
    if (externalController.text == text) {
      return;
    }

    _syncingExternalController = true;
    externalController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _syncingExternalController = false;
  }

  Widget _buildChip(BuildContext context, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 6.w, bottom: 3.h),
      child: InputChip(
        label: Text(value),
        onPressed: widget.enabled && widget.onChipPressed != null
            ? () => widget.onChipPressed!(value)
            : null,
        onDeleted: widget.enabled ? () => _removeValue(value) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final textFieldStyle = appTextFieldStyle.resolve(
      tokens,
      widget.textFieldVariants,
    );
    final chipTheme = appChipStyle.resolve(tokens, [widget.chipTone]);
    _controller.updateValues(widget.values);

    return ChipTheme(
      data: chipTheme,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        onChanged: _handleTextChanged,
        onSubmitted: _handleSubmitted,
        minLines: 1,
        maxLines: null,
        textInputAction: TextInputAction.done,
        cursorColor: textFieldStyle.cursorColor,
        style: textFieldStyle.textStyle,
        decoration: InputDecoration(
          hintText: widget.placeholder,
        ).applyDefaults(textFieldStyle.decorationTheme),
      ),
    );
  }
}

class _ChipInputEditingController extends TextEditingController {
  _ChipInputEditingController({
    required List<String> values,
    required this.chipBuilder,
    String text = '',
  }) : values = [...values],
       super(text: _replacementChar * values.length + text);

  static const int kObjectReplacementChar = 0xFFFE;
  static final String _replacementChar = String.fromCharCode(
    kObjectReplacementChar,
  );

  List<String> values;
  final Widget Function(BuildContext context, String value) chipBuilder;

  int get replacementCount {
    return text.codeUnits
        .where((unit) => unit == kObjectReplacementChar)
        .length;
  }

  String get textWithoutReplacements {
    return text.replaceAll(_replacementChar, '');
  }

  void updateValues(List<String> nextValues) {
    if (_listEquals(values, nextValues)) {
      return;
    }

    final inputText = textWithoutReplacements;
    values = [...nextValues];
    value = TextEditingValue(
      text: _replacementChar * values.length + inputText,
      selection: TextSelection.collapsed(
        offset: values.length + inputText.length,
      ),
    );
  }

  void setTextWithoutReplacements(String inputText) {
    value = TextEditingValue(
      text: _replacementChar * values.length + inputText,
      selection: TextSelection.collapsed(
        offset: values.length + inputText.length,
      ),
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      style: style,
      children: [
        for (final value in values)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: chipBuilder(context, value),
          ),
        if (textWithoutReplacements.isNotEmpty)
          TextSpan(text: textWithoutReplacements),
      ],
    );
  }

  static bool _listEquals(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var index = 0; index < left.length; index += 1) {
      if (left[index] != right[index]) {
        return false;
      }
    }
    return true;
  }
}
