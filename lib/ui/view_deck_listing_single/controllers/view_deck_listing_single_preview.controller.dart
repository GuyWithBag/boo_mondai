import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckDownloadsService,
        Services,
        ViewCommentsController,
        ViewReviewsController,
        ViewDeckListingSingleController,
        DeckListing,
        Content,
        Profile;
import 'package:signals/signals_flutter.dart';

class ViewDeckListingSinglePreviewController
    implements ViewDeckListingSingleController {
  ViewDeckListingSinglePreviewController({
    required this.deck,
    required this.listing,
    required this.content,
    required this.profile,
    required this.sourceProfile,
    DeckDownloadsService? deckDownloadsService,
  }) : deckDownloadsService = deckDownloadsService ?? Services.deckDownloads {
    comments = ViewCommentsController(content.value);
    reviews = ViewReviewsController(content.value);
  }

  @override
  final Signal<Deck> deck;
  @override
  final Signal<DeckListing> listing;
  @override
  final Signal<Content> content;
  @override
  final Signal<Profile> profile;
  @override
  final Signal<Profile> sourceProfile;
  @override
  final error = signal<Exception?>(null);

  final DeckDownloadsService deckDownloadsService;
  late final ViewCommentsController comments;
  late final ViewReviewsController reviews;

  final isDownloading = signal<bool>(false);

  final isLoading = signal<bool>(false);

  // ToDo: refactor favorites
  late final isFavorite = computed(() {
    return false;
  });

  late final commentsCount = computed(() => comments.comments.length);
  late final reviewsCount = computed(() => reviews.comments.length);

  void onUpvotePressed() {}
  void onDownvotePressed() {}
  void onFavoritePressed() {}
  void onDownloadPressed() {}

  Future<void> onDownloadDeck() async {
    if (isDownloading.value) return;

    isDownloading.value = true;
    error.value = null;

    try {
      await deckDownloadsService.downloadDeck(deck.value);
    } on Exception catch (e) {
      error.value = e;
    } catch (e) {
      error.value = Exception(e.toString());
    } finally {
      isDownloading.value = false;
    }
  }
}
