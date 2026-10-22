import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeTrackerEntry, ChangeType;
import 'package:flutter/material.dart';

/// Presentation utilities for [ChangeTrackerEntry] and [ChangeType] used
/// across change-tracker widgets.
///
/// All methods are pure and stateless.
abstract final class ChangeTrackerHelper {
  /// Returns the compact symbol prefix for a change type row (`+`, `~`, `-`).
  static String getTypePrefix(ChangeType type) {
    return switch (type) {
      ChangeType.added => '+',
      ChangeType.modified => '~',
      ChangeType.removed => '-',
      ChangeType.skipped => '',
    };
  }

  static IconData getTypeIcon(ChangeType type) {
    final icon = switch (type) {
      ChangeType.added => Icons.add,
      ChangeType.removed => Icons.remove,
      ChangeType.modified => Icons.change_circle,
      ChangeType.skipped => Icons.skip_next,
    };
    return icon;
  }

  /// Returns the human-readable label for a change type (`Added`, `Modified`, etc.).
  static String getTypeLabel(ChangeType type) {
    return switch (type) {
      ChangeType.added => 'Added',
      ChangeType.modified => 'Modified',
      ChangeType.removed => 'Removed',
      ChangeType.skipped => 'Skipped',
    };
  }

  /// Returns the count of [type] changes in [entry].
  static int getTypeCount(ChangeTrackerEntry<Object?> entry, ChangeType type) {
    return switch (type) {
      ChangeType.added => entry.addedCount,
      ChangeType.modified => entry.modifiedCount,
      ChangeType.removed => entry.removedCount,
      ChangeType.skipped => 0,
    };
  }

  static Color getTypeBackground(AppTokens tokens, ChangeType type) {
    final color = switch (type) {
      ChangeType.added => tokens.colorActionSuccessBackground,
      ChangeType.modified => tokens.colorRatingHardBackground,
      ChangeType.removed => tokens.colorRatingAgainBackground,
      ChangeType.skipped => tokens.colorTextMuted,
    };
    return color.withValues(alpha: 1);
  }

  static Color getTypeForeground(AppTokens tokens, ChangeType type) {
    final color = switch (type) {
      ChangeType.added => tokens.colorActionSuccess,
      ChangeType.modified => tokens.colorRatingHardText,
      ChangeType.removed => tokens.colorRatingAgainText,
      ChangeType.skipped => tokens.colorTextMuted,
    };
    return color.withValues(alpha: 1);
  }

  static Color getTypeBorder(AppTokens tokens, ChangeType type) {
    final color = switch (type) {
      ChangeType.added => tokens.colorActionSuccessBorder,
      ChangeType.modified => tokens.colorRatingHardBorder,
      ChangeType.removed => tokens.colorRatingAgainBorder,
      ChangeType.skipped => tokens.colorTextMuted,
    };
    return color.withValues(alpha: 1);
  }

  /// Returns the foreground, background, and border colors for a chip
  /// representing [type].
  static ({Color foreground, Color background, Color border}) getTypeChipColors(
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
