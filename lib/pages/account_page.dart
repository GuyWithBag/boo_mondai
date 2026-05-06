// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/account_page.dart
// PURPOSE: Account page — login/register when unauthenticated, profile when authenticated
// PROVIDERS: AuthController, StreakController
// HOOKS: useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class AccountPage extends HookWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      // Should be if it is logged in supabase or has a supabase account.
      body: !auth.currentProfile.isAnonymous
          ? AuthenticatedAccountView()
          : const UnauthenticatedAccountView(),
    );
  }
}
