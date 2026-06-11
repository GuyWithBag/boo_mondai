import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonSize,
        ButtonDepth,
        ButtonTone,
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
    this.tone = ButtonTone.ghost,
    this.size = ButtonSize.md,
    this.depth = ButtonDepth.elevated,
    this.selected = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.axis = Axis.horizontal,
    super.key,
  });

  final Widget? child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final ButtonTone tone;
  final ButtonSize size;
  final ButtonDepth depth;
  final bool selected;
  final MainAxisAlignment mainAxisAlignment;
  final Axis axis;

  static Button icon({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonTone tone = ButtonTone.ghost,
    bool selected = false,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      tone: tone,
      size: ButtonSize.icon,
      selected: selected,
    );
  }

  static Button iconWithLabel({
    VoidCallback? onPressed,
    IconData? icon,
    required String label,
    ButtonTone tone = ButtonTone.ghost,
    bool selected = false,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      tone: tone,
      size: ButtonSize.iconWithLabel,
      selected: selected,
      axis: Axis.vertical,
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
    }, [onPressed, selected, tone]);
    final resolvedStyle = buttonStyle.resolve(tokens, <Object>[
      tone,
      size,
      state.value,
      depth,
    ]);

    final pressedOffset = switch (depth) {
      ButtonDepth.mechanical => 8.0,
      ButtonDepth.elevated => 4.0,
      ButtonDepth.flat => 0.0,
    };

    final contentStyle = resolvedStyle.copyWith(
      transform: Matrix4.translationValues(
        0,
        depth != ButtonDepth.flat &&
                state.value == ButtonState.pressed &&
                !(state.value == ButtonState.disabled)
            ? pressedOffset
            : 0,
        0,
      ),
      contentStyle: resolvedStyle.contentStyle,
    );

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
      style: contentStyle,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      child: contentChild,
    );

    final paintedContent = tone == ButtonTone.dashed
        ? SizedBox(
            width: double.infinity,
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(
                color: state.value == ButtonState.hovered
                    ? tokens.primary
                    : tokens.borderNeutralSubtle,
                radius: tokens.radiusSurfaceSm,
              ),
              child: content,
            ),
          )
        : content;

    return MouseRegion(
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
