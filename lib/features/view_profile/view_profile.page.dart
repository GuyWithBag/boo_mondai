// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/profile/view_profile.page.dart
// PURPOSE: Account page with profile, auth, theme toggle, and app detail actions
// PROVIDERS: AuthController
// HOOKS: dev auth dialog only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AuthController,
        Button,
        Pages,
        DarkModeToggleCard,
        ProfileCard,
        Scaffold,
        AuthCard;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final auth = context.watch<AuthController>();
    final pages = Pages.appDetails;

    return Scaffold(
      // resizeBodyForKeyboard: false,
      // materialResizeToAvoidBottomInset: true,
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileCard(),
          if (auth.currentProfile.isResearcher)
            Button(
              leading: const Icon(Icons.science_outlined),
              onPressed: () => context.push(Pages.researcherDashboard.url),
              mainAxisAlignment: MainAxisAlignment.start,
              child: const Text('Researcher Dashboard'),
            ),
          const DarkModeToggleCard(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: tokens.spaceLayoutGapSm,
            children: [
              for (final page in pages) ...[
                Button(
                  onPressed: () => context.push(page.url),
                  leading: Icon(page.icon),
                  mainAxisAlignment: MainAxisAlignment.start,
                  child: Text(page.name),
                ),
              ],
            ],
          ),
          const AuthCard(),
        ],
      ),
    );
  }
}
