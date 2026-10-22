// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/view_deck_downloads_appbar.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show AppBar;
import 'package:flutter/material.dart' hide AppBar;

class ViewDeckDownloadsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ViewDeckDownloadsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 32);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: 'Downloads',
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(32),
      //   child: Align(
      //     alignment: Alignment.centerLeft,
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 16, bottom: 10),
      //       child: Text(
      //         'Please keep the app open while decks are importing.',
      //         style: Theme.of(context).textTheme.bodySmall,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
