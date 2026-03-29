// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card/deck_popup_menu.dart
// PURPOSE: Popup menu with push and delete actions for a deck card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class DeckPopupMenu extends StatelessWidget {
  const DeckPopupMenu({super.key, this.onDelete, this.onPush});

  final VoidCallback? onDelete;
  final VoidCallback? onPush;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconSize: 18,
      padding: EdgeInsets.zero,
      tooltip: 'Deck options',
      onSelected: (value) {
        if (value == 'push') onPush?.call();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => [
        if (onPush != null)
          const PopupMenuItem(
            value: 'push',
            child: Row(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 18),
                SizedBox(width: 8),
                Text('Push changes'),
              ],
            ),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }
}
