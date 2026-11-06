import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Deck,
        ListingStatesWrapper,
        Scaffold,
        StatusLayoutState,
        TextSize,
        textStyle;
import 'package:boo_mondai/ui/view_review_detail/models/models.barrel.dart';
import 'package:boo_mondai/ui/view_review_detail/view_review_detail.controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewReviewDetailPage extends SignalHookWidget {
  const ViewReviewDetailPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(() => ViewReviewDetailController(deckId));
    final tokens = context.themeTokens<AppTokens>();
    final labelStyle = textStyle.resolve(tokens, const [TextSize.labelSmall]);
    final deck = controller.deck.value;
    final bars = controller.chartBars.value;

    useEffect(() => controller.dispose, [controller]);

    return Scaffold(
      appBar: AppBar(title: deck?.title ?? 'Review Details'),
      body: ListingStatesWrapper<Deck>.list(
        isLoading: controller.isLoading.value,
        exception: controller.error.value,
        onRetry: controller.load,
        items: deck == null ? const [] : [deck],
        emptyState: const StatusLayoutState(
          icon: Icons.search_off,
          title: 'Deck not found',
          message: 'This deck is no longer available.',
        ),
        useParentScroll: true,
        padding: EdgeInsets.all(tokens.spaceLayoutGapMd),
        itemBuilder: (_, _, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Review history', style: labelStyle),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final span in ReviewDetailTimeSpan.values)
                  ChoiceChip(
                    label: Text(span.label, style: labelStyle),
                    selected: controller.timeSpan.value == span,
                    onSelected: (_) => controller.selectTimeSpan(span),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<ReviewDetailRangeMode>(
              segments: [
                ButtonSegment(
                  value: ReviewDetailRangeMode.relative,
                  label: Text('Relative', style: labelStyle),
                ),
                ButtonSegment(
                  value: ReviewDetailRangeMode.fixed,
                  label: Text('Fixed', style: labelStyle),
                ),
              ],
              selected: {controller.rangeMode.value},
              onSelectionChanged: (values) =>
                  controller.setRangeMode(values.first),
            ),
            if (controller.timeSpan.value == ReviewDetailTimeSpan.custom)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        initialValue: '${controller.customAmount.value}',
                        keyboardType: TextInputType.number,
                        style: labelStyle,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: labelStyle,
                        ),
                        onChanged: controller.setCustomAmount,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<ReviewDetailTimeUnit>(
                        initialValue: controller.customUnit.value,
                        decoration: InputDecoration(
                          labelText: 'Timespan',
                          labelStyle: labelStyle,
                        ),
                        items: [
                          for (final unit in ReviewDetailTimeUnit.values)
                            DropdownMenuItem(
                              value: unit,
                              child: Text(unit.label, style: labelStyle),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.setCustomUnit(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              height: 320,
              child: bars.isEmpty
                  ? Center(
                      child: Text(
                        'No reviews in this period',
                        style: labelStyle,
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        minY: 0,
                        maxY:
                            (bars
                                        .map((bar) => bar.count)
                                        .fold(0, (a, b) => a > b ? a : b) +
                                    1)
                                .toDouble(),
                        barGroups: [
                          for (final bar in bars)
                            BarChartGroupData(
                              x: bar.index,
                              barRods: [
                                BarChartRodData(
                                  toY: bar.count.toDouble(),
                                  width: bars.length > 180 ? 2 : 8,
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            ),
                        ],
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: RotatedBox(
                              quarterTurns: 2,
                              child: Text('Review amount', style: labelStyle),
                            ),
                            axisNameSize: 30,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) =>
                                  Text('${value.toInt()}', style: labelStyle),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= bars.length) {
                                  return const SizedBox.shrink();
                                }
                                final showTitle =
                                    switch (controller.timeSpan.value) {
                                      ReviewDetailTimeSpan.oneWeek => true,
                                      ReviewDetailTimeSpan.oneMonth =>
                                        index == 0 ||
                                            index == bars.length - 1 ||
                                            bars[index].index % 5 == 0,
                                      ReviewDetailTimeSpan.threeMonths ||
                                      ReviewDetailTimeSpan.sixMonths ||
                                      ReviewDetailTimeSpan.oneYear => true,
                                      ReviewDetailTimeSpan.custom =>
                                        index == 0 || index == bars.length - 1,
                                    };
                                return showTitle
                                    ? Text(bars[index].label, style: labelStyle)
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('Days before today (0 = today)', style: labelStyle),
            ),
          ],
        ),
      ),
    );
  }
}
