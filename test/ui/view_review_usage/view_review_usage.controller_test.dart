import 'package:boo_mondai/ui/view_review_usage/view_review_usage.controller.dart';
import 'package:boo_mondai/ui/view_review_usage/view_review_usage.data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewReviewUsageController', () {
    test('starts with the first review log dataset', () {
      final controller = ViewReviewUsageController();

      expect(
        controller.selectedDataset.value,
        ReviewLogDataset.japaneseSetAUser1,
      );
    });

    test('selects a dataset and exposes its estimated data', () {
      final controller = ViewReviewUsageController();

      controller.selectDataset(ReviewLogDataset.chineseSetBUser2);

      expect(
        controller.selectedDataset.value,
        ReviewLogDataset.chineseSetBUser2,
      );
      expect(
        controller.selectedDataset.value.reviewLog.length,
        reviewChartDays,
      );
      expect(
        controller.selectedDataset.value.reviewLog
            .skip(estimatedReviewDays)
            .every((point) => point.reviews == 0),
        isTrue,
      );
    });

    test('creates one dataset per BooMondai participant', () {
      expect(ReviewLogDataset.values, hasLength(10));
      expect(ReviewLogDataset.japaneseSetAUser1.deckTitle, 'Japanese Set A');
      expect(ReviewLogDataset.japaneseSetAUser1.userName, 'J-A01');
      expect(ReviewLogDataset.chineseSetBUser2.userName, 'C-A05');
    });

    test('estimates reviews across exactly seven study days', () {
      for (final dataset in ReviewLogDataset.values) {
        final log = dataset.reviewLog;

        expect(log, hasLength(reviewChartDays));
        expect(dataset.daysStudied, estimatedReviewDays);
        expect(dataset.totalReviews, greaterThan(0));
        expect(
          log.skip(estimatedReviewDays).every((point) => point.reviews == 0),
          isTrue,
        );
      }
    });

    test('hides the selector for the current page session', () {
      final controller = ViewReviewUsageController();

      controller.hideDatasetSelector();

      expect(controller.showDatasetSelector.value, isFalse);
    });
  });
}
