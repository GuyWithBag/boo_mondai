import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        Deck,
        LocalDB,
        ModalAction,
        ViewDecksLocalController,
        showModal,
        ViewDeckSingleHelper;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewDeckSingleSheetController {
  const ViewDeckSingleSheetController({
    required this.deck,
    required this.isSavingPublishState,
    required this.onPublishedChanged,
    required this.onTitleChanged,
    required this.onShortDescriptionChanged,
    required this.onLongDescriptionChanged,
    required this.onTagsChanged,
    required this.onDeletePressed,
  });

  final Deck deck;
  final bool isSavingPublishState;
  final ValueChanged<bool> onPublishedChanged;
  final Future<void> Function(String value) onTitleChanged;
  final Future<void> Function(String value) onShortDescriptionChanged;
  final Future<void> Function(String value) onLongDescriptionChanged;
  final ValueChanged<List<String>> onTagsChanged;
  final VoidCallback onDeletePressed;
}

ViewDeckSingleSheetController useViewDeckSingleSheet({
  required BuildContext context,
  required Deck initialDeck,
  required ViewDecksLocalController controller,
}) {
  final deckListenable = useMemoized(() => LocalDB.deck.box.listenable());
  useListenable(deckListenable);

  final deck = LocalDB.deck.selectByPk({'id': initialDeck.id}) ?? initialDeck;
  final isSavingPublishState = useState(false);

  Future<void> setPublished(bool isPublished) async {
    if (isSavingPublishState.value || deck.isPublished == isPublished) {
      return;
    }

    final actionLabel = isPublished ? 'Publish' : 'Unpublish';
    final confirmed = await showModal<bool>(
      context: context,
      title: '$actionLabel deck?',
      subtitle: isPublished
          ? 'Publishing "${ViewDeckSingleHelper.title(deck)}" makes it available after your next sync.'
          : 'Unpublishing "${ViewDeckSingleHelper.title(deck)}" removes it from public browsing after your next sync.',
      leading: Icon(
        isPublished
            ? Icons.cloud_upload_outlined
            : Icons.visibility_off_outlined,
      ),
      actions: [
        const ModalAction<bool>(value: false, label: 'Cancel'),
        ModalAction<bool>(
          value: true,
          label: actionLabel,
          color: isPublished ? ButtonColor.success : ButtonColor.error,
        ),
      ],
    );
    if (confirmed != true) return;

    isSavingPublishState.value = true;

    try {
      final updated = await ViewDeckSingleHelper.updatePublishedState(
        deck: deck,
        isPublished: isPublished,
      );
      if (updated) {
        controller.load();
      }
    } finally {
      isSavingPublishState.value = false;
    }
  }

  Future<void> setTags(List<String> tagNames) async {
    final updated = await ViewDeckSingleHelper.updateTags(
      deck: deck,
      tagNames: tagNames,
    );
    if (updated) {
      controller.load();
    }
  }

  Future<void> setTitle(String value) async {
    final updated = await ViewDeckSingleHelper.updateTextField(
      deck: deck,
      value: value,
      allowEmpty: false,
      selectCurrentValue: (deck) => deck.title,
      copyWithValue: (deck, value) => deck.copyWith(title: value),
    );
    if (updated) {
      controller.load();
    }
  }

  Future<void> setShortDescription(String value) async {
    final updated = await ViewDeckSingleHelper.updateTextField(
      deck: deck,
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.shortDescription,
      copyWithValue: (deck, value) => deck.copyWith(shortDescription: value),
    );
    if (updated) {
      controller.load();
    }
  }

  Future<void> setLongDescription(String value) async {
    final updated = await ViewDeckSingleHelper.updateTextField(
      deck: deck,
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.longDescription,
      copyWithValue: (deck, value) => deck.copyWith(longDescription: value),
    );
    if (updated) {
      controller.load();
    }
  }

  Future<void> deleteDeckDialog() async {
    final confirmed = await showModal<bool>(
      context: context,
      title: 'Delete deck?',
      subtitle:
          '"${ViewDeckSingleHelper.title(deck)}" and all its cards will be removed.',
      leading: const Icon(Icons.delete_outline),
      actions: [
        const ModalAction<bool>(value: false, label: 'Cancel'),
        const ModalAction<bool>(
          value: true,
          label: 'Delete',
          color: ButtonColor.error,
        ),
      ],
    );

    if (confirmed != true) return;

    await controller.deleteDeck(deck.id);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  return ViewDeckSingleSheetController(
    deck: deck,
    isSavingPublishState: isSavingPublishState.value,
    onPublishedChanged: setPublished,
    onTitleChanged: setTitle,
    onShortDescriptionChanged: setShortDescription,
    onLongDescriptionChanged: setLongDescription,
    onTagsChanged: setTags,
    onDeletePressed: deleteDeckDialog,
  );
}
