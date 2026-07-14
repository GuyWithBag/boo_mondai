import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, AuthController, Button, ButtonColor, buttonStyle;

import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Icons, Icon, Text;
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return Button(
      style: buttonStyle.resolve(context.themeTokens<AppTokens>(), const [
        ButtonColor.google,
      ]),
      leading: const Icon(Icons.g_mobiledata),
      child: const Text('CONTINUE WITH GOOGLE'),
      onPressed: () async {
        final loginFuture = auth.signInWithGoogle();

        await loginFuture;
      },
    );
  }
}
