import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AppleSignInButton,
        AuthController,
        Button,
        ButtonColor,
        GoogleSignInButton,
        LabeledDivider,
        Pages,
        surfaceStyle,
        textStyle,
        TextSize,
        SurfaceBorder,
        SurfaceShape,
        SurfaceShadow;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart' show WatchContext;
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

class AuthCard extends StatelessWidget {
  const AuthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final auth = context.watch<AuthController>();
    // final viewProfile = context.watch<ViewProfileController>();
    // final profile = viewProfile.currentProfile;

    if (auth.isAuthenticatedEither) {
      return Column(
        spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (profile.role != 'researcher') ...[
          //   Button(
          //     onPressed: () => context.push(Pages.researchCode.url),
          //     leading: const Icon(Icons.vpn_key_outlined),
          //     child: const Text('ENTER RESEARCH CODE'),
          //   ),
          // ],
          Button(
            variants: [ButtonColor.error],
            onPressed: () => auth.onSignOutPressed(context),
            leading: auth.isLoading
                ? CircularProgressIndicator()
                : Icon(Icons.logout),
            child: auth.isLoading ? null : Text('Sign Out'),
          ),
        ],
      );
    }

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceBorder.none,
        SurfaceShape.roundedXsm,
        SurfaceShadow.none,
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
                  variants: const [ButtonColor.hard],
                  onPressed: () => context.push(Pages.login.url),
                  child: const Text('LOG IN'),
                ),
              ),
              Expanded(
                child: Button(
                  variants: const [ButtonColor.primary],
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
