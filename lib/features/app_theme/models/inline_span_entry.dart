/// Lightweight value type for a span entry. Extend this to attach any
/// per-span data your controller needs.
class InlineSpanEntry {
  const InlineSpanEntry({required this.text});

  final String text;
}
