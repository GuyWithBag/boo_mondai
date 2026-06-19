// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/profile/view_profile.page.dart
// PURPOSE: Account page with profile, auth, theme toggle, and app detail actions
// PROVIDERS: AuthController
// HOOKS: dev auth dialog only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        Pages,
        DarkModeToggleCard,
        ProfileCard,
        Scaffold,
        AuthCard;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final pages = Pages.appDetails;

    return Scaffold(
      body: Column(
        spacing: tokens.spaceLayoutGapSm,
        children: [
          const ProfileCard(),
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
          SizedBox(height: tokens.spaceLayoutGapXsm.h),
          const AuthCard(),
        ],
      ),
    );
  }
}
