import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        ModalTone,
        ButtonColor,
        Button,
        LocalDB,
        Modal,
        ModalAction,
        showModal;
import 'package:flutter/material.dart' show BuildContext, Icons;
import 'package:flutter/widgets.dart' show Icon;
import 'package:provider/provider.dart' show ReadContext;

void showSignOutDialog(BuildContext context) {
  final auth = context.read<AuthController>();

  showModal<void>(
    context: context,
    tone: ModalTone.error,
    leading: const Icon(Icons.logout),
    title: 'Sign Out',
    subtitle:
        'Keep your local data on this device, or remove it after signing out.',
    actions: [
      ModalAction(value: null, label: 'Cancel'),
      ModalAction(
        value: null,
        label: 'Keep data',
        onPressed: () => auth.signOut(),
      ),
      ModalAction(
        value: null,
        label: 'Remove data',
        color: ButtonColor.error,
        onPressed: () async {
          await auth.signOut();
          await LocalDB.clearAll();
        },
      ),
    ],
  );
}
