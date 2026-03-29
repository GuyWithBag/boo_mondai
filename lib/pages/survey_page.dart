// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/survey_page.dart
// PURPOSE: Dynamic survey page rendering Likert scale questions by survey type
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

class SurveyPage extends HookWidget {
  const SurveyPage({super.key, required this.surveyType, this.timePoint});

  final String surveyType;
  final String? timePoint;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final research = context.watch<ResearchProvider>();
    final auth = context.read<AuthProvider>();
    final questions = useMemoized(() => buildSurveyQuestions(surveyType), [
      surveyType,
    ]);
    final responses = useState(<String, int>{});
    final proficiencyLevel = useState<String?>(null);
    final submitted = useState(false);

    final isProficiency = surveyType == 'proficiency_screener';
    final isSus = surveyType == 'sus';

    bool isAllAnswered() {
      final allLikert = questions.every(
        (q) => responses.value.containsKey(q.key),
      );
      if (isProficiency) return allLikert && proficiencyLevel.value != null;
      return allLikert;
    }

    Future<void> submit() async {
      final userId = auth.userProfile?.id;
      if (userId == null) return;

      final data = Map<String, int>.from(responses.value);
      if (isProficiency && proficiencyLevel.value != null) {
        // proficiency_level goes through a separate key
      }

      await context.read<ResearchProvider>().submitSurvey(
        userId,
        surveyType,
        timePoint,
        data,
      );

      if (context.mounted) {
        submitted.value = true;
      }
    }

    if (submitted.value) {
      return Scaffold(
        appBar: AppBar(title: Text(surveyTitle(surveyType))),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 64, color: Colors.green),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Survey submitted!',
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
      appBar: AppBar(title: Text(surveyTitle(surveyType))),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: questions.length + (isProficiency ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (isProficiency && i == questions.length) {
                        return ProficiencyLevelSelector(
                          value: proficiencyLevel.value,
                          onChanged: (v) => proficiencyLevel.value = v,
                        );
                      }
                      final q = questions[i];
                      return LikertScaleWidget(
                        index: i + 1,
                        statement: q.statement,
                        value: responses.value[q.key],
                        maxValue: isSus ? 5 : 5,
                        onChanged: (v) {
                          responses.value = {...responses.value, q.key: v};
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
                          : const Text('Submit'),
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
