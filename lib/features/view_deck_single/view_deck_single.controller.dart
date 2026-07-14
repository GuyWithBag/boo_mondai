import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        Controller,
        Deck,
        DeckListingSheetState,
        DecksService,
        ModalAction,
        ViewDecksLocalController,
        showViewDeckListingSingleSheet,
        showModal,
        ViewDeckSingleHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ViewDeckSingleSheetController extends Controller {
  ViewDeckSingleSheetController({
    required Deck initialDeck,
    required BuildContext context,
    required ViewDecksLocalController parentController,
  }) : _context = context,
       _parentController = parentController,
       _deck = initialDeck;

  Deck _deck;
  bool _isSavingPublishState = false;

  final BuildContext _context;
  final ViewDecksLocalController _parentController;

  Deck get deck => _deck;
  bool get isSavingPublishState => _isSavingPublishState;

  void _setDeck(Deck value) {
    _deck = value;
    notifyListeners();
  }

  void _setSavingPublishState(bool value) {
    _isSavingPublishState = value;
    notifyListeners();
  }

  void _applyUpdatedDeck(Deck? updatedDeck) {
    if (updatedDeck == null) return;

    _setDeck(updatedDeck);
    _parentController.load();
  }

  Future<void> setPublished(bool isPublished) async {
    if (_isSavingPublishState || _deck.isPublished == isPublished) return;

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

      final listingDeck = await DecksService.createListingDraft(_deck);
      _applyUpdatedDeck(listingDeck);

      if (_context.mounted) {
        await showViewDeckListingSingleSheet(
          _context,
          listingDeck,
          initialState: DeckListingSheetState.editor,
        );
      }
      return;
    }

    final actionLabel = isPublished ? 'Publish' : 'Unpublish';
    final confirmed = await showModal<bool>(
      context: _context,
      title: '$actionLabel deck?',
      subtitle: isPublished
          ? 'Publishing "${ViewDeckSingleHelper.title(_deck)}" makes it available after your next sync.'
          : 'Unpublishing "${ViewDeckSingleHelper.title(_deck)}" removes it from public browsing after your next sync.',
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

    _setSavingPublishState(true);

    try {
      final updatedDeck = await DecksService.update(
        deck: _deck,
        isPublished: isPublished,
      );
      _applyUpdatedDeck(updatedDeck);
    } finally {
      _setSavingPublishState(false);
    }
  }

  Future<void> updateTitle(String value) async {
    final updatedDeck = await DecksService.updateTitle(
      deck: _deck,
      title: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateShortDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      shortDescription: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateLongDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      longDescription: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateTags(List<String> tagNames) async {
    final updatedDeck = await DecksService.updateTags(
      deck: _deck,
      tagNames: tagNames,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> onCoverImagePicked(PlatformFile file) async {
    final updatedDeck = await DecksService.updateCoverImage(
      deck: _deck,
      file: file,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> deleteDeck() async {
    final confirmed = await showModal<bool>(
      context: _context,
      title: 'Delete deck?',
      subtitle:
          '"${ViewDeckSingleHelper.title(_deck)}" and all its cards will be removed.',
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

    await _parentController.deleteDeck(_deck.id);
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
  final sheetController = useMemoized(
    () => ViewDeckSingleSheetController(
      initialDeck: initialDeck,
      context: context,
      parentController: controller,
    ),
    [initialDeck.id, controller],
  );
  useListenable(sheetController);
  useEffect(() => sheetController.dispose, [sheetController]);

  return sheetController;
}
