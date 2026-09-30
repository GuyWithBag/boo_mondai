import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class CubeController {
  CubeController({
    required double width,
    required double height,
    required double depth,
    double pitch = 0,
    double yaw = 0,
    double roll = 0,
    double scale = 1.0,
    double perspective = 0.0015,
    Offset position = Offset.zero,
    Duration animationDuration = const Duration(milliseconds: 260),
    Curve animationCurve = Curves.easeOutCubic,
  }) : width = signal(width),
       height = signal(height),
       depth = signal(depth),
       pitch = signal(pitch),
       yaw = signal(yaw),
       roll = signal(roll),
       scale = signal(scale),
       perspective = signal(perspective),
       position = signal(position),
       animationDuration = signal(animationDuration),
       animationCurve = signal(animationCurve);

  final Signal<double> width;
  final Signal<double> height;
  final Signal<double> depth;
  final Signal<double> pitch;
  final Signal<double> yaw;
  final Signal<double> roll;
  final Signal<double> scale;
  final Signal<double> perspective;
  final Signal<Offset> position;
  final Signal<Duration> animationDuration;
  final Signal<Curve> animationCurve;

  late final normalizedYaw = computed(() {
    final normalized = yaw.value % (2 * math.pi);
    return normalized < 0 ? normalized + (2 * math.pi) : normalized;
  });

  late final isBack = computed(
    () =>
        normalizedYaw.value >= math.pi / 2 &&
        normalizedYaw.value < 3 * math.pi / 2,
  );

  void setDimensions({double? width, double? height, double? depth}) {
    this.width.value = width ?? this.width.value;
    this.height.value = height ?? this.height.value;
    this.depth.value = depth ?? this.depth.value;
  }

  void setRotation({double? pitch, double? yaw, double? roll}) {
    this.pitch.value = pitch ?? this.pitch.value;
    this.yaw.value = yaw ?? this.yaw.value;
    this.roll.value = roll ?? this.roll.value;
  }

  void rotateBy({double pitch = 0, double yaw = 0, double roll = 0}) {
    this.pitch.value += pitch;
    this.yaw.value += yaw;
    this.roll.value += roll;
  }

  void resetRotation({double pitch = 0, double yaw = 0, double roll = 0}) {
    setRotation(pitch: pitch, yaw: yaw, roll: roll);
  }

  void setScale(double value) {
    scale.value = value;
  }

  void scaleBy(double factor) {
    scale.value *= factor;
  }

  void resetScale() {
    scale.value = 1.0;
  }

  void resetPosition() {
    position.value = Offset.zero;
  }

  void setPosition({double? x, double? y}) {
    position.value = Offset(x ?? position.value.dx, y ?? position.value.dy);
  }

  void moveBy({double x = 0, double y = 0}) {
    position.value = position.value.translate(x, y);
  }

  void flip({bool animated = true}) {
    showBack(!isBack.value, animated: animated);
  }

  void showFront({bool animated = true}) {
    setRotation(yaw: 0);
  }

  void showBack(bool value, {bool animated = true}) {
    setRotation(yaw: value ? math.pi : 0);
  }

  void dispose() {
    isBack.dispose();
    normalizedYaw.dispose();
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
  }
}
