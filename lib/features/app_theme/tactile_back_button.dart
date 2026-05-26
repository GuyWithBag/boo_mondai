import 'package:boo_mondai/features/app_theme/tactile_button.dart'
    show TactileButton;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TactileBackButton extends StatelessWidget {
  const TactileBackButton({super.key});
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = 24.w;
    final verticalPadding = 16.h;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding + 4,
      ),
      child: TactileButton.icon(
        icon: Icons.arrow_back,
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
