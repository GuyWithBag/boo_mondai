import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeTrackerEntry, ChangeType;
import 'package:flutter/material.dart';

/// Presentation utilities for [ChangeTrackerEntry] and [ChangeType] used
/// across change-tracker widgets.
///
/// All methods are pure and stateless.
abstract final class ChangeTrackerHelper {
  /// Returns the compact symbol prefix for a change type row (`+`, `~`, `-`).
  static String typePrefix(ChangeType type) {
    return switch (type) {
      ChangeType.added => '+',
      ChangeType.modified => '~',
      ChangeType.removed => '-',
      ChangeType.skipped => '',
    };
  }

  /// Returns the human-readable label for a change type (`Added`, `Modified`, etc.).
  static String typeLabel(ChangeType type) {
    return switch (type) {
      ChangeType.added => 'Added',
      ChangeType.modified => 'Modified',
      ChangeType.removed => 'Removed',
      ChangeType.skipped => 'Skipped',
    };
  }

  /// Returns the count of [type] changes in [entry].
  static int typeCount(ChangeTrackerEntry entry, ChangeType type) {
    return switch (type) {
      ChangeType.added => entry.addedCount,
      ChangeType.modified => entry.modifiedCount,
      ChangeType.removed => entry.removedCount,
      ChangeType.skipped => 0,
    };
  }

  /// Returns the foreground color for inline change type text.
  static Color typeForeground(AppTokens tokens, ChangeType type) {
    return switch (type) {
      ChangeType.added => tokens.colorActionSuccess,
      ChangeType.modified => tokens.colorRatingHardText,
      ChangeType.removed => tokens.colorRatingAgainText,
      ChangeType.skipped => tokens.colorTextMuted,
    };
  }

  /// Returns the foreground, background, and border colors for a chip
  /// representing [type].
  static ({Color foreground, Color background, Color border}) typeChipColors(
    AppTokens tokens,
    ChangeType type,
  ) {
    return switch (type) {
      ChangeType.added => (
        foreground: tokens.colorActionSuccess,
        background: tokens.colorActionSuccessBackground,
        border: tokens.colorActionSuccessBorder,
      ),
      ChangeType.modified => (
        foreground: tokens.colorRatingHardText,
        background: tokens.colorRatingHardBackground,
        border: tokens.colorRatingHardBorder,
      ),
      ChangeType.removed => (
        foreground: tokens.colorRatingAgainText,
        background: tokens.colorRatingAgainBackground,
        border: tokens.colorRatingAgainBorder,
      ),
      ChangeType.skipped => (
        foreground: tokens.colorTextMuted,
        background: tokens.colorSurfaceBackground,
        border: tokens.colorBorderNeutralSubtle,
      ),
    };
  }
}
