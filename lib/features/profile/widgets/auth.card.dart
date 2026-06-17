import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        AppTokens,
        AppleSignInButton,
        AuthService,
        Button,
        ButtonVariant,
        ButtonColor,
        GoogleSignInButton,
        LabeledDivider,
        LocalDB,
        Pages,
        showSignOutDialog,
        surfaceStyle,
        textStyle,
        TextSize,
        SurfaceBorder,
        SurfaceShape;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        CrossAxisAlignment,
        Expanded,
        Icon,
        Icons,
        MainAxisAlignment,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        Widget,
        TextAlign;
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
            variants: const [ButtonVariant.soft, ButtonColor.error],
            onPressed: () => showSignOutDialog(context),
            leading: const Icon(Icons.logout),
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    }

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceBorder.none,
        SurfaceShape.roundedSm,
      ]),
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Save Your Progress',
            style: textStyle.resolve(tokens, const [TextSize.header2]),
            textAlign: TextAlign.center,
          ),
          Text(
            'Create an account to sync your FSRS flashcards across all devices and secure your streak.',
            style: textStyle.resolve(tokens, const []),
            textAlign: TextAlign.center,
          ),
          const GoogleSignInButton(),
          const AppleSignInButton(),
          const LabeledDivider(label: 'Or'),
          Row(
            spacing: tokens.spaceLayoutGapMd,
            children: [
              Expanded(
                child: Button(
                  variants: const [ButtonVariant.soft, ButtonColor.hard],
                  onPressed: () => context.push(Pages.login.url),
                  child: const Text('LOG IN'),
                ),
              ),
              Expanded(
                child: Button(
                  variants: const [ButtonVariant.filled, ButtonColor.primary],
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
