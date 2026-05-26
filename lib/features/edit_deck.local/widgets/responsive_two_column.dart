import 'package:flutter/material.dart';

class ResponsiveTwoColumn extends StatelessWidget {
  const ResponsiveTwoColumn({
    required this.children,
    this.childHeight = 520,
    super.key,
  });

  final List<Widget> children;
  final double childHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              for (final child in children) ...[
                SizedBox(height: childHeight, child: child),
                if (child != children.last) const SizedBox(height: 24),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final child in children) ...[
              Expanded(
                child: SizedBox(height: childHeight, child: child),
              ),
              if (child != children.last) const SizedBox(width: 28),
            ],
          ],
        );
      },
    );
  }
}
