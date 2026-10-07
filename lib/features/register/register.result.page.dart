import 'package:boo_mondai/lib.barrel.dart'
    show AppBar, Button, ButtonColor, Pages, Scaffold, StatusLayoutState;
import 'package:flutter/material.dart' hide AppBar, BackButton, Scaffold;
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';

class RegisterResultPage extends SignalHookWidget {
  const RegisterResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 'Check Your Email'),
      centeredBody: true,
      body: StatusLayoutState(
        icon: Icons.mark_email_read_outlined,
        title: 'Check your email',
        message:
            'We sent you a confirmation link. Open it from your inbox to finish setting up your BooMondai account.',
        actions: [
          Button(
            variants: [ButtonColor.primary],
            onPressed: () => context.go(Pages.decksLocal.url),
            leading: const Icon(Icons.arrow_back),
            child: const Text('Back to Decks'),
          ),
        ],
      ),
    );
  }
}
