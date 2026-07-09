import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart' show Side, SnackbarTone, Snackbar;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

_TopSnackbarHandle? _activeTopSnackbar;

void showSnackbar(
  BuildContext context, {
  required String message,
  Widget? leading,
  SnackbarTone tone = SnackbarTone.surface,
  Side side = Side.top,
  Duration duration = const Duration(seconds: 3),
  bool clearCurrent = true,
}) {
  final messenger = ScaffoldMessenger.of(context);

  if (clearCurrent) {
    messenger.clearSnackBars();
    _activeTopSnackbar?.dismiss();
  }

  if (side == Side.top) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late final _TopSnackbarHandle handle;
    late final OverlayEntry entry;
    var removed = false;

    entry = OverlayEntry(
      builder: (context) => _TopSnackbarOverlay(
        message: message,
        leading: leading,
        tone: tone,
        duration: duration,
        isExiting: handle.isExiting,
        onRemoved: () {
          if (removed) return;
          removed = true;
          if (_activeTopSnackbar == handle) {
            _activeTopSnackbar = null;
          }
          if (entry.mounted) {
            entry.remove();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) => handle.dispose());
        },
      ),
    );
    handle = _TopSnackbarHandle(entry: entry);
    _activeTopSnackbar = handle;
    overlay.insert(entry);
    return;
  }

  messenger.showSnackBar(
    SnackBar(
      content: Snackbar(message: message, leading: leading, tone: tone),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

class _TopSnackbarHandle {
  _TopSnackbarHandle({required this.entry});

  final OverlayEntry entry;
  final ValueNotifier<bool> isExiting = ValueNotifier(false);

  void dismiss() {
    isExiting.value = true;
  }

  void dispose() => isExiting.dispose();
}

class _TopSnackbarOverlay extends HookWidget {
  const _TopSnackbarOverlay({
    super.key,
    required this.message,
    required this.leading,
    required this.tone,
    required this.duration,
    required this.isExiting,
    required this.onRemoved,
  });

  final String message;
  final Widget? leading;
  final SnackbarTone tone;
  final Duration duration;
  final ValueNotifier<bool> isExiting;
  final VoidCallback onRemoved;

  static const _animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final exiting = useValueListenable(isExiting);

    useEffect(() {
      final timer = Timer(duration, () => isExiting.value = true);
      return timer.cancel;
    }, [duration, isExiting]);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Dismissible(
          key: const ValueKey('top-snackbar'),
          direction: DismissDirection.horizontal,
          onDismissed: (_) => onRemoved(),
          child: Snackbar(message: message, leading: leading, tone: tone)
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
                begin: -1,
                end: 0,
              ),
        ),
      ),
    );
  }
}
