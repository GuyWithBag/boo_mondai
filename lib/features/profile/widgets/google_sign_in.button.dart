import 'dart:io' show Platform;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AuthController,
        Button,
        ButtonTone,
        Modal,
        AppModalTone,
        textStyle,
        TextSize,
        TextWeight,
        TextFieldSize,
        TextFieldFrame,
        TextFieldTone,
        VariantTextField;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        EdgeInsets,
        Icons,
        showDialog,
        Icon,
        Text,
        Dialog,
        Colors,
        Navigator,
        MainAxisSize,
        CrossAxisAlignment,
        TextAlign,
        SizedBox,
        TextInputType,
        TextInputAction,
        Column;
import 'package:flutter_hooks/flutter_hooks.dart'
    show HookWidget, useTextEditingController;
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return Button(
      variants: const [ButtonTone.google],
      leading: Icon(Icons.g_mobiledata),
      child: Text('CONTINUE WITH GOOGLE'),
      onPressed: () async {
        final loginFuture = auth.signInWithGoogle();
        final isDesktop =
            !kIsWeb &&
            (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

        if (kDebugMode && isDesktop) {
          final url = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const _DevManualLoginDialog(),
          );

          if (url != null && url.isNotEmpty) {
            await auth.manualDevSignIn(url);
          }
        }

        await loginFuture;
      },
    );
  }
}

class _DevManualLoginDialog extends HookWidget {
  const _DevManualLoginDialog();

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spaceLayoutGapLg),
      child: Modal(
        tone: AppModalTone.surface,
        leading: const Icon(Icons.link),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            variants: const [ButtonTone.filled],
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Submit Code'),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dev Auth Redirect',
              textAlign: TextAlign.center,
              style: textStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapMd),
            VariantTextField(
              controller: controller,
              placeholder: 'http://127.0.0.1:3000/?code=...',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => Navigator.of(context).pop(controller.text),
              variants: const [
                TextFieldSize.normal,
                TextFieldFrame.outline,
                TextFieldTone.neutral,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
