import 'package:boo_mondai/lib.barrel.dart'
    show Button, ButtonVariant, ButtonColor;
import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Icons, Icon, Text;

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      variants: const [ButtonVariant.filled, ButtonColor.mono],
      leading: Icon(Icons.apple),
      onPressed: null,
      child: Text('CONTINUE WITH APPLE'),
    );
  }
}
