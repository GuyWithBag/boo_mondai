// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/account_page.dart
// PURPOSE: Account page — shared profile header with auth-dependent actions below
// PROVIDERS: AuthController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // ── Profile header (always shown) ─────────────────
            const _ProfileHeader(),
            const SizedBox(height: AppSpacing.xl),

            // ── Auth-dependent actions ────────────────────────
            if (auth.service.isAuthenticatedEither)
              const _AuthenticatedActions()
            else
              const _SignInActions(),
            const SizedBox(height: AppSpacing.md),

            // Kept the Force Sign Out for dev convenience
            TactileButton(
              tone: TactileTone.text,
              depth: TactileDepth.flat,
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

// ── Profile header ──────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    context.watch<AuthController>();
    final profile = LocalDB.profile.getOrCreate();

    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            child: Text(
              profile.username.isNotEmpty
                  ? profile.username[0].toUpperCase()
                  : '?',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Text(
            profile.username,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [Chip(label: Text(profile.role ?? ''))],
          ),
        ),
      ],
    );
  }
}

// ── Authenticated actions ───────────────────────────────────────────────────

class _AuthenticatedActions extends StatelessWidget {
  const _AuthenticatedActions();

  @override
  Widget build(BuildContext context) {
    final profile = LocalDB.profile.getOrCreate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (profile.role != 'researcher') ...[
          TactileButton(
            onPressed: () => context.push('/research/code'),
            leading: const Icon(Icons.vpn_key),
            child: const Text('Enter Research Code'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        TactileButton(
          tone: TactileTone.error,
          onPressed: () => _showSignOutDialog(context),
          leading: const Icon(Icons.logout),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(context: context, builder: (_) => const _SignOutDialog());
  }
}

// ── Sign-in actions (anonymous users) ───────────────────────────────────────

class _SignInActions extends StatelessWidget {
  const _SignInActions();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sign in to unlock all features',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Create decks, take drills, track your progress, '
            'and compete on the leaderboard.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          TactileButton(
            tone: TactileTone.filled,
            onPressed: () => context.push('/login'),
            child: const Text('Sign In'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TactileButton(
            onPressed: () => context.push('/register'),
            child: const Text('Create Account'),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _OAuthDivider(),
          const SizedBox(height: AppSpacing.lg),
          const _GoogleSignInButton(),
          const SizedBox(height: AppSpacing.sm),
          const _AppleSignInButton(),
        ],
      ),
    );
  }
}

// ── OAuth placeholder buttons ───────────────────────────────────────────────

class _OAuthDivider extends StatelessWidget {
  const _OAuthDivider();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('or sign in with', style: TextStyle(color: color)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return TactileButton(
      onPressed: () async {
        // 1. Trigger the actual browser launch (don't await it yet so we can show the dialog)
        final loginFuture = auth.signInWithGoogle();

        // 2. Check if we are running in Debug Mode AND on a Desktop OS
        final isDesktop =
            !kIsWeb &&
            (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

        if (kDebugMode && isDesktop) {
          // 3. Immediately pop up the Dev input dialog
          final url = await showDialog<String>(
            context: context,
            barrierDismissible: false, // Force them to interact with it
            builder: (context) => const _DevManualLoginDialog(),
          );

          // 4. If they pasted a URL and hit Submit, process it
          if (url != null && url.isNotEmpty) {
            await auth.manualDevSignIn(url);
          }
        }

        // 5. Catch any errors from the original future
        await loginFuture;
      },
      leading: const Icon(Icons.g_mobiledata, size: 24),
      child: const Text('Continue with Google'),
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  const _AppleSignInButton();

  @override
  Widget build(BuildContext context) {
    return TactileButton(
      onPressed: null,
      leading: const Icon(Icons.apple, size: 24),
      child: const Text('Continue with Apple'),
    );
  }
}

// ── Dev Manual Login Dialog ─────────────────────────────────────────────────

class _DevManualLoginDialog extends HookWidget {
  const _DevManualLoginDialog();

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spacePanelGapLg),
      child: AppModal(
        tone: AppModalTone.surface,
        leading: const Icon(Icons.link),
        actions: [
          TactileButton(
            tone: TactileTone.ghost,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TactileButton(
            tone: TactileTone.filled,
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
                AppTextFieldSize.normal,
                AppTextFieldFrame.outline,
                AppTextFieldTone.neutral,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sign-out confirmation dialog ────────────────────────────────────────────

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spacePanelGapLg),
      child: AppModal(
        tone: AppModalTone.error,
        leading: const Icon(Icons.logout),
        actions: [
          TactileButton(
            tone: TactileTone.ghost,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TactileButton(
            tone: TactileTone.ghost,
            onPressed: () {
              Navigator.of(context).pop();
              auth.signOut();
            },
            child: const Text('Keep data'),
          ),
          TactileButton(
            tone: TactileTone.error,
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
