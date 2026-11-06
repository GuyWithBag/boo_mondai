import 'package:boo_mondai/lib.barrel.dart'
    show AppBar, AppTokens, Button, Scaffold, SectionEyebrow;
import 'package:boo_mondai/ui/view_review_usage/view_review_usage.controller.dart';
import 'package:boo_mondai/ui/view_review_usage/view_review_usage.data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewReviewUsagePage extends SignalHookWidget {
  const ViewReviewUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useMemoized(() => ViewReviewUsageController());
    final dataset = controller.selectedDataset.value;

    return Scaffold(
      appBar: AppBar(title: dataset.deckTitle),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final chartHeight = constraints.maxWidth < 600 ? 300.0 : 380.0;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Container(
                decoration: BoxDecoration(
                  color: tokens.colorSurfaceBackground,
                  borderRadius: BorderRadius.circular(tokens.radiusSurface),
                ),
                child: Padding(
                  padding: EdgeInsets.all(tokens.spaceLayoutPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: tokens.spaceLayoutGapMd,
                    children: [
                      const SectionEyebrow('Review Log'),
                      Text(
                        'The number of questions you have answered.',
                        textAlign: TextAlign.center,
                      ),
                      if (controller.showDatasetSelector.value) ...[
                        DropdownMenu<ReviewLogDataset>(
                          initialSelection: dataset,
                          expandedInsets: EdgeInsets.zero,
                          label: const Text('Data set'),
                          dropdownMenuEntries: [
                            for (final option in ReviewLogDataset.values)
                              DropdownMenuEntry(
                                value: option,
                                label:
                                    '${option.deckTitle}: ${option.userName}',
                              ),
                          ],
                          onSelected: (value) {
                            if (value != null) controller.selectDataset(value);
                          },
                        ),
                        Button(
                          onPressed: controller.hideDatasetSelector,
                          child: const Text('Hide data set selector'),
                        ),
                      ],
                      Text('Time: 1 month', textAlign: TextAlign.center),
                      SizedBox(
                        height: chartHeight,
                        child: BarChart(
                          BarChartData(
                            minY: 0,
                            maxY: _maxY(dataset.reviewLog),
                            alignment: BarChartAlignment.spaceAround,
                            gridData: FlGridData(
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (_) => FlLine(
                                color: tokens.colorBorderNeutralSubtle,
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: _titlesData(context),
                            barGroups: [
                              for (final point in dataset.reviewLog)
                                BarChartGroupData(
                                  x: point.day,
                                  barRods: [
                                    BarChartRodData(
                                      toY: point.reviews.toDouble(),
                                      color: tokens.colorPrimaryBright,
                                      width: 8,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Days studied: ${dataset.daysStudied} of 31 '
                        '(${(dataset.daysStudied / 31 * 100).toStringAsFixed(2)}%)',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Total: ${dataset.totalReviews} reviews',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Average over period: '
                        '${_formatAverage(dataset.averageOverPeriod)} reviews/day',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Average for days studied: '
                        '${_formatAverage(dataset.averageForDaysStudied)} '
                        'reviews/day',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

double _maxY(List<ReviewLogPoint> data) {
  final maxValue = data.fold<int>(
    0,
    (maxValue, point) => point.reviews > maxValue ? point.reviews : maxValue,
  );
  if (maxValue == 0) return 1;
  return ((maxValue + 4) ~/ 5 * 5).toDouble();
}

String _formatAverage(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

FlTitlesData _titlesData(BuildContext context) {
  final tokens = context.themeTokens<AppTokens>();
  final labelStyle = TextStyle(
    color: tokens.colorTextMuted,
    fontSize: tokens.textSizeLabelSmall,
  );

  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 36),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        getTitlesWidget: (value, meta) {
          final day = value.toInt();
          if (![1, 8, 15, 22, 31].contains(day)) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            meta: meta,
            child: Text(day.toString(), style: labelStyle),
          );
        },
      ),
    ),
  );
}
