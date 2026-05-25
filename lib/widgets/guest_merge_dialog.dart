import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/app_choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum GuestMergeChoice { discard, merge }

Future<void> showGuestMergeDialog({
  required BuildContext context,
  required AuthController auth,
}) async {
  final choice = await showAppChoiceDialog<GuestMergeChoice>(
    context: context,
    barrierDismissible: false,
    title: 'You have local data',
    body:
        'Merge your decks and study progress into this account, or discard the local data and load your account data instead.',
    leading: const Icon(Icons.sync_alt),
    actions: const [
      AppDialogAction<GuestMergeChoice>(
        value: GuestMergeChoice.discard,
        label: 'Discard local data',
        tone: TactileTone.error,
      ),
      AppDialogAction<GuestMergeChoice>(
        value: GuestMergeChoice.merge,
        label: 'Merge into account',
        tone: TactileTone.filled,
      ),
    ],
  );

  if (choice == null || !context.mounted) return;

  context.go('/account');
  await auth.confirmMerge(choice == GuestMergeChoice.merge);
}
