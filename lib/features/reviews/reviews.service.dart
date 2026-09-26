import 'package:boo_mondai/lib.barrel.dart'
    show RemoteDB, Review, ReviewEditLog, DiscussionsService, Content;

class ReviewsService implements DiscussionsService {
  static Future<List<Review>> getByDeck(String deckId) async =>
      await RemoteDB.reviews.getByDeck(deckId);

  static Future<List<ReviewEditLog>> getEditLogs(Review review) async =>
      RemoteDB.reviewEditLogs.getByReview(review);

  static Future<void> add({
    required Review review,
    required Content content,
  }) async {
    await RemoteDB.comments.upsert(review.copyWith(body: review.body.trim()));
    await RemoteDB.contents.upsert(content);
  }

  // ToDo: Should check if the comment is already deleted
  static Future<void> upsert({
    required Review review,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    await RemoteDB.reviews.upsert(review);
  }
}
