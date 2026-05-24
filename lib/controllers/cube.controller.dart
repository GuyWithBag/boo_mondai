import 'dart:math' as math;

import 'package:flutter/material.dart';

class CubeController extends ChangeNotifier {
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
  }) : _width = width,
       _height = height,
       _depth = depth,
       _pitch = pitch,
       _yaw = yaw,
       _roll = roll,
       _scale = scale,
       _perspective = perspective,
       _position = position,
       _animationDuration = animationDuration,
       _animationCurve = animationCurve;

  double _width;
  double _height;
  double _depth;
  double _pitch;
  double _yaw;
  double _roll;
  double _scale;
  double _perspective;
  Offset _position;
  Duration _animationDuration;
  Curve _animationCurve;

  double get width => _width;
  double get height => _height;
  double get depth => _depth;
  double get pitch => _pitch;
  double get yaw => _yaw;
  double get roll => _roll;
  double get scale => _scale;
  double get perspective => _perspective;
  Offset get position => _position;
  Duration get animationDuration => _animationDuration;
  Curve get animationCurve => _animationCurve;
  bool get isBack =>
      _normalizedYaw >= math.pi / 2 && _normalizedYaw < 3 * math.pi / 2;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    notifyListeners();
  }

  set height(double value) {
    if (_height == value) {
      return;
    }

    _height = value;
    notifyListeners();
  }

  set depth(double value) {
    if (_depth == value) {
      return;
    }

    _depth = value;
    notifyListeners();
  }

  set pitch(double value) {
    if (_pitch == value) {
      return;
    }

    _pitch = value;
    notifyListeners();
  }

  set yaw(double value) {
    if (_yaw == value) {
      return;
    }

    _yaw = value;
    notifyListeners();
  }

  set roll(double value) {
    if (_roll == value) {
      return;
    }

    _roll = value;
    notifyListeners();
  }

  set scale(double value) {
    if (_scale == value) {
      return;
    }

    _scale = value;
    notifyListeners();
  }

  set perspective(double value) {
    if (_perspective == value) {
      return;
    }

    _perspective = value;
    notifyListeners();
  }

  set position(Offset value) {
    if (_position == value) {
      return;
    }

    _position = value;
    notifyListeners();
  }

  set animationDuration(Duration value) {
    if (_animationDuration == value) {
      return;
    }

    _animationDuration = value;
    notifyListeners();
  }

  set animationCurve(Curve value) {
    if (_animationCurve == value) {
      return;
    }

    _animationCurve = value;
    notifyListeners();
  }

  void setDimensions({double? width, double? height, double? depth}) {
    final nextWidth = width ?? _width;
    final nextHeight = height ?? _height;
    final nextDepth = depth ?? _depth;

    if (_width == nextWidth && _height == nextHeight && _depth == nextDepth) {
      return;
    }

    _width = nextWidth;
    _height = nextHeight;
    _depth = nextDepth;
    notifyListeners();
  }

  void setRotation({double? pitch, double? yaw, double? roll}) {
    final nextRotationX = pitch ?? _pitch;
    final nextRotationY = yaw ?? _yaw;
    final nextRotationZ = roll ?? _roll;

    if (_pitch == nextRotationX &&
        _yaw == nextRotationY &&
        _roll == nextRotationZ) {
      return;
    }

    _pitch = nextRotationX;
    _yaw = nextRotationY;
    _roll = nextRotationZ;
    notifyListeners();
  }

  void rotateBy({double pitch = 0, double yaw = 0, double roll = 0}) {
    if (pitch == 0 && yaw == 0 && roll == 0) {
      return;
    }

    _pitch += pitch;
    _yaw += yaw;
    _roll += roll;
    notifyListeners();
  }

  void resetRotation({double pitch = 0, double yaw = 0, double roll = 0}) {
    setRotation(pitch: pitch, yaw: yaw, roll: roll);
  }

  void setScale(double value) {
    scale = value;
  }

  void scaleBy(double factor) {
    if (factor == 1) {
      return;
    }

    _scale *= factor;
    notifyListeners();
  }

  void resetScale() {
    scale = 1.0;
  }

  void resetPosition() {
    setPosition(x: 0, y: 0);
  }

  void setPosition({double? x, double? y}) {
    final next = Offset(x ?? _position.dx, y ?? _position.dy);
    if (next == _position) {
      return;
    }

    _position = next;
    notifyListeners();
  }

  void moveBy({double x = 0, double y = 0}) {
    if (x == 0 && y == 0) {
      return;
    }

    _position = _position.translate(x, y);
    notifyListeners();
  }

  void flip({bool animated = true}) {
    showBack(!isBack, animated: animated);
  }

  void showFront({bool animated = true}) {
    setRotation(yaw: 0);
  }

  void showBack(bool value, {bool animated = true}) {
    setRotation(yaw: value ? math.pi : 0);
  }

  double get _normalizedYaw {
    final normalized = _yaw % (2 * math.pi);
    return normalized < 0 ? normalized + (2 * math.pi) : normalized;
  }
}
