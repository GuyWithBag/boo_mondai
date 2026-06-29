import 'package:boo_mondai/lib.barrel.dart' show Button;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = 24.w;
    final verticalPadding = 16.h;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding + 4,
      ),
      child: Button(
        leading: const Icon(Icons.arrow_back),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
            return;
          }
          context.go('/');
        },
      ),
    );
  }
}
