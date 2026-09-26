import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart' show AuthController, Pages;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

class RegisterController {
  RegisterController({
    required AuthController authController,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.nameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.formKey,
  }) : authController = authController {
    isLoading = computed(() => authController.isLoading.value);
    error = computed(() => authController.error.value);
  }

  final AuthController authController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final GlobalKey<FormState> formKey;
  late final Computed<bool> isLoading;
  late final Computed<Exception?> error;

  void requestInitialFocus() {
    nameFocus.requestFocus();
  }

  Future<void> signUp(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final response = await authController.signUp(
      context,
      email: emailController.text.trim(),
      password: passwordController.text,
      username: nameController.text.trim(),
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
        message: 'Succesfully registered and merge resolved!',
      );
      context.go(Pages.account.url);
      return;
    }

    showSnackbar(context, message: 'Succesfully registered!');
    context.go(Pages.account.url);
  }

  void dispose() {
    error.dispose();
    isLoading.dispose();
  }
}

RegisterController useRegisterController({
  required AuthController authController,
}) {
  final nameController = useTextEditingController();
  final emailController = useTextEditingController();
  final passwordController = useTextEditingController();
  final nameFocus = useFocusNode();
  final emailFocus = useFocusNode();
  final passwordFocus = useFocusNode();
  final formKey = useMemoized(GlobalKey<FormState>.new);
  final controller = useMemoized(
    () => RegisterController(
      authController: authController,
      nameController: nameController,
      emailController: emailController,
      passwordController: passwordController,
      nameFocus: nameFocus,
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
