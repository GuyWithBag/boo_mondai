import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ScaleHelper, CubeController;
import 'package:flutter/material.dart'
    show BuildContext, ChangeNotifier, Offset, Curve, Curves;
import 'package:theme_variants/theme_variants.dart';

class PhysicalCardController extends ChangeNotifier {
  PhysicalCardController(
    BuildContext context, {
    double? width,
    double aspectRatio = _defaultAspectRatio,
    double depth = 10,
    double pitch = 0,
    double yaw = 0,
    double roll = 0,
    double scale = 1.0,
    double perspective = 0.0015,
    Offset position = Offset.zero,
    Duration animationDuration = const Duration(milliseconds: 260),
    Curve animationCurve = Curves.easeOutCubic,
  }) : assert(_resolveWidth(context, width) > 0),
       assert(aspectRatio > 0),
       aspectRatio = aspectRatio,
       _controller = CubeController(
         width: _resolveWidth(context, width),
         height: ScaleHelper.getSizeFromWidthAndAspectRatio(
           width: _resolveWidth(context, width),
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
       ) {
    _controller.addListener(notifyListeners);
  }

  static const double _defaultAspectRatio = 5 / 7;

  static double _resolveWidth(BuildContext context, double? width) {
    return width ?? context.themeTokens<AppTokens>().studyCardWidth;
  }

  final double aspectRatio;
  final CubeController _controller;

  double get width => _controller.width;
  double get height => _controller.height;
  double get depth => _controller.depth;
  double get pitch => _controller.pitch;
  double get yaw => _controller.yaw;
  double get roll => _controller.roll;
  double get scale => _controller.scale;
  double get perspective => _controller.perspective;
  Offset get position => _controller.position;
  Duration get animationDuration => _controller.animationDuration;
  Curve get animationCurve => _controller.animationCurve;
  bool get isBack => _controller.isBack;
  CubeController get controller => _controller;

  void setWidth(double value) {
    _controller.setDimensions(
      width: value,
      height: ScaleHelper.getSizeFromWidthAndAspectRatio(
        width: value,
        aspectRatio: aspectRatio,
      ).height,
    );
  }

  void setRotation({double? pitch, double? yaw, double? roll}) {
    _controller.setRotation(pitch: pitch, yaw: yaw, roll: roll);
  }

  void rotateBy({double pitch = 0, double yaw = 0, double roll = 0}) {
    _controller.rotateBy(pitch: pitch, yaw: yaw, roll: roll);
  }

  void resetRotation({double pitch = 0, double yaw = 0, double roll = 0}) {
    _controller.resetRotation(pitch: pitch, yaw: yaw, roll: roll);
  }

  void setScale(double value) {
    _controller.setScale(value);
  }

  void scaleBy(double factor) {
    _controller.scaleBy(factor);
  }

  void resetScale() {
    _controller.resetScale();
  }

  void resetPosition() {
    _controller.resetPosition();
  }

  void setPosition({double? x, double? y}) {
    _controller.setPosition(x: x, y: y);
  }

  void flip() {
    _controller.flip();
  }

  void showBack(bool value, {bool animated = true}) {
    _controller.showBack(value, animated: animated);
  }

  @override
  void dispose() {
    _controller.removeListener(notifyListeners);
    _controller.dispose();
    super.dispose();
  }
}
