// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/vocabulary_test_page.dart
// PURPOSE: Multiple-choice vocabulary test (30 items, A/B/C/D)
// PROVIDERS: ResearchProvider, AuthProvider
// HOOKS: useScrollController, useMemoized
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class VocabularyTestPage extends HookWidget {
  const VocabularyTestPage({super.key, required this.testSet});

  final String testSet;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final research = context.watch<ResearchProvider>();
    final auth = context.read<AuthProvider>();
    final items = useMemoized(() => buildTestItems(testSet), [testSet]);
    final answers = useState(<String, String>{});
    final submitted = useState(false);
    final score = useState(0);

    bool isAllAnswered() => answers.value.length == items.length;

    Future<void> submit() async {
      final userId = auth.userProfile?.id;
      if (userId == null) return;

      // Calculate score
      int correct = 0;
      for (final item in items) {
        if (answers.value[item.id] == item.correctOption) {
          correct++;
        }
      }
      score.value = correct;

      await context.read<ResearchProvider>().submitVocabularyTest(
        userId,
        testSet,
        correct,
        Map<String, dynamic>.from(answers.value),
      );

      if (context.mounted) {
        submitted.value = true;
      }
    }

    if (submitted.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test Complete')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 64,
                color: AppColors.correct,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Score: ${score.value} / ${items.length}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Vocabulary Test — Set $testSet')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: LinearProgressIndicator(
                    value: items.isEmpty
                        ? 0
                        : answers.value.length / items.length,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return VocabTestItem(
                        index: i + 1,
                        item: item,
                        selectedOption: answers.value[item.id],
                        onSelected: (option) {
                          answers.value = {...answers.value, item.id: option};
                        },
                      );
                    },
                  ),
                ),
                if (research.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: ErrorText(research.error!),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isAllAnswered() && !research.isLoading
                          ? submit
                          : null,
                      child: research.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              '${answers.value.length}/${items.length} answered — Submit',
                            ),
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
