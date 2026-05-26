import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:boo_mondai/lib.barrel.dart'
    show CubeController, useCubeController;
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Cube extends HookWidget {
  const Cube({
    super.key,
    this.width = 0,
    this.height = 0,
    this.depth = 0,
    this.pitch = 0,
    this.yaw = 0,
    this.roll = 0,
    this.scale = 1.0,
    this.perspective = 0.0015,
    this.position = Offset.zero,
    this.controller,
    this.draggable = false,
    this.dragSensitivity = 0.01,
    this.animateChanges = true,
    this.front,
    this.back,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  final double width;
  final double height;
  final double depth;
  final double pitch;
  final double yaw;
  final double roll;
  final double scale;
  final double perspective;
  final Offset position;
  final CubeController? controller;
  final bool draggable;
  final double dragSensitivity;
  final bool animateChanges;
  final Widget? front;
  final Widget? back;
  final Widget? left;
  final Widget? right;
  final Widget? top;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final fallbackController = useCubeController(
      width: width,
      height: height,
      depth: depth,
      pitch: pitch,
      yaw: yaw,
      roll: roll,
      scale: scale,
      perspective: perspective,
      position: position,
    );
    final activeController = controller ?? fallbackController;

    useListenable(activeController);

    useEffect(
      () {
        if (controller == null) {
          activeController
            ..setDimensions(width: width, height: height, depth: depth)
            ..setRotation(pitch: pitch, yaw: yaw, roll: roll)
            ..scale = scale
            ..perspective = perspective
            ..position = position;
        }
        return null;
      },
      [
        activeController,
        controller,
        width,
        height,
        depth,
        pitch,
        yaw,
        roll,
        scale,
        perspective,
        position,
      ],
    );

    final targetState = _CubeTransformState(
      width: activeController.width,
      height: activeController.height,
      depth: activeController.depth,
      pitch: activeController.pitch,
      yaw: activeController.yaw,
      roll: activeController.roll,
      scale: activeController.scale,
      perspective: activeController.perspective,
      position: activeController.position,
    );

    final cube = TweenAnimationBuilder<_CubeTransformState>(
      tween: _CubeTransformTween(end: targetState),
      duration: animateChanges
          ? activeController.animationDuration
          : Duration.zero,
      curve: activeController.animationCurve,
      builder: (context, animatedState, _) {
        return _CubeBody(
          width: animatedState.width,
          height: animatedState.height,
          depth: animatedState.depth,
          pitch: animatedState.pitch,
          yaw: animatedState.yaw,
          roll: animatedState.roll,
          scale: animatedState.scale,
          perspective: animatedState.perspective,
          position: animatedState.position,
          front: front,
          back: back,
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        );
      },
    );

    if (!draggable) {
      return cube;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (details) {
        activeController.rotateBy(
          pitch: -details.delta.dy * dragSensitivity,
          yaw: details.delta.dx * dragSensitivity,
        );
      },
      child: cube,
    );
  }
}

class _CubeTransformState {
  const _CubeTransformState({
    required this.width,
    required this.height,
    required this.depth,
    required this.pitch,
    required this.yaw,
    required this.roll,
    required this.scale,
    required this.perspective,
    required this.position,
  });

  final double width;
  final double height;
  final double depth;
  final double pitch;
  final double yaw;
  final double roll;
  final double scale;
  final double perspective;
  final Offset position;
}

class _CubeTransformTween extends Tween<_CubeTransformState> {
  _CubeTransformTween({super.end});

  @override
  _CubeTransformState lerp(double t) {
    final start = begin ?? end!;
    final finish = end!;

    return _CubeTransformState(
      width: lerpDouble(start.width, finish.width, t)!,
      height: lerpDouble(start.height, finish.height, t)!,
      depth: lerpDouble(start.depth, finish.depth, t)!,
      pitch: lerpDouble(start.pitch, finish.pitch, t)!,
      yaw: lerpDouble(start.yaw, finish.yaw, t)!,
      roll: lerpDouble(start.roll, finish.roll, t)!,
      scale: lerpDouble(start.scale, finish.scale, t)!,
      perspective: lerpDouble(start.perspective, finish.perspective, t)!,
      position: Offset.lerp(start.position, finish.position, t)!,
    );
  }
}

class _CubeBody extends StatelessWidget {
  const _CubeBody({
    required this.width,
    required this.height,
    required this.depth,
    required this.pitch,
    required this.yaw,
    required this.roll,
    required this.scale,
    required this.perspective,
    required this.position,
    required this.front,
    required this.back,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  final double width;
  final double height;
  final double depth;
  final double pitch;
  final double yaw;
  final double roll;
  final double scale;
  final double perspective;
  final Offset position;
  final Widget? front;
  final Widget? back;
  final Widget? left;
  final Widget? right;
  final Widget? top;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final bounds = _outerBounds;
    final faces = _sortedFaces;

    return Transform.translate(
      offset: position,
      child: SizedBox(
        width: bounds,
        height: bounds,
        child: Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, perspective)
              ..rotateX(pitch)
              ..rotateY(yaw)
              ..rotateZ(roll)
              ..scaleByDouble(scale, scale, scale, 1.0),
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: faces.map(_CubeFace.fromData).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get _outerBounds =>
      math.sqrt(width * width + height * height + depth * depth);

  List<_CubeFaceData> get _sortedFaces {
    final rotation = Matrix4.identity()
      ..rotateX(pitch)
      ..rotateY(yaw)
      ..rotateZ(roll);
    final faces = [
      _CubeFaceData(
        width: width,
        height: height,
        center: Vector3(0.0, 0.0, depth / 2),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, depth / 2, 1.0),
        child: front,
      ),
      _CubeFaceData(
        width: width,
        height: height,
        center: Vector3(0.0, 0.0, -depth / 2),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, -depth / 2, 1.0)
          ..rotateY(math.pi),
        child: back,
      ),
      _CubeFaceData(
        width: depth,
        height: height,
        center: Vector3(-width / 2, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(-width / 2, 0.0, 0.0, 1.0)
          ..rotateY(-math.pi / 2),
        child: left,
      ),
      _CubeFaceData(
        width: depth,
        height: height,
        center: Vector3(width / 2, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(width / 2, 0.0, 0.0, 1.0)
          ..rotateY(math.pi / 2),
        child: right,
      ),
      _CubeFaceData(
        width: width,
        height: depth,
        center: Vector3(0.0, -height / 2, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, -height / 2, 0.0, 1.0)
          ..rotateX(math.pi / 2),
        child: top,
      ),
      _CubeFaceData(
        width: width,
        height: depth,
        center: Vector3(0.0, height / 2, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, height / 2, 0.0, 1.0)
          ..rotateX(-math.pi / 2),
        child: bottom,
      ),
    ];

    faces.sort((a, b) {
      final aDepth = rotation.transform3(a.center).z;
      final bDepth = rotation.transform3(b.center).z;

      return aDepth.compareTo(bDepth);
    });

    return faces;
  }
}

class _CubeFace extends StatelessWidget {
  const _CubeFace({
    required this.width,
    required this.height,
    required this.transform,
    required this.child,
  });

  final double width;
  final double height;
  final Matrix4 transform;
  final Widget? child;

  factory _CubeFace.fromData(_CubeFaceData data) {
    return _CubeFace(
      width: data.width,
      height: data.height,
      transform: data.transform,
      child: data.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: SizedBox(
        width: width,
        height: height,
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _CubeFaceData {
  const _CubeFaceData({
    required this.width,
    required this.height,
    required this.center,
    required this.transform,
    required this.child,
  });

  final double width;
  final double height;
  final Vector3 center;
  final Matrix4 transform;
  final Widget? child;
}
