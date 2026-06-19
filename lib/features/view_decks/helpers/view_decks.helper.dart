import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/import_export/import_export.controller.dart';
import 'package:boo_mondai/features/change_tracker/change_tracker_entry.dart';
import 'package:boo_mondai/features/change_tracker/models/change_source.dart';
import 'package:boo_mondai/features/change_tracker/models/change_tracker_status.dart';

abstract final class ViewDecksHelper {
  static ChangeTrackerEntry? currentSyncPlan(List<ChangeTrackerEntry> plans) {
    for (final plan in plans) {
      if (plan.source != ChangeSource.sync) continue;
      if (plan.status == ChangeTrackerStatus.canceled ||
          plan.status == ChangeTrackerStatus.failed ||
          plan.status == ChangeTrackerStatus.idle) {
        continue;
      }
      return plan;
    }
    return null;
  }

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
