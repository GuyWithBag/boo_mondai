import 'package:boo_mondai/features/media_variants/media_selector.dart';
import 'package:boo_mondai/features/media_variants/app_media_pack.model.dart';
import 'package:boo_mondai/features/study_session/session_steps/message.session_step.dart';

abstract class StudySessionStepHelper {
  static MediaSelector<AppMediaPack>? getMessageStepSound(
    StudySessionMessageStep step,
  ) {
    return switch (step.messageDefinitionId) {
      'slow-down' => (media) => media.studySessionSlowDownSound,
      'progress-milestone' =>
        (media) => media.studySessionProgressMilestoneSound,
      _ => null,
    };
  }
}
