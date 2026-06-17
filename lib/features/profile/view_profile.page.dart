// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/profile/view_profile.page.dart
// PURPOSE: Account page with profile, auth, theme toggle, and app detail actions
// PROVIDERS: AuthController
// HOOKS: dev auth dialog only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/profile/widgets/auth.card.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, Pages, DarkModeToggleCard, ProfileCard;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final pages = Pages.appDetails;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: tokens.spaceScaffoldMaxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.all(tokens.spaceLayoutPadding),
                child: Column(
                  spacing: tokens.spaceLayoutGapMd,
                  children: [
                    const ProfileCard(),
                    const AuthCard(),
                    const DarkModeToggleCard(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: tokens.spaceLayoutGapMd,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
