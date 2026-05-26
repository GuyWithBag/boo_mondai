// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/participants_tab.dart
// PURPOSE: Tab displaying enrolled research participants
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show ResearchProfile, EmptyStateWidget, Profile, AppSpacing, RemoteDB;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ParticipantsTab extends StatelessWidget {
  final List<ResearchProfile> participants;

  const ParticipantsTab({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.people_outline,
        title: 'No participants enrolled',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: participants.length,
      itemBuilder: (context, i) {
        return HookBuilder(
          builder: (context) {
            final p = participants[i];
            final useProfile = useMemoized<Future<Profile?>>(() async {
              return await RemoteDB.profile.selectOne(
                filters: {'id': p.userId},
              );
            }, []);

            final profile = useFuture<Profile?>(useProfile);
            final name = profile.hasData ? profile.data!.username : 'null';
            final shortId = p.userId.length > 8
                ? '${p.userId.substring(0, 8)}…'
                : p.userId;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
                ),
                title: Text(name),
                subtitle: SelectableText(
                  '$shortId · ${p.role.replaceAll('_', ' ')} · ${p.goal}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
