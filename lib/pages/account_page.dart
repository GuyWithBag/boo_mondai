// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/account_page.dart
// PURPOSE: Account page — login/register when unauthenticated, profile when authenticated
// PROVIDERS: AuthProvider, StreakProvider
// HOOKS: useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/streak_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';

class AccountPage extends HookWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isAuthenticated) {
      return const UnauthenticatedAccountView();
    }

    return AuthenticatedAccountView(auth: auth);
  }
}

class UnauthenticatedAccountView extends StatelessWidget {
  const UnauthenticatedAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Sign in to unlock all features',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Create decks, take quizzes, track your progress, and compete on the leaderboard.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthenticatedAccountView extends StatelessWidget {
  final AuthProvider auth;

  const AuthenticatedAccountView({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    final streakProv = context.watch<StreakProvider>();
    final profile = auth.userProfile!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              child: Text(
                profile.displayName.isNotEmpty
                    ? profile.displayName[0].toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              profile.displayName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Center(
            child: Text(
              profile.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Wrap(
              spacing: AppSpacing.sm,
              children: [
                Chip(label: Text(profile.role.replaceAll('_', ' '))),
                if (profile.targetLanguage != null)
                  Chip(label: Text(profile.targetLanguage!)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${streakProv.currentStreak}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Current Streak',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${streakProv.longestStreak}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Longest Streak',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => context.go('/research/code'),
            icon: const Icon(Icons.vpn_key),
            label: const Text('Enter Research Code'),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
            },
            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            label: Text(
              'Sign Out',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
