// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/codes_tab.dart
// PURPOSE: Tab displaying research codes with generation form and list
// PROVIDERS: ResearchProvider
// HOOKS: useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class CodesTab extends HookWidget {
  final List codes;
  final String researcherId;

  const CodesTab({super.key, required this.codes, required this.researcherId});

  @override
  Widget build(BuildContext context) {
    final roleController = useTextEditingController(
      text: 'group_a_participant',
    );
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
              ? const EmptyStateWidget(
                  icon: Icons.vpn_key_outlined,
                  title: 'No codes generated yet',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
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
                        subtitle: Text('${code.unlocks} · ${code.targetRole}'),
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
