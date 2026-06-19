import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChipInput,
        SegmentOption,
        SegmentedControl,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        TextField,
        textFieldStyle,
        SearchFilter,
        SearchFilterDirective;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

typedef SearchFilterFieldBuilder<TFilter extends SearchFilter> =
    Widget Function(
      BuildContext context,
      TFilter filter,
      ValueChanged<TFilter>,
    );

final class SearchFilterModalField<TFilter extends SearchFilter> {
  const SearchFilterModalField({
    required this.directive,
    required this.label,
    required this.buildEditor,
  });

  final SearchFilterDirective directive;
  final String label;
  final SearchFilterFieldBuilder<TFilter> buildEditor;
}

class SearchFilterTextEditor extends HookWidget {
  const SearchFilterTextEditor({
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.keyboardType,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useTextEditingController(text: value);

    useEffect(() {
      if (controller.text == value) return null;
      controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
      return null;
    }, [value]);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      placeholder: placeholder,
      keyboardType: keyboardType,
      variants: const [
        TextFieldSize.normal,
        TextFieldFrame.outline,
        TextFieldTone.neutral,
      ],
      style: textFieldStyle.resolve(tokens, const [
        TextFieldSize.normal,
        TextFieldFrame.outline,
        TextFieldTone.neutral,
      ]).textStyle,
    );
  }
}

class SearchFilterChipEditor extends StatelessWidget {
  const SearchFilterChipEditor({
    required this.values,
    required this.onChanged,
    this.placeholder,
    super.key,
  });

  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return ChipInput(
      values: values,
      onChanged: onChanged,
      placeholder: placeholder,
      allowDuplicates: false,
    );
  }
}

class SearchFilterBoolEditor extends StatelessWidget {
  const SearchFilterBoolEditor({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool? value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<bool?>(
      value: value,
      onChanged: onChanged,
      options: const [
        SegmentOption<bool?>(value: null, label: 'Any'),
        SegmentOption<bool?>(value: true, label: 'Yes'),
        SegmentOption<bool?>(value: false, label: 'No'),
      ],
    );
  }
}

class SearchFilterEnumEditor<TEnum> extends StatelessWidget {
  const SearchFilterEnumEditor({
    required this.value,
    required this.onChanged,
    required this.options,
    super.key,
  });

  final TEnum value;
  final ValueChanged<TEnum> onChanged;
  final List<SegmentOption<TEnum>> options;

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<TEnum>(
      value: value,
      onChanged: onChanged,
      options: options,
    );
  }
}

class SearchFilterSliderEditor extends StatelessWidget {
  const SearchFilterSliderEditor({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    this.labelBuilder,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String Function(int value)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final label = labelBuilder?.call(value) ?? value.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: tokens.colorPrimary,
            thumbColor: tokens.colorPrimary,
          ),
          child: Slider(
            min: min,
            max: max,
            divisions: divisions,
            value: value.clamp(min.toInt(), max.toInt()).toDouble(),
            onChanged: (next) => onChanged(next.round()),
          ),
        ),
      ],
    );
  }
}
