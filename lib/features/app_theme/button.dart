import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonState,
        AppTokens,
        buttonStyle,
        ButtonSize,
        ButtonPadding,
        ButtonVariant,
        ButtonColor;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    this.style,
    bool dashed = false,
    super.key,
  }) : _isDashed = dashed;

  final Widget? child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final MainAxisAlignment mainAxisAlignment;
  final Axis axis;
  final SurfaceStyle? style;
  final bool _isDashed;

  static Button icon({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
    required AppTokens tokens,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      dashed: variant == ButtonVariant.dashed,
      style: buttonStyle.resolve(tokens, [
        color,
        ButtonSize.icon,
        ButtonPadding.none,
        variant,
      ]),
    );
  }

  static Button dashed({
    required AppTokens tokens,
    VoidCallback? onPressed,
    Widget? child,
    Widget? leading,
    Widget? trailing,
    bool selected = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    Axis axis = Axis.horizontal,
  }) {
    return Button(
      onPressed: onPressed,
      leading: leading,
      trailing: trailing,
      selected: selected,
      mainAxisAlignment: mainAxisAlignment,
      axis: axis,
      style: buttonStyle.resolve(tokens, const [
        ButtonVariant.dashed,
        ButtonColor.dashed,
      ]),
      dashed: true,
      child: child,
    );
  }

  static Button iconOnly({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.muted,
    ButtonVariant variant = ButtonVariant.textShadowed,
    bool selected = false,
    required AppTokens tokens,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      dashed: variant == ButtonVariant.dashed,
      style: buttonStyle.resolve(tokens, [
        color,
        ButtonSize.largeIcon,
        ButtonPadding.none,
        variant,
      ]),
    );
  }

  static Button iconOnlySmall({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.muted,
    ButtonVariant variant = ButtonVariant.textShadowed,
    bool selected = false,
    required AppTokens tokens,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      dashed: variant == ButtonVariant.dashed,
      style: buttonStyle.resolve(tokens, [
        color,
        ButtonSize.smallIcon,
        ButtonPadding.none,
        variant,
      ]),
    );
  }

  static Button iconWithLabel({
    VoidCallback? onPressed,
    IconData? icon,
    required String label,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
    required AppTokens tokens,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      axis: Axis.vertical,
      dashed: variant == ButtonVariant.dashed,
      style: buttonStyle.resolve(tokens, [
        color,
        ButtonSize.iconWithLabel,
        ButtonPadding.iconWithLabel,
        variant,
      ]),
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

    final effectiveStyle = style ?? buttonStyle.resolve(tokens);
    var resolvedStyle = effectiveStyle;

    if (state.value == ButtonState.selected) {
      resolvedStyle = resolvedStyle.copyWith(
        decoration: resolvedStyle.decoration.copyWith(
          color: tokens.colorPrimarySoft,
          border: Border.all(
            color: tokens.colorPrimaryBright,
            width: tokens.borderWidthDefault.w,
          ),
          boxShadow: [
            BoxShadow(
              color: tokens.colorPrimaryBright,
              offset: Offset(0, tokens.buttonShadowOffset.h),
              blurRadius: 0,
            ),
          ],
        ),
        contentStyle: resolvedStyle.contentStyle.copyWith(
          textStyle: resolvedStyle.textStyle.copyWith(
            color: tokens.colorPrimary,
          ),
          iconTheme: resolvedStyle.iconTheme.copyWith(
            color: tokens.colorPrimary,
          ),
        ),
      );
    } else if (state.value == ButtonState.disabled) {
      resolvedStyle = resolvedStyle.copyWith(opacity: 0.5);
    } else if (state.value == ButtonState.pressed) {
      resolvedStyle = resolvedStyle.copyWith(
        transform: Matrix4.translationValues(0, 0, 0),
      );
    }

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

    final paintedContent = _isDashed
        ? SizedBox(
            width: double.infinity,
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(
                color: state.value == ButtonState.hovered
                    ? tokens.colorPrimary
                    : tokens.colorBorderNeutralSubtle,
                radius: tokens.radiusSurfaceXsm.r,
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
      padding: resolvedStyle.transform != null
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
