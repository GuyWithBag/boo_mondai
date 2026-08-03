import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        MarkdownText,
        MarkdownTextMode,
        SurveyBlock,
        SurveyBooleanInputBlock,
        SurveyContentBlock,
        SurveyLikertInputBlock,
        SurveyMultipleChoiceInputBlock,
        SurveyNumberInputBlock,
        SurveyTextInputBlock,
        TextField,
        ViewSurveyController;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class SurveyBlockField extends StatelessWidget {
  const SurveyBlockField({super.key, required this.block});

  final SurveyBlock block;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      SurveyContentBlock() => _ContentBlock(block: block as SurveyContentBlock),
      SurveyTextInputBlock() => _TextInputBlock(
        block: block as SurveyTextInputBlock,
      ),
      SurveyNumberInputBlock() => _NumberInputBlock(
        block: block as SurveyNumberInputBlock,
      ),
      SurveyMultipleChoiceInputBlock() => _MultipleChoiceInputBlock(
        block: block as SurveyMultipleChoiceInputBlock,
      ),
      SurveyLikertInputBlock() => _LikertInputBlock(
        block: block as SurveyLikertInputBlock,
      ),
      SurveyBooleanInputBlock() => _BooleanInputBlock(
        block: block as SurveyBooleanInputBlock,
      ),
      _ => throw UnsupportedError('Unsupported survey block: ${block.id}'),
    };
  }
}

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({required this.block});

  final SurveyContentBlock block;

  @override
  Widget build(BuildContext context) {
    return MarkdownText(
      data: block.markdown,
      mode: MarkdownTextMode.previewSelectable,
      defaultMarkdownAlignment: WrapAlignment.start,
    );
  }
}

class _TextInputBlock extends HookWidget {
  const _TextInputBlock({required this.block});

  final SurveyTextInputBlock block;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ViewSurveyController>();
    final textController = useTextEditingController(
      text: controller.answers[block.key] as String? ?? '',
    );

    return _PromptedField(
      prompt: block.prompt,
      description: block.description,
      child: TextField(
        controller: textController,
        placeholder: block.placeholder,
        minLines: block.isLongText ? 4 : null,
        maxLines: block.isLongText ? 8 : 1,
        onChanged: (value) => controller.setAnswer(block.key, value),
      ),
    );
  }
}

class _NumberInputBlock extends HookWidget {
  const _NumberInputBlock({required this.block});

  final SurveyNumberInputBlock block;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ViewSurveyController>();
    final value = controller.answers[block.key];
    final textController = useTextEditingController(text: value?.toString());

    return _PromptedField(
      prompt: block.prompt,
      description: block.description,
      child: TextField(
        controller: textController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) => controller.setAnswer(
          block.key,
          value.trim().isEmpty ? null : num.tryParse(value),
        ),
      ),
    );
  }
}

class _MultipleChoiceInputBlock extends StatelessWidget {
  const _MultipleChoiceInputBlock({required this.block});

  final SurveyMultipleChoiceInputBlock block;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewSurveyController>();
    final tokens = context.themeTokens<AppTokens>();
    final selected = List<String>.from(
      controller.answers[block.key] as List? ?? const [],
    );

    void toggle(String value) {
      final next = [...selected];
      if (block.isSingleChoice) {
        controller.setAnswer(block.key, [value]);
        return;
      }
      next.contains(value) ? next.remove(value) : next.add(value);
      controller.setAnswer(block.key, next);
    }

    return _PromptedField(
      prompt: block.prompt,
      description: block.description,
      child: Column(
        spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final option in block.options)
            Button(
              onPressed: () => toggle(option.value),
              selected: selected.contains(option.value),
              variants: const [ButtonVariant.flat],
              child: MarkdownText(
                data: option.label,
                mode: MarkdownTextMode.preview,
                defaultMarkdownAlignment: WrapAlignment.start,
              ),
            ),
        ],
      ),
    );
  }
}

class _LikertInputBlock extends StatelessWidget {
  const _LikertInputBlock({required this.block});

  final SurveyLikertInputBlock block;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewSurveyController>();
    final tokens = context.themeTokens<AppTokens>();
    final selected = controller.answers[block.key] as int?;

    return _PromptedField(
      prompt: block.prompt,
      description: block.description,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: tokens.spaceLayoutGapSm,
        children: [
          Row(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              for (var value = block.minValue; value <= block.maxValue; value++)
                Expanded(
                  child: Button(
                    onPressed: () => controller.setAnswer(block.key, value),
                    selected: selected == value,
                    variants: const [ButtonVariant.flat],
                    child: Text('$value'),
                  ),
                ),
            ],
          ),
          if (block.minLabel != null || block.maxLabel != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(block.minLabel ?? ''),
                Text(block.maxLabel ?? ''),
              ],
            ),
        ],
      ),
    );
  }
}

class _BooleanInputBlock extends StatelessWidget {
  const _BooleanInputBlock({required this.block});

  final SurveyBooleanInputBlock block;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewSurveyController>();
    final value = controller.answers[block.key] as bool?;
    final tokens = context.themeTokens<AppTokens>();

    return _PromptedField(
      prompt: block.prompt,
      description: block.description,
      child: Row(
        spacing: tokens.spaceLayoutGapSm,
        children: [
          Expanded(
            child: Button(
              onPressed: () => controller.setAnswer(block.key, true),
              selected: value == true,
              variants: const [ButtonColor.success, ButtonVariant.flat],
              child: Text(block.trueLabel),
            ),
          ),
          Expanded(
            child: Button(
              onPressed: () => controller.setAnswer(block.key, false),
              selected: value == false,
              variants: const [ButtonColor.error, ButtonVariant.flat],
              child: Text(block.falseLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptedField extends StatelessWidget {
  const _PromptedField({
    required this.prompt,
    required this.child,
    this.description,
  });

  final String prompt;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        MarkdownText(
          data: prompt,
          mode: MarkdownTextMode.previewSelectable,
          defaultMarkdownAlignment: WrapAlignment.start,
        ),
        if (description != null)
          MarkdownText(
            data: description!,
            mode: MarkdownTextMode.previewSelectable,
            defaultMarkdownAlignment: WrapAlignment.start,
          ),
        child,
      ],
    );
  }
}
