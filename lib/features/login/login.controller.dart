import 'package:boo_mondai/lib.barrel.dart'
    show AuthController, Controller, Pages;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class LoginController extends Controller {
  LoginController({
    required BuildContext context,
    required AuthController authController,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.formKey,
  }) : _context = context,
       _authController = authController {
    _authController.addListener(notifyListeners);
  }

  final BuildContext _context;
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

  Future<void> signIn() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    await _authController.signIn(
      context: _context,
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!_context.mounted) return;

    if (_authController.hasPendingGuestMerge) {
      final didResolveMerge = await _authController.showPendingGuestMerge(
        context: _context,
      );
      if (!_context.mounted || !didResolveMerge) return;

      _context.go(Pages.account.url);
      return;
    }

    _context.go(Pages.home.url);
  }

  @override
  void dispose() {
    _authController.removeListener(notifyListeners);
    super.dispose();
  }
}

LoginController useLoginController({
  required BuildContext context,
  required AuthController authController,
}) {
  final emailController = useTextEditingController();
  final passwordController = useTextEditingController();
  final emailFocus = useFocusNode();
  final passwordFocus = useFocusNode();
  final formKey = useMemoized(GlobalKey<FormState>.new);
  final controller = useMemoized(
    () => LoginController(
      context: context,
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
