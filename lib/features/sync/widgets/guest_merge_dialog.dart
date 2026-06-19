import 'package:boo_mondai/lib.barrel.dart'
    show AuthController, showModal, ButtonColor, ModalAction;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum GuestMergeChoice { discard, merge }

Future<void> showGuestMergeDialog({
  required BuildContext context,
  required AuthController auth,
}) async {
  final choice = await showModal<GuestMergeChoice>(
    context: context,
    barrierDismissible: false,
    title: 'You have local data',
    subtitle:
        'Merge your decks and study progress into this account, or discard the local data and load your account data instead.',
    leading: const Icon(Icons.sync_alt),
    actions: const [
      ModalAction<GuestMergeChoice>(
        value: GuestMergeChoice.discard,
        label: 'Discard local data',
        color: ButtonColor.error,
      ),
      ModalAction<GuestMergeChoice>(
        value: GuestMergeChoice.merge,
        label: 'Merge into account',
        color: ButtonColor.error,
      ),
    ],
  );

  if (choice == null || !context.mounted) return;

  context.go('/account');
  await auth.confirmMerge(choice == GuestMergeChoice.merge);
}
