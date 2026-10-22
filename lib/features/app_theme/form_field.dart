import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart' show TextSize, textStyle, TextColor;
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:theme_variants/theme_variants.dart';

typedef FormFieldBuilder<T> =
    Widget Function(BuildContext context, material.FormFieldState<T> field);

// ToDo: Because of the new changes, I need to apply this
// _formKey.currentState!.validate()
class FormField<T> extends StatelessWidget {
  const FormField({
    super.key,
    required this.value,
    required this.builder,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.enabled = true,
  });

  final T value;
  final FormFieldBuilder<T> builder;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return material.FormField<T>(
      initialValue: value,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      builder: (field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (field.errorText case final error?) ...[
              Text(
                key: ValueKey(error),
                error,
                style: textStyle.resolve(tokens, const [
                  TextSize.labelSmall,
                  TextColor.error,
                ]),
              ).animate().shakeX(
                duration: 350.ms,
                curve: Curves.easeOutCubic,
                amount: 6,
              ),
              SizedBox(height: tokens.spaceLayoutGapXsm),
            ],
            builder(context, field),
          ],
        );
      },
    );
  }
}
