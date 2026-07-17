import 'package:boo_mondai/features/auth/auth.validators.dart'
    show AuthValidators;
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        useLoginController,
        LoadingIndicator,
        ErrorText,
        AppTokens,
        ButtonColor,
        Button,
        ButtonVariant,
        FormField,
        Scaffold,
        AppBar,
        TextFieldFrame,
        TextFieldSize,
        TextField;
import 'package:flutter/material.dart'
    hide FormField, TextField, Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final login = useLoginController(
      context: context,
      authController: context.read<AuthController>(),
    );
    final tokens = context.themeTokens<AppTokens>();

    return Scaffold(
      appBar: AppBar(title: 'Login'),
      body: Form(
        key: login.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: tokens.spaceLayoutGapMd,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'BooMondai',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            FormField<String>(
              value: login.emailController.text,
              listenable: login.emailController,
              valueReader: () => login.emailController.text,
              validator: AuthValidators.email,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Email'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: login.emailController,
                    focusNode: login.emailFocus,
                    placeholder: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => login.passwordFocus.requestFocus(),
                  ),
                ],
              ),
            ),
            FormField<String>(
              value: login.passwordController.text,
              listenable: login.passwordController,
              valueReader: () => login.passwordController.text,
              validator: AuthValidators.password,
              builder: (context, field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Password'),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                  TextField(
                    controller: login.passwordController,
                    focusNode: login.passwordFocus,
                    placeholder: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    variants: const [
                      TextFieldSize.normal,
                      TextFieldFrame.outline,
                    ],
                    onChanged: field.didChange,
                    onSubmitted: (_) => login.signIn(),
                  ),
                ],
              ),
            ),
            if (login.error != null) ...[ErrorText(login.error)],
            Button(
              variants: const [ButtonColor.primary],

              onPressed: login.isLoading ? null : login.signIn,
              child: login.isLoading
                  ? const LoadingIndicator()
                  : const Text('Sign In'),
            ),
            Button(
              variants: const [ButtonColor.primary, ButtonVariant.flat],

              onPressed: () => context.push('/register'),
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
