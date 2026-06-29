import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, ButtonColor, buttonStyle;
import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Icons, Icon, Text;
import 'package:theme_variants/theme_variants.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      style: buttonStyle.resolve(
        context.themeTokens<AppTokens>(),
        const [ButtonColor.mono],
      ),
      leading: const Icon(Icons.apple),
      onPressed: null,
      child: const Text('CONTINUE WITH APPLE'),
    );
  }
}
