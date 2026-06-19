import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonSize,
        ButtonVariant,
        ButtonColor,
        ButtonState,
        AppTokens,
        buttonStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class Button extends HookWidget {
  const Button({
    this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.selected = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.axis = Axis.horizontal,
    this.variants = const [
      ButtonColor.baseline,
      ButtonSize.md,
      ButtonVariant.elevated,
    ],
    super.key,
  });

  final Widget? child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final MainAxisAlignment mainAxisAlignment;
  final Axis axis;
  final List<Object> variants;

  static Button icon({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      variants: [color, ButtonSize.icon, variant],
    );
  }

  static Button iconSmall({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.muted,
    ButtonVariant variant = ButtonVariant.text,
    bool selected = false,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      variants: [color, ButtonSize.smallIcon, variant],
    );
  }

  static Button iconWithLabel({
    VoidCallback? onPressed,
    IconData? icon,
    required String label,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      axis: Axis.vertical,
      variants: [color, ButtonSize.iconWithLabel, variant],
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  ButtonState getState() {
    if (onPressed == null) {
      return ButtonState.disabled;
    } else if (selected) {
      return ButtonState.selected;
    } else {
      return ButtonState.idle;
    }
  }

  ButtonState getHoverState() {
    final currentState = getState();
    if (currentState == ButtonState.disabled ||
        currentState == ButtonState.selected) {
      return currentState;
    }
    return ButtonState.hovered;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final state = useState(getState());
    useEffect(() {
      state.value = getState();
      return null;
    }, [onPressed, selected]);

    final resolvedStyle = buttonStyle.resolve(tokens, [
      ...variants,
      state.value,
    ]);

    final contentChild = switch (axis) {
      Axis.horizontal => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (leading != null) ...[
            leading!,
            if (child != null) const SizedBox(width: 10),
          ],
          if (child != null) Flexible(child: child!),
          if (trailing != null) ...[
            if (child != null || leading != null) const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
      Axis.vertical => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          ...leading != null ? [leading!] : const [],
          if (child != null) ...[
            if (leading != null) const SizedBox(height: 6),
            child!,
          ],
          if (trailing != null) ...[
            if (child != null || leading != null) const SizedBox(height: 6),
            trailing!,
          ],
        ],
      ),
    };

    final content = Surface(
      style: resolvedStyle,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      child: contentChild,
    );

    final paintedContent = variants.contains(ButtonVariant.dashed)
        ? SizedBox(
            width: double.infinity,
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(
                color: state.value == ButtonState.hovered
                    ? tokens.colorPrimary
                    : tokens.colorBorderNeutralSubtle,
                radius: tokens.radiusSurfaceXsm,
              ),
              child: content,
            ),
          )
        : content;

    final button = MouseRegion(
      cursor: state.value == ButtonState.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: state.value == ButtonState.disabled
          ? null
          : (_) => state.value = getHoverState(),
      onExit: state.value == ButtonState.disabled
          ? null
          : (_) => state.value = getState(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: state.value == ButtonState.disabled
            ? null
            : (_) => state.value = ButtonState.pressed,
        onTapCancel: state.value == ButtonState.disabled
            ? null
            : () => state.value = getState(),
        onTapUp: state.value == ButtonState.disabled
            ? null
            : (_) {
                onPressed?.call();
                state.value = getHoverState();
              },
        child: paintedContent,
      ),
    );

    return Padding(
      padding: variants.contains(ButtonVariant.elevated)
          ? EdgeInsets.only(top: tokens.buttonShadowOffset)
          : EdgeInsets.zero,
      child: button,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  static const _strokeWidth = 2.0;
  static const _dashLength = 8.0;
  static const _gapLength = 5.0;

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(_strokeWidth / 2),
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + _dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += _dashLength + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return color != oldDelegate.color || radius != oldDelegate.radius;
  }
}
