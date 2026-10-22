import 'package:boo_mondai/lib.barrel.dart' show Button, ButtonColor;
import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Icons, Icon, Text;

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      variants: const [ButtonColor.mono],
      leading: const Icon(Icons.apple),
      onPressed: null,
      child: const Text('CONTINUE WITH APPLE'),
    );
  }
}
