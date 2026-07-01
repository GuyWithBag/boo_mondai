import 'package:boo_mondai/core/helpers/text.helper.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/local_images/helpers/local_image_resolver.helper.dart';

final class ViewDeckListingSingleHelper {
  const ViewDeckListingSingleHelper();

  String title(Deck deck) {
    return TextHelper.getTrimmedTextOrFallback(deck.title, 'Untitled deck');
  }

  String shortDescription(Deck deck) {
    return TextHelper.getTrimmedTextOrFallback(
      deck.shortDescription,
      'No short description yet.',
    );
  }

  String longDescription(Deck deck) {
    return TextHelper.getTrimmedTextOrFallback(
      deck.longDescription,
      'No long description yet.',
    );
  }

  List<String> carouselImageUrls(Deck deck) {
    return LocalImageResolverHelper.resolveDeckListingCarouselImages(deck)
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  String profileName(Deck deck) {
    return TextHelper.getTrimmedTextOrFallback(
      deck.userProfile?.username,
      'Unknown author',
    );
  }

  String? profileAvatarUrl(Deck deck) {
    final profile = deck.userProfile;
    if (profile == null) return null;
    return TextHelper.getTrimmedTextOrNull(
      LocalImageResolverHelper.resolveCachedProfileAvatar(profile),
    );
  }

  String visibilityLabel(Deck deck) {
    return switch (deck.visibilityState.name) {
      'public' => 'Public',
      'unlisted' => 'Unlisted',
      _ => 'Private',
    };
  }

  int downloadsCount(Deck deck) {
    return deck.listing?.downloadsCount ?? 0;
  }

  int forksCount(Deck deck) {
    return deck.listing?.forksCount ?? 0;
  }

  Deck? deckById(List<Deck> decks, String deckId) {
    for (final deck in decks) {
      if (deck.id == deckId) return deck;
    }
    return null;
  }
}
