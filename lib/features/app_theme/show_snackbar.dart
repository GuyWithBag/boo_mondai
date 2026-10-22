import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        ScaffoldOverlayGeometry,
        Side,
        Snackbar,
        SnackbarColor,
        SnackbarVariant;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

_OverlaySnackbarHandle? _activeTopSnackbar;
_OverlaySnackbarHandle? _activeBottomSnackbar;

SnackbarHandle showSnackbar(
  BuildContext context, {
  required String message,
  Widget? leading,
  Widget? content,
  Widget? child,
  SnackbarColor color = SnackbarColor.surface,
  SnackbarVariant variant = SnackbarVariant.elevated,
  List<Object> variants = const [],
  Side side = Side.bottom,
  Duration? duration = const Duration(seconds: 3),
  bool clearCurrent = true,
}) {
  if (clearCurrent) {
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
    _activeTopSnackbar?.dismiss();
    _activeBottomSnackbar?.dismiss();
  }

  final overlay = Overlay.of(context, rootOverlay: true);
  final geometry = ScaffoldOverlayGeometry.maybeOf(context);
  late final _OverlaySnackbarHandle handle;
  late final OverlayEntry entry;
  var removed = false;

  entry = OverlayEntry(
    builder: (context) => _SnackbarOverlay(
      message: message,
      leading: leading,
      content: content,
      color: color,
      variant: variant,
      variants: variants,
      side: side,
      bottomInset: geometry?.bottomInset ?? 0,
      duration: duration,
      isExiting: handle.isExiting,
      child: child,
      onRemoved: () {
        if (removed) return;
        removed = true;
        switch (side) {
          case Side.top:
            if (_activeTopSnackbar == handle) {
              _activeTopSnackbar = null;
            }
          case Side.bottom:
            if (_activeBottomSnackbar == handle) {
              _activeBottomSnackbar = null;
            }
        }
        if (entry.mounted) {
          entry.remove();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => handle.dispose());
      },
    ),
  );
  handle = _OverlaySnackbarHandle(entry: entry);
  switch (side) {
    case Side.top:
      _activeTopSnackbar?.dismiss();
      _activeTopSnackbar = handle;
    case Side.bottom:
      _activeBottomSnackbar?.dismiss();
      _activeBottomSnackbar = handle;
  }
  overlay.insert(entry);
  return handle;
}

abstract interface class SnackbarHandle {
  void dismiss();
}

class _OverlaySnackbarHandle implements SnackbarHandle {
  _OverlaySnackbarHandle({required this.entry});

  final OverlayEntry entry;
  final ValueNotifier<bool> isExiting = ValueNotifier(false);

  @override
  void dismiss() {
    isExiting.value = true;
  }

  void dispose() => isExiting.dispose();
}

class _SnackbarOverlay extends HookWidget {
  const _SnackbarOverlay({
    required this.message,
    required this.leading,
    required this.content,
    required this.child,
    required this.color,
    required this.variant,
    required this.variants,
    required this.side,
    required this.bottomInset,
    required this.duration,
    required this.isExiting,
    required this.onRemoved,
  });

  final String message;
  final Widget? leading;
  final Widget? content;
  final Widget? child;
  final SnackbarColor color;
  final SnackbarVariant variant;
  final List<Object> variants;
  final Side side;
  final double bottomInset;
  final Duration? duration;
  final ValueNotifier<bool> isExiting;
  final VoidCallback onRemoved;

  static const _animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final exiting = useValueListenable(isExiting);

    useEffect(() {
      final duration = this.duration;
      if (duration == null) return null;
      final timer = Timer(duration, () => isExiting.value = true);
      return timer.cancel;
    }, [duration, isExiting]);

    return Positioned(
      top: side == Side.top ? 0 : null,
      bottom: side == Side.bottom ? bottomInset : null,
      left: 0,
      right: 0,
      child: SafeArea(
        top: side == Side.top,
        bottom: side == Side.bottom && bottomInset == 0,
        child: Dismissible(
          key: ValueKey('${side.name}-snackbar'),
          direction: DismissDirection.horizontal,
          onDismissed: (_) => onRemoved(),
          child:
              Snackbar(
                    message: message,
                    leading: leading,
                    content: content,
                    color: color,
                    variant: variant,
                    variants: variants,
                    child: child,
                  )
                  .animate(
                    target: exiting ? 0 : 1,
                    onComplete: (_) {
                      if (exiting) onRemoved();
                    },
                  )
                  .fade(
                    duration: _animationDuration,
                    curve: Curves.easeOutCubic,
                    begin: 0,
                    end: 1,
                  )
                  .slideY(
                    duration: _animationDuration,
                    curve: Curves.easeOutCubic,
                    begin: side == Side.top ? -1 : 1,
                    end: 0,
                  ),
        ),
      ),
    );
  }
}
