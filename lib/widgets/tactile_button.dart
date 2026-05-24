import 'package:boo_mondai/variant_styles/tactile_button.variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';

class TactileButton extends HookWidget {
  const TactileButton({
    this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.tone = TactileTone.ghost,
    this.size = TactileSize.md,
    this.depth = TactileDepth.elevated,
    this.selected = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    super.key,
  });

  final Widget? child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final TactileTone tone;
  final TactileSize size;
  final TactileDepth depth;
  final bool selected;
  final MainAxisAlignment mainAxisAlignment;

  static TactileButton icon({
    VoidCallback? onPressed,
    IconData? icon,
    TactileTone tone = TactileTone.ghost,
    bool selected = false,
  }) {
    return TactileButton(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      tone: tone,
      size: TactileSize.icon,
      selected: selected,
    );
  }

  TactileState getState() {
    if (onPressed == null) {
      return TactileState.disabled;
    } else if (selected) {
      return TactileState.selected;
    } else {
      return TactileState.idle;
    }
  }

  TactileState getHoverState() {
    final currentState = getState();
    if (currentState == TactileState.disabled ||
        currentState == TactileState.selected) {
      return currentState;
    }
    return TactileState.hovered;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final state = useState(getState());
    useEffect(() {
      state.value = getState();
      return null;
    }, [onPressed, selected, tone]);
    final resolvedStyle = tactileButtonStyle.resolve(tokens, <Object>[
      tone,
      size,
      state.value,
      depth,
    ]);

    final padding = switch (size) {
      TactileSize.sm => const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      TactileSize.md => const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      TactileSize.lg => const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 18,
      ),
      TactileSize.icon => EdgeInsets.zero,
      TactileSize.fab => EdgeInsets.zero,
      TactileSize.extendedFab => const EdgeInsets.symmetric(horizontal: 24),
    };

    final minSize = switch (size) {
      TactileSize.icon => const Size.square(48),
      TactileSize.fab => const Size.square(64),
      TactileSize.extendedFab => const Size(0, 64),
      _ => Size.zero,
    };

    final pressedOffset = switch (depth) {
      TactileDepth.mechanical => 8.0,
      TactileDepth.elevated => 4.0,
      TactileDepth.flat => 0.0,
    };

    final contentStyle = resolvedStyle.copyWith(
      transform: Matrix4.translationValues(
        0,
        depth != TactileDepth.flat &&
                state.value == TactileState.pressed &&
                !(state.value == TactileState.disabled)
            ? pressedOffset
            : 0,
        0,
      ),
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      padding: padding,
      contentStyle: resolvedStyle.contentStyle,
    );

    final content = Surface(
      style: contentStyle,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      child: Row(
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
    );

    final paintedContent = tone == TactileTone.dashed
        ? SizedBox(
            width: double.infinity,
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(
                color: state.value == TactileState.hovered
                    ? tokens.primary
                    : tokens.borderNeutralSubtle,
                radius: tokens.radius2xl,
              ),
              child: content,
            ),
          )
        : content;

    return MouseRegion(
      cursor: state.value == TactileState.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: state.value == TactileState.disabled
          ? null
          : (_) => state.value = getHoverState(),
      onExit: state.value == TactileState.disabled
          ? null
          : (_) => state.value = getState(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: state.value == TactileState.disabled
            ? null
            : (_) => state.value = TactileState.pressed,
        onTapCancel: state.value == TactileState.disabled
            ? null
            : () => state.value = getState(),
        onTapUp: state.value == TactileState.disabled
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
