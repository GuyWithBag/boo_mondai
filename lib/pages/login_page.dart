// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/login_page.dart
// PURPOSE: Email/password login screen
// PROVIDERS: AuthProvider
// HOOKS: useTextEditingController, useFocusNode, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocus = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final auth = context.watch<AuthProvider>();

    useEffect(() {
      emailFocus.requestFocus();
      return null;
    }, const []);

    // Navigate home only when authenticated AND the merge dialog is not pending.
    useEffect(() {
      if (auth.isAuthenticated && !auth.hasPendingGuestMerge) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go('/');
        });
      }
      return null;
    }, [auth.isAuthenticated, auth.hasPendingGuestMerge]);

    // Show the merge dialog when the provider signals a pending decision.
    useEffect(() {
      if (!auth.hasPendingGuestMerge) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => GuestMergeDialog(auth: auth),
        );
      });
      return null;
    }, [auth.hasPendingGuestMerge]);

    return Scaffold(
      appBar: AppBar(
        // leading: Navigator.canPop(context)
        //     ? BackButton(onPressed: () => Navigator.pop(context))
        //     : null,
        // automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'BooMondai',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v != null && v.contains('@')
                          ? null
                          : 'Enter a valid email',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),
                      obscureText: true,
                      validator: (v) => v != null && v.length >= 6
                          ? null
                          : 'Password must be at least 6 characters',
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      ErrorText(auth.error!),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthProvider>().signIn(
                                  emailController.text.trim(),
                                  passwordController.text,
                                );
                              }
                            },
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Screen-local widget ──────────────────────────────────────────────────────

/// Dialog shown when a guest who has local data signs into an existing account.
/// Forces a choice — [barrierDismissible] must be false at the call site.
class GuestMergeDialog extends StatelessWidget {
  final AuthProvider auth;
  const GuestMergeDialog({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('You have local data'),
      content: const Text(
        'You created decks and study progress on this device before signing in. '
        'Would you like to merge them into your account?\n\n'
        'If you discard, your local data will be deleted and your '
        'account data will be loaded instead.',
      ),
      actions: [
        TextButton(
          onPressed: auth.isLoading
              ? null
              : () {
                  Navigator.of(context).pop();
                  auth.confirmMerge(false);
                },
          child: const Text('Discard local data'),
        ),
        FilledButton(
          onPressed: auth.isLoading
              ? null
              : () {
                  Navigator.of(context).pop();
                  auth.confirmMerge(true);
                },
          child: auth.isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Merge into account'),
        ),
      ],
    );
  }
}
