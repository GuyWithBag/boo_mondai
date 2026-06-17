import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        AppTokens,
        AppleSignInButton,
        AuthService,
        Button,
        ButtonTone,
        GoogleSignInButton,
        LabeledDivider,
        LocalDB,
        Pages,
        showSignOutDialog;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        SizedBox,
        Text,
        Icon,
        CrossAxisAlignment,
        Expanded,
        Row,
        Column,
        Icons;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

class AuthCard extends StatelessWidget {
  const AuthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final profile = LocalDB.profile.getOrCreate();

    if (AuthService.isAuthenticatedEither) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (profile.role != 'researcher') ...[
            Button(
              onPressed: () => context.push(Pages.researchCode.url),
              leading: const Icon(Icons.vpn_key_outlined),
              child: const Text('ENTER RESEARCH CODE'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Button(
            variants: const [ButtonTone.error],
            onPressed: () => showSignOutDialog(context),
            leading: const Icon(Icons.logout),
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    }

    return Surface(
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Save Your Progress'),
          Text(
            'Create an account to sync your FSRS flashcards across all devices and secure your streak.',
          ),
          const GoogleSignInButton(),
          const AppleSignInButton(),
          const LabeledDivider(label: 'Or'),
          Row(
            spacing: tokens.spaceLayoutGapMd,
            children: [
              Expanded(
                child: Button(
                  variants: const [ButtonTone.hard],
                  onPressed: () => context.push(Pages.login.url),
                  child: const Text('LOG IN'),
                ),
              ),
              Expanded(
                child: Button(
                  variants: const [ButtonTone.filled],
                  onPressed: () => context.push(Pages.register.url),
                  child: const Text('REGISTER'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
