enum MarkdownTextMode {
  /// Renders markdown as styled preview. Text is selectable but not editable.
  previewSelectable,

  /// Renders markdown as styled preview. Text is not selectable.
  preview,

  /// Shows the raw markdown string as non-selectable [Text].
  raw,

  /// Shows the raw markdown string in an editable [TextField].
  input,

  /// Obsidian-style live preview. Renders markdown at rest; switches to an
  /// editable [TextField] while focused. Tapping anywhere in the preview
  /// activates edit mode; losing focus returns to preview.
  inputPreview,
}
