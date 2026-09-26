import 'package:boo_mondai/lib.barrel.dart'
    show Comment, Content, CommentEditLog;

interface class DiscussionsService {
  static Future<List<T>> getByDeck<T extends Comment>(String deckId) async =>
      throw UnimplementedError();

  static Future<List<V>>
  getEditLogs<T extends Comment, V extends CommentEditLog>(T comment) async =>
      throw UnimplementedError();

  static Future<void> add<T extends Comment>({
    required T comment,
    required Content content,
  }) => throw UnimplementedError();

  static Future<void> upsert<T extends Comment>({required T comment}) =>
      throw UnimplementedError();
}
