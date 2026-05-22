import 'package:flutter/material.dart';

import '../../widgets/tactile_button.dart';

class FormatSelector extends StatelessWidget {
  const FormatSelector({
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final formats = [
      (Icons.slideshow_outlined, 'Flashcard'),
      (Icons.list, 'Multiple Choice'),
      (Icons.draw, 'Fill in Blanks'),
      (Icons.shuffle, 'Match Madness'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < formats.length; index++) ...[
            TactileButton(
              leading: Icon(formats[index].$1),
              selected: selectedIndex == index,
              onPressed: () => onChanged(index),
              child: Text(formats[index].$2, style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }
}
