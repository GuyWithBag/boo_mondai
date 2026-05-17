// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/results_tab.dart
// PURPOSE: Tab displaying research results with charts and metrics
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ResultsTab extends StatelessWidget {
  final List<SurveyResponse> surveyResponses;
  final List<VocabularyTestResult> testResults;

  const ResultsTab({
    super.key,
    required this.surveyResponses,
    required this.testResults,
  });

  /// Extracts response maps for a given survey type and optional time point.
  /// For SUS responses, merges computedScore as 'sus_score' key.
  List<Map<String, dynamic>> _responsesFor(
    String surveyType, {
    String? timePoint,
  }) {
    return surveyResponses
        .where(
          (r) =>
              r.surveyType == surveyType &&
              (timePoint == null || r.timePoint == timePoint),
        )
        .map((r) {
          final map = Map<String, dynamic>.from(r.responses);
          if (r.computedScore != null) map['sus_score'] = r.computedScore;
          return map;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final setA = testResults.where((r) => r.testSet == 'A').toList();
    final setB = testResults.where((r) => r.testSet == 'B').toList();

    final proficiencyData = _responsesFor('proficiency_screener');
    final languageInterestData = _responsesFor('language_interest');
    final expShort = _responsesFor(
      'experience_survey',
      timePoint: 'short_term',
    );
    final expLong = _responsesFor('experience_survey', timePoint: 'long_term');
    final previewUsefulnessData = _responsesFor('preview_usefulness');
    final fsrsUsefulnessData = _responsesFor('fsrs_usefulness');
    final ugcData = _responsesFor('ugc_perception');
    final susData = _responsesFor('sus');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // ── Completion overview ────────────────────────
        SectionCard(
          title: 'Completion Overview',
          child: CompletionMatrix(
            rows: [
              ('Proficiency Screener', proficiencyData.length),
              ('Language Interest', languageInterestData.length),
              ('Vocab Test — Set A', setA.length),
              ('Vocab Test — Set B', setB.length),
              ('Experience Survey (ST)', expShort.length),
              ('Experience Survey (LT)', expLong.length),
              ('Preview Usefulness', previewUsefulnessData.length),
              ('FSRS Usefulness', fsrsUsefulnessData.length),
              ('UGC Perception', ugcData.length),
              ('SUS', susData.length),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Vocabulary tests ───────────────────────────
        SectionCard(
          title: 'Vocabulary Test — Set A  (n = ${setA.length})',
          child: VocabTestChart(results: setA, maxScore: 30),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: 'Vocabulary Test — Set B  (n = ${setB.length})',
          child: VocabTestChart(results: setB, maxScore: 30),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Experience survey ──────────────────────────
        SectionCard(
          title: 'Experience Survey — Short-term  (n = ${expShort.length})',
          child: ExperienceSurveyChart(data: expShort),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: 'Experience Survey — Long-term  (n = ${expLong.length})',
          child: ExperienceSurveyChart(data: expLong),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── SUS ────────────────────────────────────────
        SectionCard(
          title: 'System Usability Scale (SUS)  (n = ${susData.length})',
          child: SusChart(data: susData),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Usefulness surveys ─────────────────────────
        SectionCard(
          title: 'Preview Usefulness  (n = ${previewUsefulnessData.length})',
          child: LikertSurveyChart(data: previewUsefulnessData, itemCount: 5),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: 'FSRS Usefulness  (n = ${fsrsUsefulnessData.length})',
          child: LikertSurveyChart(data: fsrsUsefulnessData, itemCount: 5),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: 'UGC Perception  (n = ${ugcData.length})',
          child: LikertSurveyChart(data: ugcData, itemCount: 6),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
