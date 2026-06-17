import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        FlashcardTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchMadnessTemplate,
        IdentificationTemplate,
        WordScrambleTemplate,
        AppTokens,
        Button,
        PanelHeader,
        ButtonTone;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckSidebar extends StatelessWidget {
  const EditDeckSidebar({
    required this.templates,
    required this.activeTemplateId,
    required this.onAdd,
    required this.onTemplateSelected,
    super.key,
  });

  final List<CardTemplate> templates;
  final String? activeTemplateId;
  final VoidCallback onAdd;
  final ValueChanged<String> onTemplateSelected;

  IconData _iconFor(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate _ => Icons.slideshow_outlined,
      MultipleChoiceTemplate _ => Icons.list,
      FillInTheBlanksTemplate _ => Icons.draw,
      MatchMadnessTemplate _ => Icons.shuffle,
      IdentificationTemplate _ => Icons.border_color_outlined,
      WordScrambleTemplate _ => Icons.sort_by_alpha,
      _ => Icons.help_outline,
    };
  }

  String _labelFor(CardTemplate template) {
    final text = switch (template) {
      FlashcardTemplate f => f.frontText,
      MultipleChoiceTemplate m => m.questionPrompt,
      FillInTheBlanksTemplate fb =>
        fb.segments.isNotEmpty ? fb.segments.first.fullText : '',
      MatchMadnessTemplate mm =>
        mm.pairs.isNotEmpty
            ? '${mm.pairs.first.term} / ${mm.pairs.first.match}'
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
            trailing: Button.icon(onPressed: onAdd, icon: Icons.add),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                for (final template in templates) ...[
                  Button(
                    selected: template.id == activeTemplateId,
                    onPressed: template.id == activeTemplateId
                        ? null
                        : () => onTemplateSelected(template.id),
                    leading: Icon(_iconFor(template)),
                    mainAxisAlignment: MainAxisAlignment.start,
                    variants: const [ButtonTone.textGhostSelect],
                    child: Text(
                      _labelFor(template),
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
