import 'package:boo_mondai/lib.barrel.dart'
    show Deck, Content, DeckListing, Profile;
import 'package:signals_hooks/signals_hooks.dart';

interface class ViewDeckListingSingleController {
  ViewDeckListingSingleController({
    required this.deck,
    required this.content,
    required this.listing,
    required this.profile,
    required this.sourceProfile,
  });

  final error = signal<Exception?>(null);

  final Signal<Deck> deck;
  final Signal<Content> content;
  final Signal<DeckListing> listing;
  final Signal<Profile> profile;
  final Signal<Profile> sourceProfile;
}
