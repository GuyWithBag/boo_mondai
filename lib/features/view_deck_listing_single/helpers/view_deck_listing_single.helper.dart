import 'package:boo_mondai/core/helpers/text.helper.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';

abstract final class ViewDeckListingSingleHelper {
  static String title(Deck deck) {
    return TextHelper.defaultText(deck.title, 'Untitled deck');
  }

  static String shortDescription(Deck deck) {
    return TextHelper.defaultText(
      deck.shortDescription,
      'No short description yet.',
    );
  }

  static String longDescription(Deck deck) {
    return TextHelper.defaultText(
      deck.longDescription,
      'No long description yet.',
    );
  }

  static List<String> carouselImageUrls(Deck deck) {
    final imageUrls = <String>[
      ...?deck.listing?.featuredImages,
      ?deck.coverImageUrl,
    ].map((value) => value.trim()).where((value) => value.isNotEmpty).toSet();

    if (imageUrls.isNotEmpty) {
      return imageUrls.toList(growable: false);
    }

    return const [_fallbackImageUrl];
  }

  static String profileName(Deck deck) {
    return TextHelper.defaultText(deck.userProfile?.username, 'Unknown author');
  }

  static String? profileAvatarUrl(Deck deck) {
    return TextHelper.nonEmptyOrNull(deck.userProfile?.avatarUrl);
  }

  static String visibilityLabel(Deck deck) {
    return switch (deck.visibilityState.name) {
      'public' => 'Public',
      'unlisted' => 'Unlisted',
      _ => 'Private',
    };
  }

  static int downloadsCount(Deck deck) {
    return deck.listing?.downloadsCount ?? 0;
  }

  static int forksCount(Deck deck) {
    return deck.listing?.forksCount ?? 0;
  }
}

const _fallbackImageUrl = 'https://i.redd.it/jvu7xrv8qug11.jpg';
