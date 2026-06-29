import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, PhysicalCardController;
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

PhysicalCardController usePhysicalCardController(
  BuildContext context, {
  double? width,
  double aspectRatio = 5 / 7,
  double depth = 10,
  double pitch = 0,
  double yaw = 0,
  double roll = 0,
  double scale = 1.0,
  double perspective = 0,
  Offset position = Offset.zero,
  Duration animationDuration = const Duration(milliseconds: 260),
  Curve animationCurve = Curves.easeOutCubic,
}) {
  final resolvedWidth =
      width ?? context.themeTokens<AppTokens>().studyCardWidth;

  final controller = useMemoized(
    () => PhysicalCardController(
      context,
      width: resolvedWidth,
      aspectRatio: aspectRatio,
      depth: depth,
      pitch: pitch,
      yaw: yaw,
      roll: roll,
      scale: scale,
      perspective: perspective,
      position: position,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    ),
    [
      context,
      resolvedWidth,
      aspectRatio,
      depth,
      pitch,
      yaw,
      roll,
      scale,
      perspective,
      position,
      animationDuration,
      animationCurve,
    ],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
