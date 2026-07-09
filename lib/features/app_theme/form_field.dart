import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide FormField;
import 'package:theme_variants/theme_variants.dart';

typedef FormFieldBuilder<T> =
    Widget Function(BuildContext context, material.FormFieldState<T> field);

/// A form field that applies BooMondai's error presentation to any input.
///
/// When [listenable] is provided, [valueReader] must return its current value.
/// This keeps validation synchronized with programmatic changes as well as
/// direct user input.
class FormField<T> extends StatefulWidget {
  const FormField({
    super.key,
    required this.value,
    required this.builder,
    this.listenable,
    this.valueReader,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.enabled = true,
  }) : assert(
         listenable == null || valueReader != null,
         'valueReader is required when listenable is provided.',
       );

  final T value;
  final FormFieldBuilder<T> builder;
  final Listenable? listenable;
  final T Function()? valueReader;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;

  @override
  State<FormField<T>> createState() => _FormFieldState<T>();
}

class _FormFieldState<T> extends State<FormField<T>> {
  final _fieldKey = GlobalKey<material.FormFieldState<T>>();

  T get _currentValue => widget.valueReader?.call() ?? widget.value;

  @override
  void initState() {
    super.initState();
    widget.listenable?.addListener(_synchronizeValue);
  }

  @override
  void didUpdateWidget(covariant FormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable?.removeListener(_synchronizeValue);
      widget.listenable?.addListener(_synchronizeValue);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _synchronizeValue();
    });
  }

  @override
  void dispose() {
    widget.listenable?.removeListener(_synchronizeValue);
    super.dispose();
  }

  void _synchronizeValue() => _setValue(_currentValue);

  void _setValue(T value) {
    final field = _fieldKey.currentState;
    if (field != null && field.value != value) {
      field.didChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return material.FormField<T>(
      key: _fieldKey,
      initialValue: _currentValue,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      builder: (field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.builder(context, field),
            if (field.errorText case final error?) ...[
              SizedBox(height: tokens.spaceLayoutGapXsm),
              Text(
                error,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
