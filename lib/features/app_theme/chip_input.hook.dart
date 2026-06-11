import 'package:flutter/material.dart'
    show
        TextSelection,
        TextEditingValue,
        BuildContext,
        Widget,
        TextEditingController,
        TextSpan,
        TextStyle,
        PlaceholderAlignment,
        WidgetSpan;
import 'package:flutter_hooks/flutter_hooks.dart' show useMemoized, useEffect;

ChipInputEditingController useChipInputController({
  required List<String> values,
  required Widget Function(BuildContext context, String value) chipBuilder,
  TextEditingController? externalController,
}) {
  final controller = useMemoized(
    () => ChipInputEditingController(
      values: values,
      chipBuilder: chipBuilder,
      text: externalController?.text ?? '',
    ),
    [externalController],
  );

  useEffect(() => controller.dispose, [controller]);

  return controller;
}

class ChipInputEditingController extends TextEditingController {
  ChipInputEditingController({
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
  Widget Function(BuildContext context, String value) chipBuilder;

  void setChipBuilder(
    Widget Function(BuildContext context, String value) value,
  ) {
    chipBuilder = value;
  }

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
