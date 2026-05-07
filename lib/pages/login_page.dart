import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  static String? _validateEmail(String? value) {
    if (value != null && value.contains('@')) return null;
    return 'Enter a valid email';
  }

  static String? _validatePassword(String? value) {
    if (value != null && value.length >= 6) return null;
    return 'Password must be at least 6 characters';
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocus = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final auth = context.watch<AuthController>();

    // 1. Initial Focus Effect
    VoidCallback? handleInitFocus() {
      emailFocus.requestFocus();
      return null;
    }

    useEffect(handleInitFocus, const []);

    // 2. Dialog Builder
    Widget buildMergeDialog(BuildContext dialogContext) {
      return GuestMergeDialog(auth: auth);
    }

    // 3. Action-Driven Sign In (Navigation is handled entirely by routes.dart!)
    Future<void> performSignIn() async {
      if (formKey.currentState!.validate()) {
        await auth.signIn(emailController.text.trim(), passwordController.text);

        if (!context.mounted) return;

        // If the sign-in resulted in a pending merge, show the dialog.
        // Otherwise, GoRouter will automatically redirect them to '/'
        if (auth.hasPendingGuestMerge) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: buildMergeDialog,
          );
        }
      }
    }

    void navigateToRegister() {
      context.push('/register');
    }

    return Scaffold(
      appBar: AppBar(),
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
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      ErrorText(auth.error),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: auth.isLoading ? null : performSignIn,
                      child: auth.isLoading
                          ? const _LoadingIndicator()
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: navigateToRegister,
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

// ── Screen-local widgets ─────────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class GuestMergeDialog extends StatelessWidget {
  final AuthController auth;
  const GuestMergeDialog({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    // Once these complete, AuthController clears the merge state.
    // GoRouter notices the state change and automatically routes to '/'!
    void discardLocalData() {
      Navigator.of(context).pop();
      auth.confirmMerge(false);
    }

    void mergeLocalData() {
      Navigator.of(context).pop();
      auth.confirmMerge(true);
    }

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
          onPressed: auth.isLoading ? null : discardLocalData,
          child: const Text('Discard local data'),
        ),
        FilledButton(
          onPressed: auth.isLoading ? null : mergeLocalData,
          child: auth.isLoading
              ? const _LoadingIndicator()
              : const Text('Merge into account'),
        ),
      ],
    );
  }
}
