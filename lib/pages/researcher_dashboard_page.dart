// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard_page.dart
// PURPOSE: Researcher dashboard — manage codes, view participants and results
// PROVIDERS: ResearchProvider, AuthProvider
// HOOKS: useEffect, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/research_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';
import 'package:boo_mondai/shared/theme_constants.dart';

class ResearcherDashboardPage extends HookWidget {
  const ResearcherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final research = context.watch<ResearchProvider>();
    final auth = context.read<AuthProvider>();
    final tabIndex = useState(0);

    useEffect(() {
      Future.microtask(
          () => context.read<ResearchProvider>().fetchAllResearchData());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Dashboard'),
      ),
      body: research.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DashboardTabBar(
                  selectedIndex: tabIndex.value,
                  onChanged: (i) => tabIndex.value = i,
                ),
                Expanded(
                  child: IndexedStack(
                    index: tabIndex.value,
                    children: [
                      CodesTab(
                        codes: research.codes,
                        researcherId: auth.userProfile?.id ?? '',
                      ),
                      ParticipantsTab(
                        participants: research.researchUsers,
                      ),
                      ResultsTab(
                        testResults: research.testResults,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class DashboardTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DashboardTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabButton(
          label: 'Codes',
          isSelected: selectedIndex == 0,
          onTap: () => onChanged(0),
        ),
        _TabButton(
          label: 'Participants',
          isSelected: selectedIndex == 1,
          onTap: () => onChanged(1),
        ),
        _TabButton(
          label: 'Results',
          isSelected: selectedIndex == 2,
          onTap: () => onChanged(2),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Codes Tab ───────────────────────────────────────

class CodesTab extends HookWidget {
  final List codes;
  final String researcherId;

  const CodesTab({
    super.key,
    required this.codes,
    required this.researcherId,
  });

  @override
  Widget build(BuildContext context) {
    final roleController = useTextEditingController(text: 'group_a_participant');
    final unlocksController = useTextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Target Role',
                    hintText: 'group_a_participant',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: unlocksController,
                  decoration: const InputDecoration(
                    labelText: 'Unlocks',
                    hintText: 'e.g. vocabulary_test_a',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: () {
                  if (unlocksController.text.trim().isEmpty) return;
                  context.read<ResearchProvider>().generateCode(
                        researcherId,
                        roleController.text.trim(),
                        unlocksController.text.trim(),
                      );
                  unlocksController.clear();
                },
                child: const Text('Generate'),
              ),
            ],
          ),
        ),
        Expanded(
          child: codes.isEmpty
              ? const Center(child: Text('No codes generated yet'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: codes.length,
                  itemBuilder: (context, i) {
                    final code = codes[i];
                    return Card(
                      child: ListTile(
                        title: SelectableText(
                          code.code,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${code.unlocks} · ${code.targetRole}',
                        ),
                        trailing: code.isUsed
                            ? const Chip(
                                label: Text('Used'),
                                backgroundColor: AppColors.correct,
                              )
                            : const Chip(label: Text('Available')),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Participants Tab ────────────────────────────────

class ParticipantsTab extends StatelessWidget {
  final List participants;

  const ParticipantsTab({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Center(child: Text('No participants enrolled'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: participants.length,
      itemBuilder: (context, i) {
        final p = participants[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${i + 1}'),
            ),
            title: Text(p.userId),
            subtitle: Text('${p.role} · ${p.targetLanguage}'),
          ),
        );
      },
    );
  }
}

// ── Results Tab ─────────────────────────────────────

class ResultsTab extends StatelessWidget {
  final List testResults;

  const ResultsTab({super.key, required this.testResults});

  @override
  Widget build(BuildContext context) {
    if (testResults.isEmpty) {
      return const Center(child: Text('No test results yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: testResults.length,
      itemBuilder: (context, i) {
        final r = testResults[i];
        return Card(
          child: ListTile(
            title: Text('Set ${r.testSet} — ${r.score}/30'),
            subtitle: Text('User: ${r.userId}'),
            trailing: Text(
              '${(r.scorePercent * 100).round()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: r.scorePercent >= 0.7
                    ? AppColors.correct
                    : AppColors.incorrect,
              ),
            ),
          ),
        );
      },
    );
  }
}
