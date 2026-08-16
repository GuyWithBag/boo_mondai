import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AuthController, Controller, Pages;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends Controller {
  RegisterController({
    required AuthController authController,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.nameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.formKey,
  }) : _authController = authController {
    _authController.addListener(notifyListeners);
  }

  final AuthController _authController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final GlobalKey<FormState> formKey;

  @override
  bool get isLoading => _authController.isLoading;

  @override
  Exception? get error => _authController.error;

  void requestInitialFocus() {
    nameFocus.requestFocus();
  }

  Future<void> signUp(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    await _authController.signUp(
      emailController.text.trim(),
      passwordController.text,
      nameController.text.trim(),
    );

    if (!context.mounted) return;

    if (_authController.hasPendingGuestMerge) {
      final isMergeResolved = await _authController.showPendingGuestMerge(
        context: context,
      );
      if (!context.mounted || !isMergeResolved) return;

      showSnackbar(context, message: 'Succesfully registered!');
      context.go(Pages.account.url);
      return;
    }

    showSnackbar(context, message: 'Succesfully registered!');
    context.go(Pages.home.url);
  }

  @override
  void dispose() {
    _authController.removeListener(notifyListeners);
    super.dispose();
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
  useListenable(controller);
  useEffect(() {
    controller.requestInitialFocus();
    return null;
  }, [controller]);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
