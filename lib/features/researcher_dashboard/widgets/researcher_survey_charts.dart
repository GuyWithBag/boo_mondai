import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        StringHelper,
        SurveyAnswerAggregate,
        SurveyBlockHelper,
        TextColor,
        TextSize,
        TextWeight,
        textStyle;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherSurveyCharts extends StatelessWidget {
  const ResearcherSurveyCharts({required this.aggregates, super.key});

  final List<SurveyAnswerAggregate> aggregates;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    if (aggregates.isEmpty) {
      return const Text('This survey has no input questions.');
    }

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final aggregate in aggregates)
          _AggregateBlock(aggregate: aggregate),
      ],
    );
  }
}

class _AggregateBlock extends StatelessWidget {
  const _AggregateBlock({required this.aggregate});

  final SurveyAnswerAggregate aggregate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapSm,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarkdownText(
          data: SurveyBlockHelper.promptFor(aggregate.block),
          mode: MarkdownTextMode.previewSelectable,
          defaultMarkdownAlignment: WrapAlignment.start,
        ),
        Text(
          '${aggregate.answeredCount}/${aggregate.totalResponses} answered',
          style: textStyle.resolve(tokens, const [
            TextSize.labelSmall,
            TextColor.muted,
          ]),
        ),
        if (aggregate.average != null)
          Text(
            'Average ${aggregate.average!.toStringAsFixed(2)}'
            ' · Min ${aggregate.min} · Max ${aggregate.max}',
            style: textStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.heavy,
            ]),
          ),
        if (aggregate.optionCounts.isNotEmpty)
          _AggregateBarChart(
            optionCounts: aggregate.optionCounts,
            total: aggregate.totalResponses,
          ),
        if (aggregate.textAnswers.isNotEmpty)
          Column(
            spacing: tokens.spaceLayoutGapSm,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final answer in aggregate.textAnswers.take(12))
                Text('• $answer'),
              if (aggregate.textAnswers.length > 12)
                Text('+${aggregate.textAnswers.length - 12} more answers'),
            ],
          ),
      ],
    );
  }
}

class _AggregateBarChart extends StatelessWidget {
  const _AggregateBarChart({required this.optionCounts, required this.total});

  final Map<String, int> optionCounts;
  final int total;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final entries = optionCounts.entries.toList();
    final maxCount = entries.fold<int>(
      0,
      (max, entry) => entry.value > max ? entry.value : max,
    );
    final maxY = maxCount <= 0 ? 1.0 : maxCount.toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final entry = entries[group.x.toInt()];
                    final percent = total == 0
                        ? 0.0
                        : (entry.value / total) * 100;
                    return BarTooltipItem(
                      '${entry.key}\n${entry.value} (${percent.toStringAsFixed(0)}%)',
                      textStyle.resolve(tokens, const [
                        TextSize.labelSmall,
                        TextWeight.heavy,
                      ]),
                    );
                  },
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: tokens.colorBorderNeutralSubtle,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      if (value % 1 != 0) return const SizedBox.shrink();
                      return Text(
                        value.toInt().toString(),
                        style: textStyle.resolve(tokens, const [
                          TextSize.labelSmall,
                          TextColor.muted,
                        ]),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= entries.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          StringHelper.truncateWithEllipsis(
                            entries[index].key,
                            16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: textStyle.resolve(tokens, const [
                            TextSize.labelSmall,
                            TextColor.muted,
                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (final entry in entries.asMap().entries)
                  BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.value.toDouble(),
                        color: tokens.colorPrimaryBright,
                        width: 18,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(tokens.radiusSurfaceXsm),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        for (final entry in entries)
          Text(
            '${entry.key}: ${entry.value}'
            ' (${total == 0 ? 0 : ((entry.value / total) * 100).round()}%)',
            style: textStyle.resolve(tokens, const [
              TextSize.labelSmall,
              TextColor.muted,
            ]),
          ),
      ],
    );
  }
}
