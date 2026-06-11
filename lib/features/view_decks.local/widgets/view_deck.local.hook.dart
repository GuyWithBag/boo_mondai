import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonTone,
        Deck,
        LocalDB,
        ModalAction,
        Tag,
        ViewDecksLocalController,
        showChoiceModal;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewDeckLocalSheetState {
  const ViewDeckLocalSheetState({
    required this.deck,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.coverImageUrl,
    required this.isSavingPublishState,
    required this.onPublishedChanged,
    required this.onTagsChanged,
  });

  final Deck? deck;
  final String title;
  final String shortDescription;
  final String longDescription;
  final String? coverImageUrl;
  final bool isSavingPublishState;
  final ValueChanged<bool> onPublishedChanged;
  final ValueChanged<List<String>> onTagsChanged;
}

ViewDeckLocalSheetState useViewDeckLocalSheet({
  required BuildContext context,
  required String deckId,
  required ViewDecksLocalController controller,
}) {
  final deckListenable = useMemoized(() => LocalDB.deck.box.listenable());
  useListenable(deckListenable);

  final deck = LocalDB.deck.selectByPk({'id': deckId});
  final isSavingPublishState = useState(false);

  final title = deck == null || deck.title.isEmpty
      ? 'Untitled deck'
      : deck.title;
  final shortDescription = deck == null || deck.shortDescription.isEmpty
      ? 'No short description yet.'
      : deck.shortDescription;
  final longDescription = deck == null || deck.longDescription.isEmpty
      ? 'No long description yet.'
      : deck.longDescription;
  final coverImageUrl = _nonEmptyOrNull(deck?.coverImageUrl);

  Future<void> setPublished(bool isPublished) async {
    if (deck == null ||
        isSavingPublishState.value ||
        deck.isPublished == isPublished) {
      return;
    }

    final actionLabel = isPublished ? 'Publish' : 'Unpublish';
    final confirmed = await showChoiceModal<bool>(
      context: context,
      title: '$actionLabel deck?',
      body: isPublished
          ? 'Publishing "$title" makes it available after your next sync.'
          : 'Unpublishing "$title" removes it from public browsing after your next sync.',
      leading: Icon(
        isPublished
            ? Icons.cloud_upload_outlined
            : Icons.visibility_off_outlined,
      ),
      actions: [
        const ModalAction<bool>(
          value: false,
          label: 'Cancel',
          tone: ButtonTone.ghost,
        ),
        ModalAction<bool>(
          value: true,
          label: actionLabel,
          tone: isPublished ? ButtonTone.success : ButtonTone.error,
        ),
      ],
    );
    if (confirmed != true) return;

    isSavingPublishState.value = true;
    final updatedDeck = deck.copyWith(
      isPublished: isPublished,
      updatedAt: DateTime.now(),
    );

    try {
      await LocalDB.deck.upsert(updatedDeck);
      controller.load();
    } finally {
      isSavingPublishState.value = false;
    }
  }

  Future<void> setTags(List<String> tagNames) async {
    if (deck == null) {
      return;
    }

    final normalizedTagNames = tagNames
        .map((tagName) => tagName.trim())
        .where((tagName) => tagName.isNotEmpty)
        .toList();
    final currentTagNames = deck.tags.map((tag) => tag.name).toList();

    if (normalizedTagNames.length == currentTagNames.length &&
        _sameTagNames(normalizedTagNames, currentTagNames)) {
      return;
    }

    final existingTagsByName = {
      for (final tag in deck.tags) tag.name.toLowerCase(): tag,
    };
    final updatedTags = [
      for (final tagName in normalizedTagNames)
        existingTagsByName[tagName.toLowerCase()] ??
            Tag.createNow(name: tagName, userId: deck.userId),
    ];

    final updatedDeck = deck.copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    controller.load();
  }

  return ViewDeckLocalSheetState(
    deck: deck,
    title: title,
    shortDescription: shortDescription,
    longDescription: longDescription,
    coverImageUrl: coverImageUrl,
    isSavingPublishState: isSavingPublishState.value,
    onPublishedChanged: setPublished,
    onTagsChanged: setTags,
  );
}

String? _nonEmptyOrNull(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  return value;
}

bool _sameTagNames(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) {
      return false;
    }
  }

  return true;
}
