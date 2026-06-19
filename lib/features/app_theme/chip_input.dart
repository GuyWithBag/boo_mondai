import 'package:boo_mondai/lib.barrel.dart'
    show
        TextFieldFrame,
        TextFieldTone,
        AppTokens,
        ChipTone,
        TextFieldSize,
        chipStyle,
        appTextFieldStyle,
        useChipInputController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

typedef ChipInputNormalizer = String Function(String value);

class ChipInput extends HookWidget {
  const ChipInput({
    required this.values,
    required this.onChanged,
    this.onChipPressed,
    this.onChipDeleted,
    this.placeholder,
    this.isEnabled = true,
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
  final bool isEnabled;
  final Pattern? separatorPattern;
  final bool allowDuplicates;
  final bool createChipOnSubmit;
  final ChipTone chipTone;
  final Iterable<Object> textFieldVariants;
  final ChipInputNormalizer? normalizer;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final textFieldStyle = appTextFieldStyle.resolve(tokens, textFieldVariants);
    final chipTheme = chipStyle.resolve(tokens, [chipTone]);
    Widget readOnlyChipBuilder(String value) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 6.w, bottom: 3.h),
        child: InputChip(label: Text(value)),
      );
    }

    void removeValue(String value) {
      onChipDeleted?.call(value);
      onChanged(values.where((item) => item != value).toList());
    }

    Widget buildChip(BuildContext context, String value) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 6.w, bottom: 3.h),
        child: InputChip(
          label: Text(value),
          onPressed: isEnabled && onChipPressed != null
              ? () => onChipPressed!(value)
              : null,
          onDeleted: isEnabled ? () => removeValue(value) : null,
        ),
      );
    }

    final chipController = useChipInputController(
      values: values,
      externalController: controller,
      chipBuilder: buildChip,
    );
    final internalFocusNode = useFocusNode();
    final effectiveFocusNode = focusNode ?? internalFocusNode;
    final syncingExternalController = useRef(false);

    chipController.setChipBuilder(buildChip);
    chipController.updateValues(values);

    useEffect(() {
      final externalController = controller;
      if (externalController == null) {
        return null;
      }

      void handleExternalTextChanged() {
        if (syncingExternalController.value) {
          return;
        }
        chipController.setTextWithoutReplacements(externalController.text);
      }

      externalController.addListener(handleExternalTextChanged);
      chipController.setTextWithoutReplacements(externalController.text);

      return () => externalController.removeListener(handleExternalTextChanged);
    }, [chipController, controller]);

    void syncExternalText() {
      final externalController = controller;
      if (externalController == null) {
        return;
      }

      final text = chipController.textWithoutReplacements;
      if (externalController.text == text) {
        return;
      }

      syncingExternalController.value = true;
      externalController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      syncingExternalController.value = false;
    }

    void handleChipDeletionFromKeyboard() {
      final replacementCount = chipController.replacementCount;
      if (replacementCount >= values.length) {
        return;
      }

      final nextValues = values.take(replacementCount).toList();
      for (final value in values.skip(replacementCount)) {
        onChipDeleted?.call(value);
      }
      onChanged(nextValues);
    }

    String normalize(String value) {
      final normalized = normalizer?.call(value) ?? value.trim();
      return normalized.trim();
    }

    bool endsWithSeparator(String value) {
      final pattern = separatorPattern ?? RegExp(r'[,;\n]');
      if (pattern is String) {
        return value.endsWith(pattern);
      }
      return pattern
          .allMatches(value)
          .any((match) => match.end == value.length);
    }

    void addValues(Iterable<String> rawValues) {
      final nextValues = [...values];
      var changed = false;

      for (final rawValue in rawValues) {
        final value = normalize(rawValue);
        if (value.isEmpty) {
          continue;
        }
        if (!allowDuplicates && nextValues.contains(value)) {
          continue;
        }
        nextValues.add(value);
        changed = true;
      }

      if (changed) {
        onChanged(nextValues);
      }
    }

    void setInputText(String value) {
      chipController.setTextWithoutReplacements(value);
      syncExternalText();
    }

    void handleTextChanged(String _) {
      syncExternalText();
      handleChipDeletionFromKeyboard();
      final inputText = chipController.textWithoutReplacements;
      final pattern = separatorPattern ?? RegExp(r'[,;\n]');
      if (!inputText.contains(pattern)) {
        return;
      }

      final keepTrailingText = !endsWithSeparator(inputText);
      final parts = inputText.split(pattern);
      final chipParts = keepTrailingText ? parts.take(parts.length - 1) : parts;
      final trailingText = keepTrailingText ? parts.last : '';

      addValues(chipParts);
      setInputText(trailingText);
    }

    void handleSubmitted(String value) {
      if (!createChipOnSubmit) {
        return;
      }
      addValues([chipController.textWithoutReplacements]);
      setInputText('');
    }

    return ChipTheme(
      data: chipTheme,
      child: isEnabled
          ? TextField(
              controller: chipController,
              focusNode: effectiveFocusNode,
              enabled: true,
              onChanged: handleTextChanged,
              onSubmitted: handleSubmitted,
              minLines: 1,
              maxLines: null,
              textInputAction: TextInputAction.done,
              cursorColor: textFieldStyle.cursorColor,
              style: textFieldStyle.textStyle,
              decoration: InputDecoration(
                hintText: placeholder,
              ).applyDefaults(textFieldStyle.decorationTheme),
            )
          : Wrap(
              spacing: 0,
              runSpacing: 0,
              children: [
                if (values.isEmpty)
                  Text(placeholder ?? '', style: textFieldStyle.textStyle)
                else
                  for (final value in values) readOnlyChipBuilder(value),
              ],
            ),
    );
  }
}
