import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AuthController, Controller, Pages;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class LoginController extends Controller {
  LoginController({
    required AuthController authController,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.formKey,
  }) : _authController = authController {
    _authController.addListener(notifyListeners);
  }

  final AuthController _authController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final GlobalKey<FormState> formKey;

  @override
  bool get isLoading => _authController.isLoading;

  @override
  Exception? get error => _authController.error;

  void requestInitialFocus() {
    emailFocus.requestFocus();
  }

  Future<void> signIn(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final response = await _authController.signIn(
      context,
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!context.mounted) return;

    if (response.profile == null) return;

    if (response.needsMerge) {
      final isMergeResolved = await _authController.showPendingGuestMerge(
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

  @override
  void dispose() {
    _authController.removeListener(notifyListeners);
    super.dispose();
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
  useListenable(controller);
  useEffect(() {
    controller.requestInitialFocus();
    return null;
  }, [controller]);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
