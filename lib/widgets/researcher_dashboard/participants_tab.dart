// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/participants_tab.dart
// PURPOSE: Tab displaying enrolled research participants
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ParticipantsTab extends StatelessWidget {
  final List<ResearchUser> participants;

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
        final p = participants[i];
        final name = p.userName ?? 'Unknown';
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
              '$shortId · ${p.role.replaceAll('_', ' ')} · ${p.targetLanguage}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
    );
  }
}
