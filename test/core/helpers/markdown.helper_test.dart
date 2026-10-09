import 'package:boo_mondai/lib.barrel.dart' show MarkdownHelper;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownHelper.splitInlineMarkdownWords', () {
    List<String> words(String data) => MarkdownHelper.splitInlineMarkdownWords(
      data,
    ).where((chunk) => !chunk.isLineBreak).map((chunk) => chunk.text).toList();

    test('splits plain text into one chunk per word', () {
      expect(words('Hello here'), ['Hello', 'here']);
    });

    test('keeps strong markdown valid for each split word', () {
      expect(words('**Hello here**'), ['**Hello**', '**here**']);
    });

    test('keeps nested markdown delimiters around each split word', () {
      expect(words('**Hello _small world_ here**'), [
        '**Hello**',
        '**_small_**',
        '**_world_**',
        '**here**',
      ]);
    });

    test('emits line break chunks for newline characters', () {
      final chunks = MarkdownHelper.splitInlineMarkdownWords('Hello\nhere');

      expect(chunks, [
        (isLineBreak: false, text: 'Hello'),
        (isLineBreak: true, text: ''),
        (isLineBreak: false, text: 'here'),
      ]);
    });

    test('leaves unmatched markdown delimiters literal', () {
      expect(words('*Hello here'), ['*Hello', 'here']);
    });
  });
}
