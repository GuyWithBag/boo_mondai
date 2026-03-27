// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard_page.dart
// PURPOSE: Researcher dashboard — manage codes, view participants and results
// PROVIDERS: ResearchProvider, AuthProvider
// HOOKS: useEffect, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';

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
                        proficiencyData: research.proficiencyData,
                        languageInterestData: research.languageInterestData,
                        experienceSurveyData: research.experienceSurveyData,
                        previewUsefulnessData: research.previewUsefulnessData,
                        fsrsUsefulnessData: research.fsrsUsefulnessData,
                        ugcData: research.ugcData,
                        susData: research.susData,
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
  final List<ResearchUser> participants;

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
        final name = p.displayName ?? 'Unknown';
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

// ── Results Tab ─────────────────────────────────────

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
        _SectionCard(
          title: 'Completion Overview',
          child: _CompletionMatrix(rows: [
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
        _SectionCard(
          title: 'Vocabulary Test — Set A  (n = ${setA.length})',
          child: _VocabTestChart(results: setA, maxScore: 30),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Vocabulary Test — Set B  (n = ${setB.length})',
          child: _VocabTestChart(results: setB, maxScore: 30),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Experience survey ──────────────────────────
        _SectionCard(
          title: 'Experience Survey — Short-term  (n = ${expShort.length})',
          child: _ExperienceSurveyChart(data: expShort),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'Experience Survey — Long-term  (n = ${expLong.length})',
          child: _ExperienceSurveyChart(data: expLong),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── SUS ────────────────────────────────────────
        _SectionCard(
          title: 'System Usability Scale (SUS)  (n = ${susData.length})',
          child: _SusChart(data: susData),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Usefulness surveys ─────────────────────────
        _SectionCard(
          title: 'Preview Usefulness  (n = ${previewUsefulnessData.length})',
          child: _LikertSurveyChart(
            data: previewUsefulnessData,
            itemCount: 5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'FSRS Usefulness  (n = ${fsrsUsefulnessData.length})',
          child: _LikertSurveyChart(
            data: fsrsUsefulnessData,
            itemCount: 5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionCard(
          title: 'UGC Perception  (n = ${ugcData.length})',
          child: _LikertSurveyChart(
            data: ugcData,
            itemCount: 6,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

// ── Shared section card ──────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

// ── Completion overview matrix ───────────────────────

class _CompletionMatrix extends StatelessWidget {
  final List<(String, int)> rows;

  const _CompletionMatrix({required this.rows});

  @override
  Widget build(BuildContext context) {
    final maxN = rows.isEmpty
        ? 1
        : rows.map((r) => r.$2).reduce((a, b) => a > b ? a : b).clamp(1, 999);
    return Column(
      children: rows.map((row) {
        final fraction = row.$2 / maxN;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              SizedBox(
                width: 190,
                child: Text(row.$1,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 12,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 24,
                child: Text(
                  '${row.$2}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Vocabulary test score histogram ──────────────────

class _VocabTestChart extends StatelessWidget {
  final List<VocabularyTestResult> results;
  final int maxScore;

  const _VocabTestChart({required this.results, required this.maxScore});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return _EmptyChart(label: 'No submissions yet (0–$maxScore)');
    }

    final avg = results.map((r) => r.score).reduce((a, b) => a + b) /
        results.length;

    // Build buckets: 0–9, 10–19, 20–24, 25–29, 30
    final buckets = [
      ('0–9', results.where((r) => r.score <= 9).length),
      ('10–19', results.where((r) => r.score >= 10 && r.score <= 19).length),
      ('20–24', results.where((r) => r.score >= 20 && r.score <= 24).length),
      ('25–29', results.where((r) => r.score >= 25 && r.score <= 29).length),
      ('30', results.where((r) => r.score == 30).length),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScoreBar(
          label: 'Avg score',
          value: avg,
          max: maxScore.toDouble(),
          color: avg / maxScore >= 0.7 ? AppColors.correct : AppColors.hard,
          valueLabel: '${avg.toStringAsFixed(1)} / $maxScore',
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Distribution',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
        const SizedBox(height: AppSpacing.sm),
        _BarHistogram(buckets: buckets),
      ],
    );
  }
}

// ── Experience survey subscale chart ─────────────────

class _ExperienceSurveyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _ExperienceSurveyChart({required this.data});

  double _avg(List<Map<String, dynamic>> rows, List<String> keys) {
    if (rows.isEmpty) return 0;
    var total = 0.0;
    var count = 0;
    for (final row in rows) {
      for (final key in keys) {
        final v = row[key];
        if (v != null) {
          total += (v as num).toDouble();
          count++;
        }
      }
    }
    return count == 0 ? 0 : total / count;
  }

  @override
  Widget build(BuildContext context) {
    final enjoymentAvg = _avg(
        data, ['enjoyment_1', 'enjoyment_2', 'enjoyment_3', 'enjoyment_4', 'enjoyment_5']);
    final engagementAvg = _avg(
        data, ['engagement_1', 'engagement_2', 'engagement_3', 'engagement_4', 'engagement_5']);
    final motivationAvg = _avg(
        data, ['motivation_1', 'motivation_2', 'motivation_3', 'motivation_4', 'motivation_5']);

    return Column(
      children: [
        _ScoreBar(
            label: 'Enjoyment',
            value: enjoymentAvg,
            max: 5,
            valueLabel: enjoymentAvg.toStringAsFixed(2)),
        const SizedBox(height: AppSpacing.sm),
        _ScoreBar(
            label: 'Engagement',
            value: engagementAvg,
            max: 5,
            valueLabel: engagementAvg.toStringAsFixed(2)),
        const SizedBox(height: AppSpacing.sm),
        _ScoreBar(
            label: 'Motivation',
            value: motivationAvg,
            max: 5,
            valueLabel: motivationAvg.toStringAsFixed(2)),
        if (data.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'No submissions yet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}

// ── SUS score chart ───────────────────────────────────

class _SusChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _SusChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final avg = data.isEmpty
        ? 0.0
        : data
                .map((e) => (e['sus_score'] as num).toDouble())
                .reduce((a, b) => a + b) /
            data.length;

    Color scoreColor(double s) {
      if (s >= 80) return AppColors.correct;
      if (s >= 68) return AppColors.easy;
      if (s >= 51) return AppColors.hard;
      return AppColors.incorrect;
    }

    String scoreLabel(double s) {
      if (s >= 80) return 'Excellent';
      if (s >= 68) return 'Good';
      if (s >= 51) return 'OK';
      return 'Poor';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScoreBar(
          label: 'Avg SUS score',
          value: avg,
          max: 100,
          color: scoreColor(avg),
          valueLabel: '${avg.toStringAsFixed(1)} — ${scoreLabel(avg)}',
        ),
        const SizedBox(height: AppSpacing.sm),
        // Threshold legend
        Row(
          children: [
            _ThresholdChip(label: '< 51 Poor', color: AppColors.incorrect),
            const SizedBox(width: AppSpacing.xs),
            _ThresholdChip(label: '51–68 OK', color: AppColors.hard),
            const SizedBox(width: AppSpacing.xs),
            _ThresholdChip(label: '68–80 Good', color: AppColors.easy),
            const SizedBox(width: AppSpacing.xs),
            _ThresholdChip(label: '> 80 Excellent', color: AppColors.correct),
          ],
        ),
        if (data.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'No submissions yet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}

class _ThresholdChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ThresholdChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadii.badge),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Generic Likert survey chart ───────────────────────

class _LikertSurveyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int itemCount;

  const _LikertSurveyChart(
      {required this.data, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 1; i <= itemCount; i++) ...[
          if (i > 1) const SizedBox(height: AppSpacing.xs),
          _ScoreBar(
            label: 'Item $i',
            value: data.isEmpty
                ? 0
                : data
                        .map((e) =>
                            (e['item_$i'] as num?)?.toDouble() ?? 0.0)
                        .reduce((a, b) => a + b) /
                    data.length,
            max: 5,
            valueLabel: data.isEmpty
                ? '—'
                : (data
                            .map((e) =>
                                (e['item_$i'] as num?)?.toDouble() ?? 0.0)
                            .reduce((a, b) => a + b) /
                        data.length)
                    .toStringAsFixed(2),
          ),
        ],
        if (data.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'No submissions yet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}

// ── Reusable horizontal score bar ─────────────────────

class _ScoreBar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color? color;
  final String? valueLabel;

  const _ScoreBar({
    required this.label,
    required this.value,
    required this.max,
    this.color,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    final barColor = color ??
        (fraction >= 0.7 ? AppColors.correct : AppColors.hard);

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 14,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              color: barColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 64,
          child: Text(
            valueLabel ?? value.toStringAsFixed(1),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ── Vertical bar histogram ────────────────────────────

class _BarHistogram extends StatelessWidget {
  final List<(String, int)> buckets;

  const _BarHistogram({required this.buckets});

  @override
  Widget build(BuildContext context) {
    final maxCount = buckets.isEmpty
        ? 1
        : buckets.map((b) => b.$2).reduce((a, b) => a > b ? a : b).clamp(1, 999);

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: buckets.map((bucket) {
          final fraction = bucket.$2 / maxCount;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (bucket.$2 > 0)
                    Text(
                      '${bucket.$2}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  const SizedBox(height: 2),
                  Container(
                    height: 60 * fraction + 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bucket.$1,
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty chart placeholder ───────────────────────────

class _EmptyChart extends StatelessWidget {
  final String label;

  const _EmptyChart({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
