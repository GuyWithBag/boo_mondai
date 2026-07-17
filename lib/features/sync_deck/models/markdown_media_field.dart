import 'package:boo_mondai/lib.barrel.dart' show CardTemplate;

/// Describes a markdown field that can be read from and written back to a card
/// template during sync media preprocessing.
final class MarkdownMediaField {
  const MarkdownMediaField({
    required this.name,
    required this.getValue,
    required this.setValue,
  });

  final String name;
  final String Function(CardTemplate template) getValue;
  final CardTemplate Function(CardTemplate template, String value) setValue;
}
