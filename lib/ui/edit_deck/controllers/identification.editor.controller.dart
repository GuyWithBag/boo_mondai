import 'package:boo_mondai/lib.barrel.dart'
    show
        CasingType,
        IdentificationAnswer,
        IdentificationAnswerData,
        IdentificationAnswerHelper,
        IdentificationTemplate,
        defaultIdentificationAnswers,
        uuid;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class IdentificationEditorController {
  IdentificationEditorController({
    required this.template,
    required this.onChanged,
  }) {
    promptController.text = template.promptText;
    promptText.value = template.promptText;
    verticallyCentered.value = template.verticallyCentered;
    final sorted = template.acceptedAnswers.toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    answers.value = sorted.isEmpty
        ? [...defaultIdentificationAnswers]
        : [
            for (final answer in sorted)
              IdentificationAnswerData(
                answer: answer.answer,
                casingType: answer.casingType,
              ),
          ];

    var didInitialize = false;
    emitEffect = effect(() {
      final nextTemplate = buildTemplate();

      if (!didInitialize) {
        didInitialize = true;
        return;
      }

      Future.microtask(() {
        if (_isDisposed) return;
        onChanged(nextTemplate);
      });
    });
  }

  final IdentificationTemplate template;
  final ValueChanged<IdentificationTemplate> onChanged;

  final promptController = TextEditingController();
  final promptText = signal('');
  final verticallyCentered = signal(true);
  final answers = signal<List<IdentificationAnswerData>>(const []);
  late final EffectCleanup emitEffect;

  bool _isDisposed = false;

  void updatePrompt(String value) {
    if (_isDisposed) return;
    promptText.value = value;
  }

  void updateVerticallyCentered(bool value) {
    if (_isDisposed) return;
    verticallyCentered.value = value;
  }

  void addAnswer() {
    if (_isDisposed) return;
    answers.value = IdentificationAnswerHelper.add(answers.value);
  }

  void removeAnswer(int index) {
    if (_isDisposed) return;
    answers.value = IdentificationAnswerHelper.removeAt(answers.value, index);
  }

  void updateAnswer(int index, String answer) {
    if (_isDisposed) return;
    answers.value = IdentificationAnswerHelper.updateAnswerAt(
      answers.value,
      index,
      answer,
    );
  }

  void updateCasingType(int index, CasingType casingType) {
    if (_isDisposed) return;
    answers.value = IdentificationAnswerHelper.updateCasingTypeAt(
      answers.value,
      index,
      casingType,
    );
  }

  void moveAnswerUp(int index) {
    if (_isDisposed) return;
    answers.value = IdentificationAnswerHelper.move(
      answers.value,
      index,
      index - 1,
    );
  }

  void moveAnswerDown(int index) {
    if (_isDisposed) return;
    answers.value = IdentificationAnswerHelper.move(
      answers.value,
      index,
      index + 1,
    );
  }

  IdentificationTemplate buildTemplate() {
    return IdentificationTemplate(
      id: template.id,
      deckId: template.deckId,
      sortOrder: template.sortOrder,
      createdAt: template.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: template.deletedAt,
      purgeAfter: template.purgeAfter,
      sourceTemplateId: template.sourceTemplateId,
      tags: template.tags,
      verticallyCentered: verticallyCentered.value,
      promptText: promptText.value,
      acceptedAnswers: buildAnswers(),
    );
  }

  List<IdentificationAnswer> buildAnswers() {
    final filled = answers.value
        .map(
          (answer) => IdentificationAnswerData(
            answer: answer.answer.trim(),
            casingType: answer.casingType,
          ),
        )
        .where((answer) => answer.answer.isNotEmpty)
        .toList();

    return [
      for (final entry in filled.asMap().entries)
        IdentificationAnswer(
          id: uuid.v7(),
          templateId: template.id,
          displayOrder: entry.key,
          answer: entry.value.answer,
          casingType: entry.value.casingType,
        ),
    ];
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    emitEffect();
    promptController.dispose();
    promptText.dispose();
    verticallyCentered.dispose();
    answers.dispose();
  }
}
