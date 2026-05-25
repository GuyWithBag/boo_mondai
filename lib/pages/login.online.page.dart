import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
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
    final passwordFocus = useFocusNode();
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final auth = context.watch<AuthController>();

    // 1. Initial Focus Effect
    VoidCallback? handleInitFocus() {
      emailFocus.requestFocus();
      return null;
    }

    useEffect(handleInitFocus, const []);

    // 2. Action-Driven Sign In (Navigation is handled entirely by routes.dart!)
    Future<void> performSignIn() async {
      emailError.value = _validateEmail(emailController.text);
      passwordError.value = _validatePassword(passwordController.text);
      if (emailError.value != null || passwordError.value != null) return;

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
      appBar: AppBar(leading: const TactileBackButton(), leadingWidth: 100),
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
                    'BooMondai',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _AuthField(
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
                  _AuthField(
                    label: 'Password',
                    controller: passwordController,
                    focusNode: passwordFocus,
                    placeholder: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    error: passwordError.value,
                    onSubmitted: (_) => performSignIn(),
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ErrorText(auth.error),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  TactileButton(
                    tone: TactileTone.filled,
                    onPressed: auth.isLoading ? null : performSignIn,
                    child: auth.isLoading
                        ? const LoadingIndicator()
                        : const Text('Sign In'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TactileButton(
                    tone: TactileTone.text,
                    depth: TactileDepth.flat,
                    onPressed: navigateToRegister,
                    child: const Text("Don't have an account? Sign Up"),
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

// ── Screen-local widgets ─────────────────────────────────────────────────────

class _AuthField extends StatelessWidget {
  const _AuthField({
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
            AppTextFieldSize.normal,
            AppTextFieldFrame.outline,
            AppTextFieldTone.neutral,
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
