import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/features/notifications/models/notification.intent.dart';
import 'package:boo_mondai/features/notifications/models/notification.intent.tone.dart';
import 'package:boo_mondai/features/notifications/models/notification.intent.type.dart';
import 'package:flutter/material.dart';

extension NotificationIntentPresentation on NotificationIntent {
  NotificationIntentTone get effectiveTone {
    if (tone != NotificationIntentTone.inherit) return tone;

    return switch (type) {
      NotificationIntentType.streakReminder => NotificationIntentTone.warning,
      NotificationIntentType.reviewFsrsWarning =>
        NotificationIntentTone.warning,
      NotificationIntentType.downloadComplete ||
      NotificationIntentType.syncComplete ||
      NotificationIntentType.drillDeckComplete ||
      NotificationIntentType.researcherStudySessionComplete =>
        NotificationIntentTone.success,
      NotificationIntentType.finalDrillBatchSurvey ||
      NotificationIntentType.finalDrillBatchReviewNow ||
      NotificationIntentType.firstReviewFsrsScheduling ||
      NotificationIntentType.studyDeckReview ||
      NotificationIntentType.reviewReminder =>
        NotificationIntentTone.announcement,
    };
  }

  SurfaceColor get surfaceColor {
    if (tone == NotificationIntentTone.inherit &&
        type == NotificationIntentType.streakReminder) {
      return SurfaceColor.streak;
    }

    return switch (effectiveTone) {
      NotificationIntentTone.inherit => SurfaceColor.baseline,
      NotificationIntentTone.success => SurfaceColor.success,
      NotificationIntentTone.danger => SurfaceColor.error,
      NotificationIntentTone.warning => SurfaceColor.hard,
      NotificationIntentTone.announcement => SurfaceColor.easy,
    };
  }

  IconData get icon {
    return switch (effectiveTone) {
      NotificationIntentTone.inherit => Icons.notifications_outlined,
      NotificationIntentTone.success => Icons.check_circle_outline,
      NotificationIntentTone.danger => Icons.error_outline,
      NotificationIntentTone.warning => Icons.warning_amber_outlined,
      NotificationIntentTone.announcement => Icons.campaign_outlined,
    };
  }
}
