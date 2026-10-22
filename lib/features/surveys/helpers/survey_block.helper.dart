import 'package:boo_mondai/lib.barrel.dart'
    show
        SurveyBlock,
        SurveyBooleanInputBlock,
        SurveyChoiceOption,
        SurveyLikertInputBlock,
        SurveyMultipleChoiceInputBlock,
        SurveyNumberInputBlock,
        SurveyTextInputBlock;

abstract final class SurveyBlockHelper {
  static String promptFor(SurveyBlock block) {
    return switch (block) {
      SurveyTextInputBlock(:final prompt) => prompt,
      SurveyNumberInputBlock(:final prompt) => prompt,
      SurveyMultipleChoiceInputBlock(:final prompt) => prompt,
      SurveyLikertInputBlock(:final prompt) => prompt,
      SurveyBooleanInputBlock(:final prompt) => prompt,
      _ => block.id,
    };
  }

  static String keyFor(SurveyBlock block) {
    return switch (block) {
      SurveyTextInputBlock(:final key) => key,
      SurveyNumberInputBlock(:final key) => key,
      SurveyMultipleChoiceInputBlock(:final key) => key,
      SurveyLikertInputBlock(:final key) => key,
      SurveyBooleanInputBlock(:final key) => key,
      _ => block.id,
    };
  }

  static List<SurveyChoiceOption> optionsFor(SurveyBlock block) {
    return switch (block) {
      SurveyMultipleChoiceInputBlock(:final options) => options,
      _ => const [],
    };
  }
}
