import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart' show AuthController, Pages;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

class LoginController {
  LoginController({
    required AuthController authController,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.formKey,
  }) : authController = authController {
    isLoading = computed(() => authController.isLoading.value);
    error = computed(() => authController.error.value);
  }

  final AuthController authController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final GlobalKey<FormState> formKey;
  late final Computed<bool> isLoading;
  late final Computed<Exception?> error;

  void requestInitialFocus() {
    emailFocus.requestFocus();
  }

  Future<void> signIn(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final response = await authController.signIn(
      context,
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!context.mounted) return;

    if (response.profile == null) return;

    if (response.needsMerge) {
      final isMergeResolved = await authController.showPendingGuestMerge(
        context,
        authServiceResponse: response,
      );
      if (!context.mounted || !isMergeResolved) return;

      showSnackbar(
        context,
        message: 'Succesfully logged in and merge resolved!',
      );
      context.go(Pages.account.url);
      return;
    }
    showSnackbar(context, message: 'Succesfully logged in!');
    context.go(Pages.account.url);
  }

  void dispose() {
    error.dispose();
    isLoading.dispose();
  }
}

LoginController useLoginController({required AuthController authController}) {
  final emailController = useTextEditingController();
  final passwordController = useTextEditingController();
  final emailFocus = useFocusNode();
  final passwordFocus = useFocusNode();
  final formKey = useMemoized(GlobalKey<FormState>.new);
  final controller = useMemoized(
    () => LoginController(
      authController: authController,
      emailController: emailController,
      passwordController: passwordController,
      emailFocus: emailFocus,
      passwordFocus: passwordFocus,
      formKey: formKey,
    ),
    [authController],
  );
  useEffect(() {
    controller.requestInitialFocus();
    return null;
  }, [controller]);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
