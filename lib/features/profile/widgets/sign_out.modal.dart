import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        AppTokens,
        AppModalTone,
        ButtonTone,
        Button,
        LocalDB,
        textStyle,
        TextSize,
        TextWeight,
        TextTone,
        Modal;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        showDialog,
        BuildContext,
        Widget,
        Icon,
        Text,
        Colors,
        EdgeInsets,
        Icons,
        Navigator,
        MainAxisSize,
        TextAlign,
        SizedBox,
        Column,
        Dialog;
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

void showSignOutDialog(BuildContext context) {
  showDialog<void>(context: context, builder: (_) => const SignOutDialog());
}

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spaceLayoutGapLg),
      child: Modal(
        tone: AppModalTone.error,
        leading: const Icon(Icons.logout),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            onPressed: () {
              Navigator.of(context).pop();
              auth.signOut();
            },
            child: const Text('Keep data'),
          ),
          Button(
            variants: const [ButtonTone.error],
            onPressed: () async {
              Navigator.of(context).pop();
              await auth.signOut();
              await LocalDB.clearAll();
            },
            child: const Text('Remove data'),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sign Out',
              textAlign: TextAlign.center,
              style: textStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            Text(
              'Keep your local data on this device, or remove it after signing out.',
              textAlign: TextAlign.center,
              style: textStyle.resolve(tokens, const [
                TextSize.label,
                TextWeight.body,
                TextTone.secondary,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
