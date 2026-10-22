import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ScaleHelper, CubeController;
import 'package:flutter/material.dart' show BuildContext, Offset, Curve, Curves;
import 'package:signals/signals_flutter.dart';
import 'package:theme_variants/theme_variants.dart';

class PhysicalCardController {
  PhysicalCardController(
    BuildContext context, {
    double? width,
    double aspectRatio = defaultAspectRatio,
    double depth = 10,
    double pitch = 0,
    double yaw = 0,
    double roll = 0,
    double scale = 1.0,
    double perspective = 1,
    Offset position = Offset.zero,
    Duration animationDuration = const Duration(milliseconds: 260),
    Curve animationCurve = Curves.easeOutCubic,
  }) : assert(resolveWidth(context, width) > 0),
       assert(aspectRatio > 0),
       aspectRatio = signal(aspectRatio),
       controller = CubeController(
         width: resolveWidth(context, width),
         height: ScaleHelper.getSizeFromWidthAndAspectRatio(
           width: resolveWidth(context, width),
           aspectRatio: aspectRatio,
         ).height,
         depth: depth,
         pitch: pitch,
         yaw: yaw,
         roll: roll,
         scale: scale,
         perspective: perspective,
         position: position,
         animationDuration: animationDuration,
         animationCurve: animationCurve,
       );

  static const double defaultAspectRatio = 5 / 7;

  static double resolveWidth(BuildContext context, double? width) {
    return width ?? context.themeTokens<AppTokens>().studyCardWidth;
  }

  final Signal<double> aspectRatio;
  final CubeController controller;

  late final width = computed(() => controller.width.value);
  late final height = computed(() => controller.height.value);
  late final depth = computed(() => controller.depth.value);
  late final pitch = computed(() => controller.pitch.value);
  late final yaw = computed(() => controller.yaw.value);
  late final roll = computed(() => controller.roll.value);
  late final scale = computed(() => controller.scale.value);
  late final perspective = computed(() => controller.perspective.value);
  late final position = computed(() => controller.position.value);
  late final animationDuration = computed(
    () => controller.animationDuration.value,
  );
  late final animationCurve = computed(() => controller.animationCurve.value);
  late final isBack = computed(() => controller.isBack.value);

  void setWidth(double value) {
    controller.setDimensions(
      width: value,
      height: ScaleHelper.getSizeFromWidthAndAspectRatio(
        width: value,
        aspectRatio: aspectRatio.value,
      ).height,
    );
  }

  void setAspectRatio(double value) {
    aspectRatio.value = value;
    setWidth(width.value);
  }

  void setDepth(double value) {
    controller.depth.value = value;
  }

  void setRotation({double? pitch, double? yaw, double? roll}) {
    controller.setRotation(pitch: pitch, yaw: yaw, roll: roll);
  }

  void rotateBy({double pitch = 0, double yaw = 0, double roll = 0}) {
    controller.rotateBy(pitch: pitch, yaw: yaw, roll: roll);
  }

  void resetRotation({double pitch = 0, double yaw = 0, double roll = 0}) {
    controller.resetRotation(pitch: pitch, yaw: yaw, roll: roll);
  }

  void setScale(double value) {
    controller.setScale(value);
  }

  void scaleBy(double factor) {
    controller.scaleBy(factor);
  }

  void resetScale() {
    controller.resetScale();
  }

  void resetPosition() {
    controller.resetPosition();
  }

  void setPosition({double? x, double? y}) {
    controller.setPosition(x: x, y: y);
  }

  void flip() {
    controller.flip();
  }

  void showBack(bool value, {bool animated = true}) {
    controller.showBack(value, animated: animated);
  }

  void dispose() {
    isBack.dispose();
    animationCurve.dispose();
    animationDuration.dispose();
    position.dispose();
    perspective.dispose();
    scale.dispose();
    roll.dispose();
    yaw.dispose();
    pitch.dispose();
    depth.dispose();
    height.dispose();
    width.dispose();
    aspectRatio.dispose();
    controller.dispose();
  }
}
