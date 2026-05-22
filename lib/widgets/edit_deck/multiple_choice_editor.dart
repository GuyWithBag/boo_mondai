import 'package:boo_mondai/widgets/edit_deck/multiple_choice_options_panel.dart';
import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';

import '../../widgets/text_field_card.dart';
import 'responsive_two_column.dart';

class MultipleChoiceEditor extends StatelessWidget {
  const MultipleChoiceEditor({
    required this.promptController,
    required this.options,
    required this.onOptionAdd,
    required this.onOptionRemove,
    required this.onOptionUpdate,
    super.key,
  });

  final TextEditingController promptController;
  final List<MultipleChoiceOptionData> options;
  final VoidCallback onOptionAdd;
  final ValueChanged<int> onOptionRemove;
  final void Function(int index, MultipleChoiceOptionData option)
  onOptionUpdate;

  @override
  Widget build(BuildContext context) {
    return ResponsiveTwoColumn(
      children: [
        TextFieldCard(
          title: 'Front (Prompt)',
          placeholder: 'Type a question...',
          controller: promptController,
        ),
        MultipleChoiceOptionsPanel(
          options: options,
          onOptionAdd: onOptionAdd,
          onOptionRemove: onOptionRemove,
          onOptionUpdate: onOptionUpdate,
        ),
      ],
    );
  }
}
