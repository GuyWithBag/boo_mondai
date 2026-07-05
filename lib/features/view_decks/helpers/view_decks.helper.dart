import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/import_export/import_export.controller.dart';

abstract final class ViewDecksHelper {
  static String importMessage(ImportFileResult<Deck> result) {
    return switch (result.status) {
      ImportFileStatus.imported =>
        result.importedCount == 1
            ? 'Imported 1 deck'
            : 'Imported ${result.importedCount} decks',
      ImportFileStatus.unreadableFile => 'Could not read the selected file.',
      ImportFileStatus.unsupportedFormat => 'Unsupported import format.',
      ImportFileStatus.failed => 'Import failed: ${result.error}',
      ImportFileStatus.canceled => '',
    };
  }

  static bool isImportFailure(ImportFileResult<Object?> result) {
    return switch (result.status) {
      ImportFileStatus.unreadableFile ||
      ImportFileStatus.unsupportedFormat ||
      ImportFileStatus.failed => true,
      ImportFileStatus.canceled || ImportFileStatus.imported => false,
    };
  }
}
