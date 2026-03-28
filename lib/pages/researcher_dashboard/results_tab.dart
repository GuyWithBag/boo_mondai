// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/results_tab.dart
// PURPOSE: Tab displaying research results with charts and metrics
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';
import 'package:boo_mondai/pages/researcher_dashboard/completion_matrix.dart';
import 'package:boo_mondai/pages/researcher_dashboard/vocab_test_chart.dart';
import 'package:boo_mondai/pages/researcher_dashboard/experience_survey_chart.dart';
import 'package:boo_mondai/pages/researcher_dashboard/sus_chart.dart';
import 'package:boo_mondai/pages/researcher_dashboard/likert_survey_chart.dart';

class ResultsTab extends StatelessWidget {
  final List<VocabularyTestResult> testResults;
  final List<Map<String, dynamic>> proficiencyData;
  final List<Map<String, dynamic>> languageInterestData;
  final List<Map<String, dynamic>> experienceSurveyData;
  final List<Map<String, dynamic>> previewUsefulnessData;
  final List<Map<String, dynamic>> fsrsUsefulnessData;
  final List<Map<String, dynamic>> ugcData;
  final List<Map<String, dynamic>> susData;

  const ResultsTab({
    super.key,
    required this.testResults,
    required this.proficiencyData,
    required this.languageInterestData,
    required this.experienceSurveyData,
    required this.previewUsefulnessData,
    required this.fsrsUsefulnessData,
    required this.ugcData,
    required this.susData,
  });

  @override
  Widget build(BuildContext context) {
    final setA = testResults.where((r) => r.testSet == 'A').toList();
    final setB = testResults.where((r) => r.testSet == 'B').toList();
    final expShort = experienceSurveyData
        .where((e) => e['time_point'] == 'short_term')
        .toList();
    final expLong = experienceSurveyData
        .where((e) => e['time_point'] == 'long_term')
        .toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // ── Completion overview ────────────────────────
        SectionCard(
          title: 'Completion Overview',
          child: CompletionMatrix(rows: [
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
          ]),
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
          child: LikertSurveyChart(
            data: previewUsefulnessData,
            itemCount: 5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: 'FSRS Usefulness  (n = ${fsrsUsefulnessData.length})',
          child: LikertSurveyChart(
            data: fsrsUsefulnessData,
            itemCount: 5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: 'UGC Perception  (n = ${ugcData.length})',
          child: LikertSurveyChart(
            data: ugcData,
            itemCount: 6,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
