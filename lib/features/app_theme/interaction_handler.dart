import 'package:boo_mondai/lib.barrel.dart' show SelectionController;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PointerHoverEvent;
import 'package:flutter_hooks/flutter_hooks.dart';

class InteractionHandler<T> extends HookWidget {
  const InteractionHandler({
    super.key,
    required this.child,
    this.selectionController,
    this.selectionValue,
    this.onPressed,
    this.onHover,
  });

  final Widget child;
  final SelectionController<T>? selectionController;
  final T? selectionValue;
  final VoidCallback? onPressed;
  final void Function(PointerHoverEvent hoverEvent)? onHover;

  @override
  Widget build(BuildContext context) {
    final controller = selectionController;
    final value = selectionValue;
    final isSelecting = controller?.isEnabled ?? false;
    final canSelect = controller != null && value != null;

    if (isSelecting) {
      return GestureDetector(
        onTap: canSelect
            ? () {
                selectionController?.toggle(value);
              }
            : null,
        child: child,
      );
    }
    return MouseRegion(
      onHover: onHover,
      child: GestureDetector(
        onLongPress: canSelect
            ? () {
                selectionController?.isEnabled = true;
                selectionController?.select(value);
              }
            : null,
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
