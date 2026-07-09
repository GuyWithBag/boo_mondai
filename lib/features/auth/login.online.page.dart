import 'package:boo_mondai/features/auth/auth.controller.dart'
    show AuthController;
import 'package:boo_mondai/features/auth/auth.validators.dart'
    show AuthValidators;
import 'package:boo_mondai/lib.barrel.dart'
    show
        showGuestMergeDialog,
        LoadingIndicator,
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
    hide FormField, TextField, Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final auth = context.watch<AuthController>();
    final tokens = context.themeTokens<AppTokens>();

    // 1. Initial Focus Effect
    VoidCallback? handleInitFocus() {
      emailFocus.requestFocus();
      return null;
    }

    useEffect(handleInitFocus, const []);

    // 2. Action-Driven Sign In (Navigation is handled entirely by routes.dart!)
    Future<void> performSignIn() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      await auth.signIn(emailController.text.trim(), passwordController.text);

      if (!context.mounted) return;

      // If the sign-in resulted in a pending merge, show the dialog.
      // Otherwise, GoRouter will automatically redirect them to '/'
      if (auth.hasPendingGuestMerge) {
        await showGuestMergeDialog(context: context, auth: auth);
      }
    }

    void navigateToRegister() {
      context.push('/register');
    }

    return Scaffold(
      appBar: AppBar(title: 'Login'),
      body: Form(
        key: formKey,
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
                    onSubmitted: (_) => performSignIn(),
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
              onPressed: auth.isLoading ? null : performSignIn,
              child: auth.isLoading
                  ? const LoadingIndicator()
                  : const Text('Sign In'),
            ),
            Button(
              style: buttonStyle.resolve(
                context.themeTokens<AppTokens>(),
                const [ButtonColor.primary, ButtonVariant.flat],
              ),
              onPressed: navigateToRegister,
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
