import 'package:boo_mondai/core/theme/app_media_pack.model.dart';
import 'package:boo_mondai/features/ui_sounds/ui_sounds.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonState,
        AppTokens,
        buttonStyle,
        ButtonSize,
        ButtonPadding,
        ButtonVariant,
        ButtonColor,
        Elevated,
        MediaSelector,
        ScaleHelper,
        Setting,
        SettingsController,
        SettingsService;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_variants/media_variants.dart';
import 'package:provider/provider.dart';
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
    this.variants = const [],
    this.contentScale = 1,
    this.buttonDownSound,
    this.buttonUpSound,
    this.buttonDownSoundEnabledSetting,
    this.buttonUpSoundEnabledSetting,
    bool dashed = false,
    super.key,
    this.elevated = true,
  }) : _isDashed = dashed;

  final Widget? child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final MainAxisAlignment mainAxisAlignment;
  final Axis axis;
  final List<Object> variants;
  final double contentScale;
  final bool elevated;
  final MediaSelector<AppMediaPack>? buttonDownSound;
  final MediaSelector<AppMediaPack>? buttonUpSound;
  final Setting<bool>? buttonDownSoundEnabledSetting;
  final Setting<bool>? buttonUpSoundEnabledSetting;
  final bool _isDashed;

  static Button icon({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
    double contentScale = 1,
    required AppTokens tokens,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      contentScale: contentScale,
      dashed: variant == ButtonVariant.dashed,
      variants: [color, ButtonSize.icon, ButtonPadding.none, variant],
    );
  }

  static Button iconSmall({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
    double contentScale = 1,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      contentScale: contentScale,
      dashed: variant == ButtonVariant.dashed,
      variants: [color, ButtonSize.iconSmall, ButtonPadding.none, variant],
    );
  }

  static Button dashed({
    required AppTokens tokens,
    VoidCallback? onPressed,
    Widget? child,
    Widget? leading,
    Widget? trailing,
    bool selected = false,
    double contentScale = 1,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    Axis axis = Axis.horizontal,
  }) {
    return Button(
      onPressed: onPressed,
      leading: leading,
      trailing: trailing,
      selected: selected,
      contentScale: contentScale,
      mainAxisAlignment: mainAxisAlignment,
      axis: axis,
      variants: const [ButtonVariant.dashed, ButtonColor.dashed],
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
    double contentScale = 1,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      contentScale: contentScale,
      dashed: variant == ButtonVariant.dashed,
      variants: [color, ButtonSize.iconOnly, ButtonPadding.none, variant],
    );
  }

  static Button iconOnlySmall({
    VoidCallback? onPressed,
    IconData? icon,
    ButtonColor color = ButtonColor.muted,
    ButtonVariant variant = ButtonVariant.textShadowed,
    bool selected = false,
    double contentScale = 1,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      contentScale: contentScale,
      dashed: variant == ButtonVariant.dashed,
      variants: [color, ButtonSize.iconOnlySmall, ButtonPadding.none, variant],
    );
  }

  static Button iconWithLabel({
    VoidCallback? onPressed,
    IconData? icon,
    required String label,
    ButtonColor color = ButtonColor.baseline,
    ButtonVariant variant = ButtonVariant.elevated,
    bool selected = false,
    bool elevated = false,
    double contentScale = 1,
  }) {
    return Button(
      onPressed: onPressed,
      leading: icon == null ? null : Icon(icon),
      selected: selected,
      axis: Axis.vertical,
      elevated: elevated,
      contentScale: contentScale,
      dashed: variant == ButtonVariant.dashed,
      variants: [
        color,
        ButtonSize.iconWithLabel,
        ButtonPadding.iconWithLabel,
        variant,
      ],
      child: Text(
        label,
        maxLines: 1,
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
    final mediaPackController = context.mediaPackController<AppMediaPack>();
    final settingsController = context.read<SettingsController>();
    final state = useState(getState());
    useEffect(() {
      state.value = getState();
      return null;
    }, [onPressed, selected]);

    final effectiveStyle = buttonStyle.resolve(tokens, [
      ...variants,
      state.value,
    ]);
    var resolvedStyle = _scaleSurfaceStyle(effectiveStyle, contentScale);
    final hasSelectedElevatedTextVariant = variants.contains(
      ButtonVariant.selectedElevatedText,
    );

    final contentChild = switch (axis) {
      Axis.horizontal => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (leading != null) ...[
            leading!,
            if (child != null)
              SizedBox(width: ScaleHelper.getScaledValue(10, contentScale)),
          ],
          if (child != null) Flexible(child: child!),
          if (trailing != null) ...[
            if (child != null || leading != null)
              SizedBox(width: ScaleHelper.getScaledValue(10, contentScale)),
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
            if (leading != null)
              SizedBox(height: ScaleHelper.getScaledValue(6, contentScale)),
            child!,
          ],
          if (trailing != null) ...[
            if (child != null || leading != null)
              SizedBox(height: ScaleHelper.getScaledValue(6, contentScale)),
            trailing!,
          ],
        ],
      ),
    };

    final content = Elevated(
      enabled:
          elevated ||
          (hasSelectedElevatedTextVariant &&
              state.value == ButtonState.selected),
      contentScale: contentScale,
      child: Surface(
        style: resolvedStyle,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: contentChild,
      ),
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
            : (_) async {
                state.value = selected
                    ? ButtonState.selectedPressed
                    : ButtonState.pressed;

                await UiSoundsService.playIfEnabled(
                  mediaPackController.resolve(
                    buttonDownSound ?? (media) => media.buttonDownSound,
                  ),
                  settingsController: settingsController,
                  enabledSetting:
                      buttonDownSoundEnabledSetting ??
                      SettingsService.buttonDownSoundEnabled,
                  volume: 2,
                );
              },
        onTapCancel: state.value == ButtonState.disabled
            ? null
            : () => state.value = getState(),
        onTapUp: state.value == ButtonState.disabled
            ? null
            : (_) async {
                onPressed?.call();
                state.value = getHoverState();
                await UiSoundsService.playIfEnabled(
                  mediaPackController.resolve(
                    buttonUpSound ?? (media) => media.buttonUpSound,
                  ),
                  settingsController: settingsController,
                  enabledSetting:
                      buttonUpSoundEnabledSetting ??
                      SettingsService.buttonUpSoundEnabled,
                  volume: 2,
                );
              },
        child: paintedContent,
      ),
    );

    return Padding(
      padding: resolvedStyle.transform != null
          ? EdgeInsets.only(
              top: ScaleHelper.getScaledValue(
                tokens.buttonShadowOffset,
                contentScale,
              ),
            )
          : EdgeInsets.zero,
      child: button,
    );
  }

  SurfaceStyle _scaleSurfaceStyle(SurfaceStyle style, double scale) {
    if (scale == 1) return style;

    return style.copyWith(
      decoration: _scaleBoxDecoration(style.decoration, scale),
      foregroundDecoration: style.foregroundDecoration == null
          ? null
          : _scaleBoxDecoration(style.foregroundDecoration!, scale),
      padding: _scaleEdgeInsetsGeometry(style.padding, scale),
      margin: _scaleEdgeInsetsGeometry(style.margin, scale),
      width: style.width == null
          ? null
          : ScaleHelper.getScaledValue(style.width!, scale),
      height: style.height == null
          ? null
          : ScaleHelper.getScaledValue(style.height!, scale),
      constraints: _scaleBoxConstraints(style.constraints, scale),
      transform: _scaleMatrixTranslation(style.transform, scale),
      contentStyle: style.contentStyle.copyWith(
        textStyle: ScaleHelper.getTextStyleWithScaledFontSize(
          style.contentStyle.textStyle,
          scale,
        ),
        iconTheme: style.contentStyle.iconTheme.copyWith(
          size: style.contentStyle.iconTheme.size == null
              ? null
              : ScaleHelper.getScaledValue(
                  style.contentStyle.iconTheme.size!,
                  scale,
                ),
        ),
      ),
    );
  }

  BoxDecoration _scaleBoxDecoration(BoxDecoration decoration, double scale) {
    return decoration.copyWith(
      borderRadius: decoration.borderRadius == null
          ? null
          : decoration.borderRadius! * scale,
      border: _scaleBoxBorder(decoration.border, scale),
      boxShadow: decoration.boxShadow
          ?.map(
            (shadow) => BoxShadow(
              color: shadow.color,
              offset: Offset(
                ScaleHelper.getScaledValue(shadow.offset.dx, scale),
                ScaleHelper.getScaledValue(shadow.offset.dy, scale),
              ),
              blurRadius: ScaleHelper.getScaledValue(shadow.blurRadius, scale),
              spreadRadius: ScaleHelper.getScaledValue(
                shadow.spreadRadius,
                scale,
              ),
              blurStyle: shadow.blurStyle,
            ),
          )
          .toList(),
    );
  }

  BoxBorder? _scaleBoxBorder(BoxBorder? border, double scale) {
    if (border is! Border) return border;

    return Border(
      top: _scaleBorderSide(border.top, scale),
      right: _scaleBorderSide(border.right, scale),
      bottom: _scaleBorderSide(border.bottom, scale),
      left: _scaleBorderSide(border.left, scale),
    );
  }

  BorderSide _scaleBorderSide(BorderSide side, double scale) {
    if (side == BorderSide.none) return side;

    return side.copyWith(width: ScaleHelper.getScaledValue(side.width, scale));
  }

  Matrix4? _scaleMatrixTranslation(Matrix4? transform, double scale) {
    if (transform == null) return null;

    final scaled = Matrix4.copy(transform);
    scaled.storage[12] = ScaleHelper.getScaledValue(scaled.storage[12], scale);
    scaled.storage[13] = ScaleHelper.getScaledValue(scaled.storage[13], scale);
    scaled.storage[14] = ScaleHelper.getScaledValue(scaled.storage[14], scale);
    return scaled;
  }

  EdgeInsetsGeometry? _scaleEdgeInsetsGeometry(
    EdgeInsetsGeometry? insets,
    double scale,
  ) {
    if (insets == null) return null;
    if (insets is EdgeInsets) {
      return ScaleHelper.getScaledEdgeInsets(insets, scale);
    }
    return insets;
  }

  BoxConstraints? _scaleBoxConstraints(
    BoxConstraints? constraints,
    double scale,
  ) {
    if (constraints == null) return null;

    return BoxConstraints(
      minWidth: ScaleHelper.getScaledValue(constraints.minWidth, scale),
      maxWidth: constraints.maxWidth.isFinite
          ? ScaleHelper.getScaledValue(constraints.maxWidth, scale)
          : constraints.maxWidth,
      minHeight: ScaleHelper.getScaledValue(constraints.minHeight, scale),
      maxHeight: constraints.maxHeight.isFinite
          ? ScaleHelper.getScaledValue(constraints.maxHeight, scale)
          : constraints.maxHeight,
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
