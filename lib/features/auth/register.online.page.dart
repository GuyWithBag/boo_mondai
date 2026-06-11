// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/register_page.dart
// PURPOSE: Registration screen for new users
// PROVIDERS: AuthController
// HOOKS: useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        BackButton,
        showGuestMergeDialog,
        AppSpacing,
        ErrorText,
        ButtonTone,
        Button,
        ButtonDepth,
        TextFieldSize,
        TextFieldFrame,
        TextFieldTone,
        VariantTextField;
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    final nameError = useState<String?>(null);
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);

    final auth = context.watch<AuthController>();

    useEffect(() {
      nameFocus.requestFocus();
      return null;
    }, const []);

    Future<void> signUp() async {
      nameError.value = nameController.text.trim().isNotEmpty
          ? null
          : 'Enter a display name';
      emailError.value = emailController.text.contains('@')
          ? null
          : 'Enter a valid email';
      passwordError.value = passwordController.text.length >= 6
          ? null
          : 'Password must be at least 6 characters';

      if (nameError.value != null ||
          emailError.value != null ||
          passwordError.value != null) {
        return;
      }

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
      appBar: AppBar(leading: const BackButton(), leadingWidth: 100),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
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
                  _RegisterField(
                    label: 'Display Name',
                    controller: nameController,
                    focusNode: nameFocus,
                    placeholder: 'Display name',
                    textInputAction: TextInputAction.next,
                    error: nameError.value,
                    onSubmitted: (_) => emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RegisterField(
                    label: 'Email',
                    controller: emailController,
                    focusNode: emailFocus,
                    placeholder: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    error: emailError.value,
                    onSubmitted: (_) => passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RegisterField(
                    label: 'Password',
                    controller: passwordController,
                    focusNode: passwordFocus,
                    placeholder: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    error: passwordError.value,
                    onSubmitted: (_) => signUp(),
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ErrorText(auth.error),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Button(
                    tone: ButtonTone.filled,
                    onPressed: auth.isLoading ? null : signUp,
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign Up'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Button(
                    tone: ButtonTone.text,
                    depth: ButtonDepth.flat,
                    onPressed: () => context.push('/login'),
                    child: const Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.label,
    required this.controller,
    this.focusNode,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.error,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? error;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label),
        const SizedBox(height: AppSpacing.xs),
        VariantTextField(
          controller: controller,
          focusNode: focusNode,
          placeholder: placeholder,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onSubmitted: onSubmitted,
          variants: const [
            TextFieldSize.normal,
            TextFieldFrame.outline,
            TextFieldTone.neutral,
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(error!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
