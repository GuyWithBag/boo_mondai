import 'package:boo_mondai/lib.barrel.dart'
    show
        CommentWithDepth,
        Review,
        RemoteDB,
        Content,
        ReviewMapper,
        ContentMapper,
        ProfileMapper;
import 'package:signals_hooks/signals_hooks.dart';

class ViewReviewsController {
  ViewReviewsController(Content rootContent) {
    loadReviews(rootContent);
  }

  late final comments = listSignal<CommentWithDepth<Review>>([]);

  Future<void> loadReviews(Content rootContent) async {
    // final response = RemoteDB.reviews.query.select('*').eq();
    final response = await RemoteDB.reviews.query
        .select('*, contents!inner(*), profiles!inner(*)')
        .eq('contents.root_content_id', rootContent.id)
        .order('created_at', ascending: false);

    final reviews = <CommentWithDepth<Review>>[];
    for (int i = 0; i < response.length; i++) {
      final row = response[i];
      final review = ReviewMapper.fromMap(row);
      final content = ContentMapper.fromMap(row['contents']);
      final profile = ProfileMapper.fromMap(row['profiles']);
      final commentWithDepth = CommentWithDepth<Review>(
        content: content,
        owner: review,
        depth: 0,
        order: i,
        profile: profile,
      );
      reviews.add(commentWithDepth);
    }
    comments.value = [...comments.value, ...reviews];
  }

  Future<int> getCommentsCount(Content reviewContent) async {
    final response = await RemoteDB.reviews.query
        .select('id, comments!inner(id)')
        .count();
    return response.count;
  }
}
