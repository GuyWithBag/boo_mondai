// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/register_page.dart
// PURPOSE: Registration screen for new users
// PROVIDERS: AuthController
// HOOKS: useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/app_theme/loading_indicator.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        useRegisterController,
        AuthValidators,
        ErrorText,
        AppTokens,
        ButtonColor,
        Button,
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
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final register = useRegisterController(
      authController: context.read<AuthController>(),
    );

    return Scaffold(
      appBar: AppBar(title: 'Create an Account'),
      body: Form(
        key: register.formKey,
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
              value: register.nameController.text,
              listenable: register.nameController,
              valueReader: () => register.nameController.text,
              validator: AuthValidators.displayName,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Display Name'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: register.nameController,
                    focusNode: register.nameFocus,
                    placeholder: 'Display name',
                    textInputAction: TextInputAction.next,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => register.emailFocus.requestFocus(),
                  ),
                ],
              ),
            ),
            FormField<String>(
              value: register.emailController.text,
              listenable: register.emailController,
              valueReader: () => register.emailController.text,
              validator: AuthValidators.email,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Email'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: register.emailController,
                    focusNode: register.emailFocus,
                    placeholder: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => register.passwordFocus.requestFocus(),
                  ),
                ],
              ),
            ),
            FormField<String>(
              value: register.passwordController.text,
              listenable: register.passwordController,
              valueReader: () => register.passwordController.text,
              validator: AuthValidators.password,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Password'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: register.passwordController,
                    focusNode: register.passwordFocus,
                    placeholder: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => register.signUp(context),
                  ),
                ],
              ),
            ),
            if (register.error != null) ...[
              ErrorText.exception(register.error),
            ],
            Button(
              variants: [ButtonColor.primary],

              onPressed: register.isLoading
                  ? null
                  : () => register.signUp(context),
              child: register.isLoading
                  ? const LoadingIndicator()
                  : const Text('Sign Up'),
            ),
            Button(
              onPressed: () => context.push('/login'),
              child: const Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
