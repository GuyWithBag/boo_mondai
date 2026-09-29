import 'dart:async' show Completer;

import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        AuthService,
        DeckListing,
        Content,
        Profile,
        DeckListingsService,
        ImageHelper,
        ProfileService;
import 'package:flutter/material.dart' show ImageProvider, NetworkImage;
import 'package:signals/signals_core.dart';

class DeckListingTileController {
  DeckListingTileController({
    required this.deck,
    required this.listing,
    required this.content,
    required this.profile,
    required this.sourceProfile,
    this.isUserOwned = true,
  });

  final Deck deck;
  final DeckListing listing;
  final Content content;
  final Profile profile;
  final Profile sourceProfile;
  final bool isUserOwned;

  final isFavorite = computed(() => false);
  final isLoading = signal(false);
  final error = signal<Exception?>(null);
  final backgroundImage = signal<ImageProvider?>(null);
  final profileAvatar = signal<ImageProvider?>(null);

  late final tags = computed(() => deck.tags.take(8).toList());
  late final title = computed(
    () => deck.title.isEmpty ? 'Untitled deck' : deck.title,
  );
  late final description = computed(
    () => deck.shortDescription.isEmpty
        ? 'No description yet'
        : deck.shortDescription,
  );
  late final version = computed(
    () => deck.version.isEmpty ? '1.0.0' : deck.version,
  );
  late final featuredImageSource = computed(
    () => DeckListingsService.getFeaturedImage(deck: deck, listing: listing),
  );

  late final FutureSignal<ImageProvider?> backgroundImageFuture = futureSignal(
    () => ImageHelper.getImageProviderFromSource(featuredImageSource.value),
  );

  late final FutureSignal<ImageProvider?> profileAvatarFuture = futureSignal(
    () async {
      if (isUserOwned) return NetworkImage(profile.avatarUrl ?? '');

      final avatar = Completer<ImageProvider?>();
      await ProfileService.getAvatar((image) {
        if (!avatar.isCompleted) avatar.complete(image);
      });
      return avatar.future;
    },
  );

  late final backgroundImageEffect = effect(() {
    backgroundImageFuture.value.map(
      error: () {},
      loading: () {},
      data: (value) {
        backgroundImage.value = value;
      },
    );
  });

  late final profileAvatarEffect = effect(() {
    profileAvatarFuture.value.map(
      error: () {},
      loading: () {},
      data: (value) {
        profileAvatar.value = value;
      },
    );
  });

  Future<void> toggleUpvote() async {
    if (!_canInteract()) return;
  }

  Future<void> toggleDownvote() async {
    if (!_canInteract()) return;
  }

  Future<void> toggleFavorite() async {
    if (!_canInteract()) return;
  }

  bool _canInteract() {
    if (isLoading.value) return false;

    if (!AuthService.isAuthenticatedRemote) {
      error.value = Exception('Sign in to vote or favorite decks.');
      return false;
    }

    return true;
  }

  void dispose() {
    profileAvatarEffect();
    backgroundImageEffect();
    // FutureSignal can complete after this controller is disposed. Its
    // effects are detached above; do not dispose an in-flight FutureSignal.
    featuredImageSource.dispose();
    version.dispose();
    description.dispose();
    title.dispose();
    tags.dispose();
    profileAvatar.dispose();
    backgroundImage.dispose();
    error.dispose();
    isLoading.dispose();
    isFavorite.dispose();
  }
}
