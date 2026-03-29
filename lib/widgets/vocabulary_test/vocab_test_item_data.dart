// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/vocabulary_test/vocab_test_item_data.dart
// PURPOSE: Data class for a single vocabulary test question with options
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class VocabTestItemData {
  final String id;
  final String prompt;
  final Map<String, String> options; // A, B, C, D
  final String correctOption;

  const VocabTestItemData({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctOption,
  });
}
