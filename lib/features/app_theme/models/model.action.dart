import 'dart:ui' show VoidCallback;

import 'package:boo_mondai/features/app_theme/button.variant.dart'
    show ButtonColor;

class ModalAction<T> {
  const ModalAction({
    required this.value,
    required this.label,
    this.color = ButtonColor.baseline,
    this.onPressed,
    this.valueBuilder,
    this.dismissesModal = true,
  });

  final T value;
  final String label;
  final ButtonColor color;
  final VoidCallback? onPressed;
  final T Function()? valueBuilder;
  final bool dismissesModal;
}
