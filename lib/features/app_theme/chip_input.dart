import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTextFieldFrame,
        AppTextFieldTone,
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
    this.chipTone = ChipTone.ghost,
    this.textFieldVariants = const [
      TextFieldSize.normal,
      AppTextFieldFrame.outline,
      AppTextFieldTone.neutral,
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
  final ChipTone chipTone;
  final Iterable<Object> textFieldVariants;
  final ChipInputNormalizer? normalizer;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<ChipInput> createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _ownsController;
  late bool _ownsFocusNode;

  Pattern get _separatorPattern => widget.separatorPattern ?? RegExp(r'[,;\n]');

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant ChipInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();
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
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged(String value) {
    if (!value.contains(_separatorPattern)) {
      return;
    }

    final keepTrailingText = !_endsWithSeparator(value);
    final parts = value.split(_separatorPattern);
    final chipParts = keepTrailingText ? parts.take(parts.length - 1) : parts;
    final trailingText = keepTrailingText ? parts.last : '';

    _addValues(chipParts);
    _setInputText(trailingText);
  }

  void _handleSubmitted(String value) {
    _addValues([value]);
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
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
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
    final shouldShowHint = widget.values.isEmpty && _controller.text.isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? _focusNode.requestFocus : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_focusNode, _controller]),
        builder: (context, child) {
          return InputDecorator(
            isFocused: _focusNode.hasFocus,
            isEmpty: shouldShowHint,
            decoration: InputDecoration(
              hintText: shouldShowHint ? widget.placeholder : null,
            ).applyDefaults(textFieldStyle.decorationTheme),
            child: child,
          );
        },
        child: ChipTheme(
          data: chipTheme,
          child: Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final value in widget.values)
                InputChip(
                  label: Text(value),
                  onPressed: widget.enabled && widget.onChipPressed != null
                      ? () => widget.onChipPressed!(value)
                      : null,
                  onDeleted: widget.enabled ? () => _removeValue(value) : null,
                ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 96.w, maxWidth: 240.w),
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
