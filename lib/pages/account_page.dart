// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/account_page.dart
// PURPOSE: Account page — shared profile header with auth-dependent actions below
// PROVIDERS: AuthController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final isAuthenticated = auth.service.isAuthenticated;

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
            if (!isAuthenticated)
              const _SignInActions()
            else
              const _AuthenticatedActions(),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () async {
                await context.read<AuthController>().signOut();
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
            children: [Chip(label: Text(profile.role.replaceAll('_', ' ')))],
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (profile.role != 'researcher') ...[
          OutlinedButton.icon(
            onPressed: () => context.push('/research/code'),
            icon: const Icon(Icons.vpn_key),
            label: const Text('Enter Research Code'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        OutlinedButton.icon(
          onPressed: () => _showSignOutDialog(context),
          icon: Icon(Icons.logout, color: colorScheme.error),
          label: Text('Sign Out', style: TextStyle(color: colorScheme.error)),
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
          FilledButton(
            onPressed: () => context.push('/login'),
            child: const Text('Sign In'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
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
    return OutlinedButton.icon(
      onPressed: null,
      icon: const Icon(Icons.g_mobiledata, size: 24),
      label: const Text('Continue with Google'),
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  const _AppleSignInButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: null,
      icon: const Icon(Icons.apple, size: 24),
      label: const Text('Continue with Apple'),
    );
  }
}

// ── Sign-out confirmation dialog ────────────────────────────────────────────

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text(
        'Would you like to keep your local data after signing out, '
        'or remove it from this device?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
            auth.signOut();
          },
          child: const Text('Sign out & keep data'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            auth.signOut();
            LocalDB.clearAll();
          },
          child: const Text('Sign out & remove data'),
        ),
      ],
    );
  }
}
