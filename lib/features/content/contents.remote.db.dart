import 'package:boo_mondai/lib.barrel.dart'
    show Content, SupabaseRemoteDB, ContentMapper;

class ContentsRemoteDB extends SupabaseRemoteDB<Content> {
  @override
  String get tableName => 'contents';

  @override
  Content Function(Map<String, dynamic>) get fromMap => ContentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Content item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Content item) => {'id': item.id};

  Future<List<Content>> getByDeck(String deckId) => selectMany(
    filters: {'deck_id': deckId, 'is_deleted': false},
    orderBy: 'created_at',
  );
}
