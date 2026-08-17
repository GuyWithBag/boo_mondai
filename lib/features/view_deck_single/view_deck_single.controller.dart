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

  final BuildContext _context;
  final ViewDecksLocalController _parentController;

  Deck get deck => _deck;

  void _setDeck(Deck? updatedDeck) {
    if (updatedDeck == null) return;

    _deck = updatedDeck;
    notifyListeners();
    _parentController.load();
  }

  Future<void> onCreateListingPressed() async {
    if (_deck.isPublished) return;

    final shouldCreateListing = await showModal<bool>(
      context: _context,
      title: 'Create deck listing?',
      subtitle:
          'This will create a listing of this deck to publish online. You will have to publish it in the listing.',
      leading: const Icon(Icons.public_outlined),
      actions: [
        const ModalAction<bool>(value: false, label: 'Cancel'),
        const ModalAction<bool>(
          value: true,
          label: 'Create',
          color: ButtonColor.primary,
        ),
      ],
    );
    if (shouldCreateListing != true) return;

    _setDeck(await DecksService.createAndUpsertListing(deck));

    if (_context.mounted) {
      await showViewDeckListingSingleSheet(
        _context,
        deck,
        initialState: DeckListingSheetState.editor,
      );
    }
  }

  Future<void> showDeckPath() async {
    final mediaDirectoryPath = await DecksService.getDeckMediaDirectoryPath(
      _deck,
    );
    if (!_context.mounted) return;

    final coverStoredPath = DecksService.getDeckCoverImageStoredPath(_deck);
    final coverLocalPath = DecksService.getDeckCoverImageLocalPath(_deck);

    await showModal<void>(
      context: _context,
      leading: const Icon(Icons.folder_outlined),
      title: 'Deck path',
      child: SelectableText(
        [
          'Media directory:',
          mediaDirectoryPath,
          '',
          'Cover stored path:',
          coverStoredPath,
          '',
          'Cover local file:',
          coverLocalPath ?? 'No local cover image file found',
        ].join('\n'),
      ),
      showCancelButton: true,
    );
  }

  Future<void> setTitle(String value) async {
    final updatedDeck = await DecksService.setTitle(deck: _deck, title: value);
    _setDeck(updatedDeck);
  }

  Future<void> setShortDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      shortDescription: value,
    );
    _setDeck(updatedDeck);
  }

  Future<void> setLongDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      longDescription: value,
    );
    _setDeck(updatedDeck);
  }

  Future<void> setTags(List<String> tagNames) async {
    final updatedDeck = await DecksService.setTags(
      deck: _deck,
      tagNames: tagNames,
    );
    _setDeck(updatedDeck);
  }

  Future<void> onCoverImagePicked(PlatformFile file) async {
    final updatedDeck = await DecksService.setCoverImageUrl(
      deck: _deck,
      file: file,
    );
    _setDeck(updatedDeck);
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
