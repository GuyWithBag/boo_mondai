import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        Deck,
        DeckListing,
        DeckListingSheetMode,
        LocalDB,
        ModalAction,
        ViewDecksLocalController,
        showViewDeckListingSingleSheet,
        showModal,
        ViewDeckSingleHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewDeckSingleSheetController {
  ViewDeckSingleSheetController({
    required this.deck,
    required this.isSavingPublishState,
    required BuildContext context,
    required ViewDecksLocalController parentController,
    required ValueNotifier<bool> isSavingPublishStateNotifier,
  })  : _context = context,
        _parentController = parentController,
        _isSavingPublishStateNotifier = isSavingPublishStateNotifier;

  final Deck deck;
  final bool isSavingPublishState;

  final BuildContext _context;
  final ViewDecksLocalController _parentController;
  final ValueNotifier<bool> _isSavingPublishStateNotifier;

  Future<void> setPublished(bool isPublished) async {
    if (isSavingPublishState || deck.isPublished == isPublished) return;

    if (isPublished) {
      final confirmed = await showModal<bool>(
        context: _context,
        title: 'Create deck listing?',
        subtitle:
            'This will create a listing of this deck to publish online. You will have to publish it in the listing.',
        leading: const Icon(Icons.public_outlined),
        actions: [
          const ModalAction<bool>(value: false, label: 'Cancel'),
          const ModalAction<bool>(
            value: true,
            label: 'Create Listing',
            color: ButtonColor.primary,
          ),
        ],
      );
      if (confirmed != true) return;

      final now = DateTime.now();
      final listing = DeckListing(
        deckId: deck.id,
        createdAt: now,
        updatedAt: now,
      );
      final listingDeck = deck.copyWith(listing: listing, updatedAt: now);
      await LocalDB.deck.upsert(listingDeck);
      await LocalDB.deckListing.upsert(listing);
      _parentController.load();

      if (_context.mounted) {
        await showViewDeckListingSingleSheet(
          _context,
          listingDeck,
          initialMode: DeckListingSheetMode.editor,
        );
      }
      return;
    }

    final actionLabel = isPublished ? 'Publish' : 'Unpublish';
    final confirmed = await showModal<bool>(
      context: _context,
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

    _isSavingPublishStateNotifier.value = true;

    try {
      final updated = await ViewDeckSingleHelper.updatePublishedState(
        deck: deck,
        isPublished: isPublished,
      );
      if (updated) {
        _parentController.load();
      }
    } finally {
      _isSavingPublishStateNotifier.value = false;
    }
  }

  Future<void> updateTitle(String value) async {
    final updated = await ViewDeckSingleHelper.updateTextField(
      deck: deck,
      value: value,
      allowEmpty: false,
      selectCurrentValue: (deck) => deck.title,
      copyWithValue: (deck, value) => deck.copyWith(title: value),
    );
    if (updated) _parentController.load();
  }

  Future<void> updateShortDescription(String value) async {
    final updated = await ViewDeckSingleHelper.updateTextField(
      deck: deck,
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.shortDescription,
      copyWithValue: (deck, value) => deck.copyWith(shortDescription: value),
    );
    if (updated) _parentController.load();
  }

  Future<void> updateLongDescription(String value) async {
    final updated = await ViewDeckSingleHelper.updateTextField(
      deck: deck,
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.longDescription,
      copyWithValue: (deck, value) => deck.copyWith(longDescription: value),
    );
    if (updated) _parentController.load();
  }

  Future<void> updateTags(List<String> tagNames) async {
    final updated = await ViewDeckSingleHelper.updateTags(
      deck: deck,
      tagNames: tagNames,
    );
    if (updated) _parentController.load();
  }

  Future<void> updateCoverImage(PlatformFile file) async {
    final updated = await ViewDeckSingleHelper.updateCoverImage(
      deck: deck,
      file: file,
    );
    if (updated) _parentController.load();
  }

  Future<void> deleteDeck() async {
    final confirmed = await showModal<bool>(
      context: _context,
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

    await _parentController.deleteDeck(deck.id);
    if (_context.mounted) {
      Navigator.of(_context).pop();
    }
  }
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

  return ViewDeckSingleSheetController(
    deck: deck,
    isSavingPublishState: isSavingPublishState.value,
    context: context,
    parentController: controller,
    isSavingPublishStateNotifier: isSavingPublishState,
  );
}
