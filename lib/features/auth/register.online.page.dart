// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/register_page.dart
// PURPOSE: Registration screen for new users
// PROVIDERS: AuthController
// HOOKS: useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        AuthValidators,
        showGuestMergeDialog,
        ErrorText,
        AppTokens,
        ButtonColor,
        Button,
        buttonStyle,
        ButtonVariant,
        FormField,
        Scaffold,
        AppBar,
        TextFieldFrame,
        TextFieldSize,
        TextField;
import 'package:flutter/material.dart'
    hide BackButton, FormField, TextField, Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocus = useFocusNode();
    final nameFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final tokens = context.themeTokens<AppTokens>();

    final auth = context.watch<AuthController>();

    useEffect(() {
      nameFocus.requestFocus();
      return null;
    }, const []);

    Future<void> signUp() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      await auth.signUp(
        emailController.text.trim(),
        passwordController.text,
        nameController.text.trim(),
      );

      if (!context.mounted) return;

      if (auth.hasPendingGuestMerge) {
        await showGuestMergeDialog(context: context, auth: auth);
      }
    }

    return Scaffold(
      appBar: AppBar(title: 'Create an Account'),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: tokens.spaceLayoutGapMd,
          children: [
            Text(
              'Create Account',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            FormField<String>(
              value: nameController.text,
              listenable: nameController,
              valueReader: () => nameController.text,
              validator: AuthValidators.displayName,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Display Name'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: nameController,
                    focusNode: nameFocus,
                    placeholder: 'Display name',
                    textInputAction: TextInputAction.next,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => emailFocus.requestFocus(),
                  ),
                ],
              ),
            ),
            FormField<String>(
              value: emailController.text,
              listenable: emailController,
              valueReader: () => emailController.text,
              validator: AuthValidators.email,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Email'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: emailController,
                    focusNode: emailFocus,
                    placeholder: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => passwordFocus.requestFocus(),
                  ),
                ],
              ),
            ),
            FormField<String>(
              value: passwordController.text,
              listenable: passwordController,
              valueReader: () => passwordController.text,
              validator: AuthValidators.password,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Password'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    placeholder: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => signUp(),
                  ),
                ],
              ),
            ),
            if (auth.error != null) ...[ErrorText(auth.error)],
            Button(
              style: buttonStyle.resolve(
                context.themeTokens<AppTokens>(),
                const [ButtonColor.primary],
              ),
              onPressed: auth.isLoading ? null : signUp,
              child: auth.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign Up'),
            ),
            Button(
              style: buttonStyle.resolve(
                context.themeTokens<AppTokens>(),
                const [ButtonColor.primary, ButtonVariant.flat],
              ),
              onPressed: () => context.push('/login'),
              child: const Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
