import 'package:boo_mondai/lib.barrel.dart' show Button, ButtonTone;
import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Icons, Icon, Text;

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      variants: const [ButtonTone.mono],
      leading: Icon(Icons.apple),
      onPressed: null,
      child: Text('CONTINUE WITH APPLE'),
    );
  }
}
