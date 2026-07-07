import 'package:boo_mondai/lib.barrel.dart' show Side;
import 'package:flutter/cupertino.dart';

class ViewPaddingSizedBox extends StatelessWidget {
  const ViewPaddingSizedBox({super.key, required this.side});

  final Side side;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = switch (side) {
      Side.top => mediaQuery.viewPadding.top,
      Side.bottom => mediaQuery.viewPadding.bottom,
    };
    return SizedBox(height: padding, width: double.infinity);
  }
}
