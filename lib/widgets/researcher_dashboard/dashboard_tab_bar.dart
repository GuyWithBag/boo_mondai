// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/dashboard_tab_bar.dart
// PURPOSE: Tab bar for switching between Codes, Participants, and Results tabs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DashboardTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DashboardTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TabButton(
          label: 'Codes',
          isSelected: selectedIndex == 0,
          onTap: () => onChanged(0),
        ),
        TabButton(
          label: 'Participants',
          isSelected: selectedIndex == 1,
          onTap: () => onChanged(1),
        ),
        TabButton(
          label: 'Results',
          isSelected: selectedIndex == 2,
          onTap: () => onChanged(2),
        ),
      ],
    );
  }
}
