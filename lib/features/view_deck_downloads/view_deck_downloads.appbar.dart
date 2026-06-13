// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/view_deck_downloads_appbar.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class ViewDeckDownloadsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const ViewDeckDownloadsAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 32);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Downloads'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(32),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Please keep the app open while decks are importing.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}
