import 'package:flutter/material.dart';

class SelectionTileFrame extends StatelessWidget {
  const SelectionTileFrame({
    super.key,
    required this.child,
    required this.isSelecting,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    this.borderRadius = 8,
  });

  final Widget child;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = isSelecting || isSelected;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          onLongPress: onLongPress,
          child: child,
        ),
        if (selected)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: 0.55),
                    width: isSelected ? 2 : 1.5,
                  ),
                  color: isSelected
                      ? scheme.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        if (isSelected)
          Positioned(
            top: 8,
            right: 8,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
