import 'package:boo_mondai/lib.barrel.dart'
    show
        CachedProfile,
        ButtonTone,
        Deck,
        LocalDB,
        ModalAction,
        Tag,
        Profile,
        VisibilityState,
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
    required this.profileName,
    required this.profileAvatarUrl,
    required this.sourceProfileName,
    required this.sourceProfileAvatarUrl,
    required this.visibilityLabel,
    required this.isSavingPublishState,
    required this.onPublishedChanged,
    required this.onTitleChanged,
    required this.onShortDescriptionChanged,
    required this.onLongDescriptionChanged,
    required this.onTagsChanged,
  });

  final Deck? deck;
  final String title;
  final String shortDescription;
  final String longDescription;
  final String? coverImageUrl;
  final String profileName;
  final String? profileAvatarUrl;
  final String? sourceProfileName;
  final String? sourceProfileAvatarUrl;
  final String visibilityLabel;
  final bool isSavingPublishState;
  final ValueChanged<bool> onPublishedChanged;
  final Future<void> Function(String value) onTitleChanged;
  final Future<void> Function(String value) onShortDescriptionChanged;
  final Future<void> Function(String value) onLongDescriptionChanged;
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
  final profile = deck == null
      ? null
      : LocalDB.cachedProfile.selectByPk({'id': deck.userId}) ??
            LocalDB.profile.getOrCreate();
  final profileName = switch (profile) {
    CachedProfile(:final username) => username,
    Profile(:final username) => username,
    _ => 'Unknown user',
  };
  final profileAvatarUrl = switch (profile) {
    CachedProfile(:final avatarUrl) => avatarUrl,
    Profile(:final avatarUrl) => avatarUrl,
    _ => null,
  };
  final sourceDeck = deck?.sourceDeckId == null
      ? null
      : LocalDB.deck.selectByPk({'id': deck!.sourceDeckId});
  final sourceProfile = sourceDeck == null
      ? null
      : LocalDB.cachedProfile.selectByPk({'id': sourceDeck.userId});
  final sourceProfileName = sourceProfile?.username;
  final sourceProfileAvatarUrl = sourceProfile?.avatarUrl;
  final visibilityLabel = deck == null
      ? 'Private'
      : switch (deck.visibilityState) {
          VisibilityState.private => 'Private',
          VisibilityState.public => 'Public',
          VisibilityState.unlisted => 'Unlisted',
        };

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

  Future<void> setTitle(String value) {
    return _updateDeckText(
      deck: deck,
      controller: controller,
      value: value,
      allowEmpty: false,
      selectCurrentValue: (deck) => deck.title,
      copyWithValue: (deck, value) => deck.copyWith(title: value),
    );
  }

  Future<void> setShortDescription(String value) {
    return _updateDeckText(
      deck: deck,
      controller: controller,
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.shortDescription,
      copyWithValue: (deck, value) => deck.copyWith(shortDescription: value),
    );
  }

  Future<void> setLongDescription(String value) {
    return _updateDeckText(
      deck: deck,
      controller: controller,
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.longDescription,
      copyWithValue: (deck, value) => deck.copyWith(longDescription: value),
    );
  }

  return ViewDeckLocalSheetState(
    deck: deck,
    title: title,
    shortDescription: shortDescription,
    longDescription: longDescription,
    coverImageUrl: coverImageUrl,
    profileName: profileName,
    profileAvatarUrl: profileAvatarUrl,
    sourceProfileName: sourceProfileName,
    sourceProfileAvatarUrl: sourceProfileAvatarUrl,
    visibilityLabel: visibilityLabel,
    isSavingPublishState: isSavingPublishState.value,
    onPublishedChanged: setPublished,
    onTitleChanged: setTitle,
    onShortDescriptionChanged: setShortDescription,
    onLongDescriptionChanged: setLongDescription,
    onTagsChanged: setTags,
  );
}

Future<void> _updateDeckText({
  required Deck? deck,
  required ViewDecksLocalController controller,
  required String value,
  required bool allowEmpty,
  required String Function(Deck deck) selectCurrentValue,
  required Deck Function(Deck deck, String value) copyWithValue,
}) async {
  if (deck == null || !deck.isEditable) {
    return;
  }

  final trimmedValue = value.trim();
  if (!allowEmpty && trimmedValue.isEmpty) {
    return;
  }
  if (trimmedValue == selectCurrentValue(deck)) {
    return;
  }

  final updatedDeck = copyWithValue(
    deck,
    trimmedValue,
  ).copyWith(updatedAt: DateTime.now());

  await LocalDB.deck.upsert(updatedDeck);
  controller.load();
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
