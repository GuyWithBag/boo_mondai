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
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/research_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';
import 'package:boo_mondai/widgets/likert_scale_widget.dart';

class SurveyPage extends HookWidget {
  const SurveyPage({super.key, required this.surveyType, this.timePoint});

  final String surveyType;
  final String? timePoint;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final research = context.watch<ResearchProvider>();
    final auth = context.read<AuthProvider>();
    final questions = useMemoized(() => _buildQuestions(surveyType), [surveyType]);
    final responses = useState(<String, int>{});
    final proficiencyLevel = useState<String?>(null);
    final submitted = useState(false);

    final isProficiency = surveyType == 'proficiency_screener';
    final isSus = surveyType == 'sus';

    bool isAllAnswered() {
      final allLikert = questions.every((q) => responses.value.containsKey(q.key));
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
        appBar: AppBar(title: Text(_surveyTitle(surveyType))),
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
      appBar: AppBar(title: Text(_surveyTitle(surveyType))),
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
                          responses.value = {
                            ...responses.value,
                            q.key: v,
                          };
                        },
                      );
                    },
                  ),
                ),
                if (research.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      research.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          isAllAnswered() && !research.isLoading ? submit : null,
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

class ProficiencyLevelSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const ProficiencyLevelSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _levels = [
    ('none', 'None — I have no prior knowledge'),
    ('beginner', 'Beginner — I know a few words or phrases'),
    ('elementary', 'Elementary — I can understand basic sentences'),
    ('intermediate', 'Intermediate — I can hold simple conversations'),
    ('advanced', 'Advanced — I am highly proficient'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is your current proficiency level in your target language?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            RadioGroup<String>(
              groupValue: value,
              onChanged: (v) {
                if (v != null && v.isNotEmpty) onChanged(v);
              },
              child: Column(
                children: ProficiencyLevelSelector._levels
                    .map(
                      (level) => RadioListTile<String>(
                        value: level.$1,
                        title: Text(level.$2),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Survey question data ────────────────────────────────

class _SurveyQuestion {
  final String key;
  final String statement;
  const _SurveyQuestion(this.key, this.statement);
}

List<_SurveyQuestion> _buildQuestions(String surveyType) {
  switch (surveyType) {
    case 'proficiency_screener':
      return const [
        _SurveyQuestion('item_1', 'I can recognize basic vocabulary in my target language (e.g. greetings, numbers)'),
        _SurveyQuestion('item_2', 'I can read simple sentences in my target language'),
        _SurveyQuestion('item_3', 'I can understand basic written instructions in my target language'),
        _SurveyQuestion('item_4', 'I have formally studied this language before (class, course, or program)'),
        _SurveyQuestion('item_5', 'I interact with this language regularly (media, work, travel, or cultural exposure)'),
        _SurveyQuestion('item_6', 'I have used a language learning app before (e.g. Duolingo, Anki, Memrise)'),
      ];
    case 'language_interest':
      return const [
        _SurveyQuestion('item_1', 'I am genuinely interested in learning my target language'),
        _SurveyQuestion('item_2', 'I am motivated to improve my proficiency in this language'),
        _SurveyQuestion('item_3', 'Learning this language is important to my personal or professional goals'),
        _SurveyQuestion('item_4', 'I enjoy consuming content in this language (music, film, books, etc.)'),
        _SurveyQuestion('item_5', 'I plan to continue studying this language after this study'),
      ];
    case 'experience_survey':
      return const [
        // Enjoyment
        _SurveyQuestion('enjoyment_1', 'I feel genuinely having fun'),
        _SurveyQuestion('enjoyment_2', 'I feel happy when using the platform'),
        _SurveyQuestion('enjoyment_3', 'I feel that it is great for killing time productively'),
        _SurveyQuestion('enjoyment_4', 'I feel exhausted when using it'),
        _SurveyQuestion('enjoyment_5', 'I feel miserable when using it'),
        // Engagement
        _SurveyQuestion('engagement_1', 'I wanted to explore all the options because it was very challenging'),
        _SurveyQuestion('engagement_2', 'I felt that time passed quickly'),
        _SurveyQuestion('engagement_3', 'I wanted to complete the session'),
        _SurveyQuestion('engagement_4', 'I did not care how the session ended'),
        _SurveyQuestion('engagement_5', 'I felt bored during the session'),
        // Motivation
        _SurveyQuestion('motivation_1', 'It was important to me to do well at this task'),
        _SurveyQuestion('motivation_2', 'I would describe this activity as very interesting'),
        _SurveyQuestion('motivation_3', 'I tried very hard on this activity'),
        _SurveyQuestion('motivation_4', 'I did not try very hard to do well at this activity'),
        _SurveyQuestion('motivation_5', 'I did not put much energy into this'),
      ];
    case 'preview_usefulness':
      return const [
        _SurveyQuestion('item_1', 'Previewing the vocabulary before the quiz helped me feel prepared'),
        _SurveyQuestion('item_2', 'The preview feature reduced my anxiety during the quiz'),
        _SurveyQuestion('item_3', 'I would choose to use the preview feature again in future sessions'),
        _SurveyQuestion('item_4', 'The preview made it easier to recall vocabulary during the quiz'),
        _SurveyQuestion('item_5', 'I would recommend the preview feature to other learners'),
      ];
    case 'fsrs_usefulness':
      return const [
        _SurveyQuestion('item_1', 'The review reminders helped me remember vocabulary better'),
        _SurveyQuestion('item_2', 'The Again/Hard/Good/Easy rating system felt accurate to my recall'),
        _SurveyQuestion('item_3', 'I felt the review sessions were worth my time'),
        _SurveyQuestion('item_4', 'The spaced review sessions helped me retain vocabulary longer'),
        _SurveyQuestion('item_5', 'I would continue using the FSRS review deck after this study'),
      ];
    case 'ugc_perception':
      return const [
        _SurveyQuestion('item_1', 'I would find it useful to create my own quiz decks for vocabulary I want to learn'),
        _SurveyQuestion('item_2', 'Creating my own flashcard content would help me understand the material better'),
        _SurveyQuestion('item_3', 'I would use a feature that allows me to build my own study decks'),
        _SurveyQuestion('item_4', 'I would find it helpful to access quiz decks created by other learners'),
        _SurveyQuestion('item_5', 'Using community-made decks would save me time in preparing study materials'),
        _SurveyQuestion('item_6', 'A platform where I can create and use other learners\' content would be more motivating than studying alone'),
      ];
    case 'sus':
      return const [
        _SurveyQuestion('item_1', 'I think that I would like to use this system frequently'),
        _SurveyQuestion('item_2', 'I found the system unnecessarily complex'),
        _SurveyQuestion('item_3', 'I thought the system was easy to use'),
        _SurveyQuestion('item_4', 'I think that I would need the support of a technical person to be able to use this system'),
        _SurveyQuestion('item_5', 'I found the various functions in this system were well integrated'),
        _SurveyQuestion('item_6', 'I thought there was too much inconsistency in this system'),
        _SurveyQuestion('item_7', 'I would imagine that most people would learn to use this system very quickly'),
        _SurveyQuestion('item_8', 'I found the system very cumbersome to use'),
        _SurveyQuestion('item_9', 'I felt very confident using the system'),
        _SurveyQuestion('item_10', 'I needed to learn a lot of things before I could get going with this system'),
      ];
    default:
      return const [];
  }
}

String _surveyTitle(String surveyType) {
  switch (surveyType) {
    case 'proficiency_screener':
      return 'Proficiency Screener';
    case 'language_interest':
      return 'Language Interest';
    case 'experience_survey':
      return 'Experience Survey';
    case 'preview_usefulness':
      return 'Preview Usefulness';
    case 'fsrs_usefulness':
      return 'FSRS Usefulness';
    case 'ugc_perception':
      return 'User-Generated Content';
    case 'sus':
      return 'System Usability Scale';
    default:
      return 'Survey';
  }
}
