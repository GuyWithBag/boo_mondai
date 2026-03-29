// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/vocabulary_test/test_items.dart
// PURPOSE: Builds placeholder vocabulary test items by test set
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// In production, these would come from Supabase or a local JSON asset.
// For now, we provide sample items for development.
import 'package:boo_mondai/widgets/widgets.barrel.dart';

List<VocabTestItemData> buildTestItems(String testSet) {
  if (testSet == 'A') {
    return List.generate(30, (i) {
      final idx = i + 1;
      return VocabTestItemData(
        id: 'a_$idx',
        prompt: 'What is the meaning of word A-$idx?',
        options: const {
          'A': 'Option A',
          'B': 'Option B',
          'C': 'Option C',
          'D': 'Option D',
        },
        correctOption: 'A',
      );
    });
  } else {
    return List.generate(30, (i) {
      final idx = i + 1;
      return VocabTestItemData(
        id: 'b_$idx',
        prompt: 'What is the meaning of word B-$idx?',
        options: const {
          'A': 'Option A',
          'B': 'Option B',
          'C': 'Option C',
          'D': 'Option D',
        },
        correctOption: 'B',
      );
    });
  }
}
