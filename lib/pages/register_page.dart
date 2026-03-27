// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/register_page.dart
// PURPOSE: Registration screen for new users
// PROVIDERS: AuthProvider
// HOOKS: useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocus = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final auth = context.watch<AuthProvider>();

    useEffect(() {
      emailFocus.requestFocus();
      return null;
    }, const []);

    return Scaffold(
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
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      validator: (v) =>
                          v != null && v.isNotEmpty ? null : 'Enter a display name',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Enter a valid email',
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
                                context.read<AuthProvider>().signUp(
                                      emailController.text.trim(),
                                      passwordController.text,
                                      nameController.text.trim(),
                                    );
                              }
                            },
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign Up'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: const Text('Already have an account? Sign In'),
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
