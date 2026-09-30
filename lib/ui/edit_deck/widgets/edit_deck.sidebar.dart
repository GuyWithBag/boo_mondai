import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        FlashcardTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchingTypeTemplate,
        IdentificationTemplate,
        WordScrambleTemplate,
        AppTokens,
        Button,
        PanelHeader,
        ButtonColor,
        ButtonVariant,
        EditDeckController;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckSideBar extends SignalWidget {
  const EditDeckSideBar({super.key, required this.controller});

  final EditDeckController controller;

  IconData _iconFor(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate _ => Icons.slideshow_outlined,
      MultipleChoiceTemplate _ => Icons.list,
      FillInTheBlanksTemplate _ => Icons.draw,
      MatchingTypeTemplate _ => Icons.shuffle,
      IdentificationTemplate _ => Icons.border_color_outlined,
      WordScrambleTemplate _ => Icons.sort_by_alpha,
      _ => Icons.help_outline,
    };
  }

  String _labelFor(CardTemplate template) {
    final text = switch (template) {
      FlashcardTemplate f => f.frontText,
      MultipleChoiceTemplate m => m.questionPrompt,
      FillInTheBlanksTemplate fb => fb.promptText,
      MatchingTypeTemplate mm =>
        mm.values.isNotEmpty
            ? '${mm.values.first.text} / ${mm.values[1].text}'
            : '',
      IdentificationTemplate i => i.promptText,
      WordScrambleTemplate ws => ws.sentenceToScramble,
      _ => '',
    };

    return text.trim().isEmpty ? '(empty card)' : text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final templates = controller.templates.value;
    final selectedTemplateId = controller.selectedTemplateId.value;

    return Container(
      width: 288.w,
      decoration: BoxDecoration(
        color: tokens.colorSurfaceBackground,
        border: Border(
          right: BorderSide(color: tokens.colorBorderNeutralSubtle, width: 2),
        ),
      ),
      child: Column(
        children: [
          PanelHeader(
            title: 'Cards (${templates.length})',
            trailing: Button(
              leading: const Icon(Icons.add),
              onPressed: () => controller.addTemplate(context),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                for (final entry in templates.asMap().entries) ...[
                  Button(
                    elevated: false,
                    selected: entry.value.id == selectedTemplateId,
                    onPressed: entry.value.id == selectedTemplateId
                        ? null
                        : () => controller.selectTemplate(entry.value.id),
                    leading: Icon(_iconFor(entry.value)),
                    mainAxisAlignment: MainAxisAlignment.start,
                    variants: const [ButtonVariant.text, ButtonColor.baseline],
                    child: Text(
                      _labelFor(entry.value),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
