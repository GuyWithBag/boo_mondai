import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

CubeController useCubeController({
  double? width,
  double? height,
  double? depth,
  double pitch = 0,
  double yaw = 0,
  double roll = 0,
  double scale = 1.0,
  double perspective = 0,
  Offset position = Offset.zero,
  Duration animationDuration = const Duration(milliseconds: 260),
  Curve animationCurve = Curves.easeOutCubic,
}) {
  final controller = useMemoized(
    () => CubeController(
      width: width ?? 0,
      height: height ?? 0,
      depth: depth ?? 0,
      pitch: pitch,
      yaw: yaw,
      roll: roll,
      scale: scale,
      perspective: perspective,
      position: position,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    ),
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
