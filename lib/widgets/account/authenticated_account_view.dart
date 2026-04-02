// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/account/authenticated_account_view.dart
// PURPOSE: Profile display with streak stats and sign-out for authenticated users
// PROVIDERS: AuthProvider, StreakProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class AuthenticatedAccountView extends StatelessWidget {
  final AuthProvider auth;

  const AuthenticatedAccountView({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    // final streakProv = context.watch<StreakProvider>();
    final profile = auth.userProfile!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              child: Text(
                profile.userName.isNotEmpty
                    ? profile.userName[0].toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              profile.userName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          // Center(
          //   child: Text(
          //     profile.email,
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
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
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(AppSpacing.md),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         Column(
          //           children: [
          //             Text(
          //               '${streakProv.currentStreak}',
          //               style: Theme.of(context).textTheme.titleLarge,
          //             ),
          //             Text(
          //               'Current Streak',
          //               style: Theme.of(context).textTheme.bodyMedium,
          //             ),
          //           ],
          //         ),
          //         Column(
          //           children: [
          //             Text(
          //               '${streakProv.longestStreak}',
          //               style: Theme.of(context).textTheme.titleLarge,
          //             ),
          //             Text(
          //               'Longest Streak',
          //               style: Theme.of(context).textTheme.bodyMedium,
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: AppSpacing.md),
          if (profile.role != 'researcher')
            OutlinedButton.icon(
              onPressed: () => context.push('/research/code'),
              icon: const Icon(Icons.vpn_key),
              label: const Text('Enter Research Code'),
            ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
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
