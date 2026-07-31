import 'package:boo_mondai/core/models/media_selector.dart';
import 'package:boo_mondai/core/theme/app_media_pack.model.dart';
import 'package:boo_mondai/features/study_session/session_steps/message.session_step.dart';

abstract class StudySessionStepHelper {
  static MediaSelector<AppMediaPack>? getMessageStepSound(
    MessageSessionStep step,
  ) {
    return switch (step.messageDefinitionId) {
      'slow-down' => (media) => media.studySessionSlowDownSound,
      'progress-milestone' =>
        (media) => media.studySessionProgressMilestoneSound,
      _ => null,
    };
  }
}
