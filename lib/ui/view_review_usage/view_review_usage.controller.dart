import 'package:boo_mondai/ui/view_review_usage/view_review_usage.data.dart';
import 'package:signals/signals.dart';

class ViewReviewUsageController {
  final Signal<ReviewLogDataset> selectedDataset = signal(
    ReviewLogDataset.japaneseSetAUser1,
  );
  final Signal<bool> showDatasetSelector = signal(true);

  void selectDataset(ReviewLogDataset dataset) {
    selectedDataset.value = dataset;
  }

  void hideDatasetSelector() {
    showDatasetSelector.value = false;
  }
}
