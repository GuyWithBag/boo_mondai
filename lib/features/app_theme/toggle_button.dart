import 'package:boo_mondai/lib.barrel.dart'
    show ButtonColor, ButtonVariant, ButtonPadding, Button;
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.trueIcon = Icons.thumb_up_alt_outlined,
    this.falseIcon = Icons.thumb_down_alt_outlined,
    this.trueColor = ButtonColor.easy,
    this.falseColor = ButtonColor.hard,
    this.trueTooltip,
    this.falseTooltip,
    this.variant = ButtonVariant.elevated,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData trueIcon;
  final IconData falseIcon;
  final ButtonColor trueColor;
  final ButtonColor falseColor;
  final String? trueTooltip;
  final String? falseTooltip;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final icon = value ? trueIcon : falseIcon;
    final color = value ? trueColor : falseColor;
    final tooltip = value ? trueTooltip : falseTooltip;

    final button = Button(
      variants: [color, variant, ButtonPadding.none],
      onPressed: onChanged == null ? null : () => onChanged!(!value),
      leading: Icon(icon),
      selected: value,
    );

    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}
