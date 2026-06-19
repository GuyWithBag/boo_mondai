import 'package:boo_mondai/lib.barrel.dart'
    show AuthController, Button, ButtonColor;

import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Icons, Icon, Text;
import 'package:provider/provider.dart' show ReadContext;

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return Button(
      variants: const [ButtonColor.google],
      leading: Icon(Icons.g_mobiledata),
      child: Text('CONTINUE WITH GOOGLE'),
      onPressed: () async {
        final loginFuture = auth.signInWithGoogle();

        await loginFuture;
      },
    );
  }
}
