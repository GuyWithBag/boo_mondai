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
        ResearchParticipantPortal,
        Scaffold,
        SettingPath,
        SettingsStore,
        AuthCard,
        ViewProfileController,
        showFeatureDisabledModal;
import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart'
    show SnackbarColor, showSnackbar;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart' show ReadContext;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewProfilePage extends SignalHookWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final auth = context.read<AuthController>();
    final pages = Pages.appDetails;
    final isAppDemo = SettingsStore.instance.get<bool>(SettingPath.isAppDemo);

    final controller = useMemoized(() => ViewProfileController());
    final packageInfoFuture = useMemoized(
      () => PackageInfo.fromPlatform(),
      const [],
    );
    final packageInfo = useFuture(packageInfoFuture);
    final packageInfoValue = packageInfo.data;
    final versionText = packageInfoValue == null
        ? null
        : packageInfoValue.buildNumber.isEmpty
        ? 'Version ${packageInfoValue.version}'
        : 'Version ${packageInfoValue.version} (${packageInfoValue.buildNumber})';

    return Scaffold(
      onRefresh: () async {
        await auth.restoreSession();
        if (!context.mounted) return;

        final error = auth.error.value;
        showSnackbar(
          context,
          message: error?.toString() ?? 'Account refreshed',
          color: error == null ? SnackbarColor.success : SnackbarColor.surface,
        );
      },
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileCard(controller: controller),
          const ResearchParticipantPortal(),
          if (auth.currentProfile.value.isResearcher)
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
                  onPressed: isAppDemo && page == Pages.settings
                      ? () => showFeatureDisabledModal(context)
                      : () => context.push(page.url),
                  leading: Icon(page.icon),
                  mainAxisAlignment: MainAxisAlignment.start,
                  child: Text(page.name),
                ),
              ],
            ],
          ),
          if (versionText != null)
            Text(
              versionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: tokens.textSizeLabel,
                fontWeight: tokens.fontWeightTextStrong,
                color: tokens.colorTextMuted,
              ),
            ),
          const AuthCard(),
        ],
      ),
    );
  }
}
