// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/profile/view_profile.page.dart
// PURPOSE: Account page with profile, auth, theme toggle, and app detail actions
// PROVIDERS: AuthController
// HOOKS: dev auth dialog only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io' show Platform;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppModalTone,
        AppSpacing,
        AppTokens,
        AuthController,
        Button,
        ButtonDepth,
        ButtonTone,
        EditableTextValue,
        LocalDB,
        Modal,
        Pages,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        TextSize,
        TextTone,
        TextWeight,
        VariantTextField,
        UserSettingsService,
        buttonStyle,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShape,
        SurfaceShadow,
        SurfaceTone,
        surfaceStyle,
        appTextStyle;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/features/profile/widgets/profile_avatar.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const _ProfileCard(),
            const SizedBox(height: AppSpacing.md),
            if (auth.service.isAuthenticatedEither)
              const _SignedInAuthCard()
            else
              const _GuestAuthCard(),
            const SizedBox(height: AppSpacing.md),
            const _DarkModeToggleCard(),
            const SizedBox(height: AppSpacing.md),
            const _AppDetailsCard(),
            const SizedBox(height: AppSpacing.md),
            Button(
              tone: ButtonTone.text,
              depth: ButtonDepth.flat,
              onPressed: () async {
                await auth.signOut();
              },
              child: const Text('[DEV] Force Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final style = surfaceStyle.resolve(tokens, const [
      SurfaceTone.surface,
      SurfaceBorder.normal,
      SurfacePadding.none,
      SurfaceShape.cardShape,
      SurfaceShadow.normal,
    ]);

    return Surface(
      style: style,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final profile = auth.currentProfile;
    final email = auth.currentEmail;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final displayName = profile.displayName.trim().isEmpty
        ? 'Guest User'
        : profile.displayName.trim();
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: scheme.onSurface,
    );
    final detailStyle = theme.textTheme.titleMedium?.copyWith(
      color: scheme.onSurface,
      fontStyle: FontStyle.italic,
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EditableTextValue(
          value: displayName,
          editingValue: profile.displayName,
          placeholder: 'Display name',
          textStyle: titleStyle,
          onSave: auth.updateDisplayName,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text('@${profile.username}', style: detailStyle),
        if (!profile.isAnonymous && email != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(email, style: detailStyle),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Joined at ${_formatShortDate(profile.createdAt)}',
          style: detailStyle,
        ),
      ],
    );

    return _AccountCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ProfileAvatar(
                    displayName: displayName,
                    avatarUrl: profile.avatarUrl,
                    radius: 66,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                details,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                displayName: displayName,
                avatarUrl: profile.avatarUrl,
                radius: 66,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}

class _GuestAuthCard extends StatelessWidget {
  const _GuestAuthCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _AccountCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Save Your Progress',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Create an account to sync your FSRS flashcards across all devices and secure your streak.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _GoogleSignInButton(),
          const SizedBox(height: AppSpacing.sm),
          const _AppleSignInButton(),
          const SizedBox(height: AppSpacing.md),
          const _InlineDivider(label: 'Or'),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Button(
                  tone: ButtonTone.hard,
                  onPressed: () => context.push(Pages.login.url),
                  child: const Text('LOG IN'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Button(
                  tone: ButtonTone.filled,
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

class _SignedInAuthCard extends StatelessWidget {
  const _SignedInAuthCard();

  @override
  Widget build(BuildContext context) {
    final profile = LocalDB.profile.getOrCreate();

    return _AccountCard(
      child: Column(
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
            tone: ButtonTone.error,
            onPressed: () => _showSignOutDialog(context),
            leading: const Icon(Icons.logout),
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(context: context, builder: (_) => const _SignOutDialog());
  }
}

class _DarkModeToggleCard extends StatelessWidget {
  const _DarkModeToggleCard();

  @override
  Widget build(BuildContext context) {
    final controller = context.themeVariantsController<AppTokens>();
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final isDark = switch (controller.themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    final tokens = context.themeTokens<AppTokens>();
    final baseStyle = surfaceStyle.resolve(tokens, const [
      SurfaceTone.surface,
      SurfaceBorder.normal,
      SurfacePadding.none,
      SurfaceShape.cardShape,
      SurfaceShadow.normal,
    ]);
    final style = baseStyle.copyWith(
      decoration: baseStyle.decoration.copyWith(
        color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFF7EC8F5),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
        controller.setThemeMode(nextMode);
        await UserSettingsService.updateThemeMode(
          userId: LocalDB.profile.getOrCreate().id,
          themeMode: nextMode,
        );
      },
      child: Surface(
        style: style,
        child: SizedBox(
          height: 140,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeOutCubic,
                left: isDark ? 12 : 120,
                bottom: -92,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 360),
                  width: 300,
                  height: 220,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFD7D7D7)
                        : const Color(0xFFFFD75A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedRotation(
                      turns: isDark ? 0 : 0.5,
                      duration: const Duration(milliseconds: 360),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF232323)
                              : const Color(0xFFFFD75A),
                        ),
                        child: Icon(
                          isDark
                              ? Icons.nightlight_round
                              : Icons.wb_sunny_rounded,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF4A3B00),
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Text(
                        isDark ? 'Toggle Light Mode' : 'Toggle Dark Mode',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF17324B),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDetailsCard extends StatelessWidget {
  const _AppDetailsCard();

  @override
  Widget build(BuildContext context) {
    final pages = Pages.appDetails;

    return _AccountCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final page in pages) ...[
            Button(
              onPressed: () => context.push(page.url),
              leading: Icon(page.icon ?? Icons.chevron_right_rounded),
              child: Text(page.name.toUpperCase()),
            ),
            if (page != pages.last) const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _InlineDivider extends StatelessWidget {
  const _InlineDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
        const Expanded(child: Divider(thickness: 2)),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final tokens = context.themeTokens<AppTokens>();
    final style = buttonStyle
        .resolve(tokens, const [ButtonTone.filled])
        .copyWith(padding: EdgeInsets.zero, clipBehavior: Clip.antiAlias);

    return _SocialAuthButton(
      style: style,
      icon: Icons.g_mobiledata,
      label: 'CONTINUE WITH GOOGLE',
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

class _AppleSignInButton extends StatelessWidget {
  const _AppleSignInButton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final style = buttonStyle
        .resolve(tokens, const [ButtonTone.filled])
        .copyWith(padding: EdgeInsets.zero, clipBehavior: Clip.antiAlias);

    return _SocialAuthButton(
      style: style,
      icon: Icons.apple,
      label: 'CONTINUE WITH APPLE',
      onPressed: null,
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.style,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final SurfaceStyle style;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onPressed == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Surface(
          style: style,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      insetPadding: EdgeInsets.all(tokens.spacePanelGapLg),
      child: Modal(
        tone: AppModalTone.surface,
        leading: const Icon(Icons.link),
        actions: [
          Button(
            tone: ButtonTone.ghost,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            tone: ButtonTone.filled,
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
              style: appTextStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spacePanelGapMd),
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

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spacePanelGapLg),
      child: Modal(
        tone: AppModalTone.error,
        leading: const Icon(Icons.logout),
        actions: [
          Button(
            tone: ButtonTone.ghost,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Button(
            tone: ButtonTone.ghost,
            onPressed: () {
              Navigator.of(context).pop();
              auth.signOut();
            },
            child: const Text('Keep data'),
          ),
          Button(
            tone: ButtonTone.error,
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
              style: appTextStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spacePanelGapSm),
            Text(
              'Keep your local data on this device, or remove it after signing out.',
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, const [
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

String _formatShortDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
