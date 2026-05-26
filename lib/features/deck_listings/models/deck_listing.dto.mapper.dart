// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_listing.dto.dart';

class DeckListingMapper extends ClassMapperBase<DeckListing> {
  DeckListingMapper._();

  static DeckListingMapper? _instance;
  static DeckListingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckListingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeckListing';

  static int _$upvotesCount(DeckListing v) => v.upvotesCount;
  static const Field<DeckListing, int> _f$upvotesCount = Field(
      'upvotesCount', _$upvotesCount,
      key: r'upvotes_count', opt: true, def: 0);
  static int _$downvotesCount(DeckListing v) => v.downvotesCount;
  static const Field<DeckListing, int> _f$downvotesCount = Field(
      'downvotesCount', _$downvotesCount,
      key: r'downvotes_count', opt: true, def: 0);
  static int _$downloadsCount(DeckListing v) => v.downloadsCount;
  static const Field<DeckListing, int> _f$downloadsCount = Field(
      'downloadsCount', _$downloadsCount,
      key: r'downloads_count', opt: true, def: 0);
  static int _$favoritesCount(DeckListing v) => v.favoritesCount;
  static const Field<DeckListing, int> _f$favoritesCount = Field(
      'favoritesCount', _$favoritesCount,
      key: r'favorites_count', opt: true, def: 0);
  static int _$forksCount(DeckListing v) => v.forksCount;
  static const Field<DeckListing, int> _f$forksCount =
      Field('forksCount', _$forksCount, key: r'forks_count', opt: true, def: 0);
  static int _$commentsCount(DeckListing v) => v.commentsCount;
  static const Field<DeckListing, int> _f$commentsCount = Field(
      'commentsCount', _$commentsCount,
      key: r'comments_count', opt: true, def: 0);
  static int _$reviewsCount(DeckListing v) => v.reviewsCount;
  static const Field<DeckListing, int> _f$reviewsCount = Field(
      'reviewsCount', _$reviewsCount,
      key: r'reviews_count', opt: true, def: 0);
  static int _$reportsCount(DeckListing v) => v.reportsCount;
  static const Field<DeckListing, int> _f$reportsCount = Field(
      'reportsCount', _$reportsCount,
      key: r'reports_count', opt: true, def: 0);
  static List<Map<String, dynamic>> _$featuredCards(DeckListing v) =>
      v.featuredCards;
  static const Field<DeckListing, List<Map<String, dynamic>>> _f$featuredCards =
      Field('featuredCards', _$featuredCards,
          key: r'featured_cards', opt: true, def: const []);
  static List<String> _$featuredImages(DeckListing v) => v.featuredImages;
  static const Field<DeckListing, List<String>> _f$featuredImages = Field(
      'featuredImages', _$featuredImages,
      key: r'featured_images', opt: true, def: const []);
  static DateTime _$updatedAt(DeckListing v) => v.updatedAt;
  static const Field<DeckListing, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static DateTime _$createdAt(DeckListing v) => v.createdAt;
  static const Field<DeckListing, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$deckId(DeckListing v) => v.deckId;
  static const Field<DeckListing, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');

  @override
  final MappableFields<DeckListing> fields = const {
    #upvotesCount: _f$upvotesCount,
    #downvotesCount: _f$downvotesCount,
    #downloadsCount: _f$downloadsCount,
    #favoritesCount: _f$favoritesCount,
    #forksCount: _f$forksCount,
    #commentsCount: _f$commentsCount,
    #reviewsCount: _f$reviewsCount,
    #reportsCount: _f$reportsCount,
    #featuredCards: _f$featuredCards,
    #featuredImages: _f$featuredImages,
    #updatedAt: _f$updatedAt,
    #createdAt: _f$createdAt,
    #deckId: _f$deckId,
  };

  static DeckListing _instantiate(DecodingData data) {
    return DeckListing(
        upvotesCount: data.dec(_f$upvotesCount),
        downvotesCount: data.dec(_f$downvotesCount),
        downloadsCount: data.dec(_f$downloadsCount),
        favoritesCount: data.dec(_f$favoritesCount),
        forksCount: data.dec(_f$forksCount),
        commentsCount: data.dec(_f$commentsCount),
        reviewsCount: data.dec(_f$reviewsCount),
        reportsCount: data.dec(_f$reportsCount),
        featuredCards: data.dec(_f$featuredCards),
        featuredImages: data.dec(_f$featuredImages),
        updatedAt: data.dec(_f$updatedAt),
        createdAt: data.dec(_f$createdAt),
        deckId: data.dec(_f$deckId));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckListing fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckListing>(map);
  }

  static DeckListing fromJson(String json) {
    return ensureInitialized().decodeJson<DeckListing>(json);
  }
}

mixin DeckListingMappable {
  String toJson() {
    return DeckListingMapper.ensureInitialized()
        .encodeJson<DeckListing>(this as DeckListing);
  }

  Map<String, dynamic> toMap() {
    return DeckListingMapper.ensureInitialized()
        .encodeMap<DeckListing>(this as DeckListing);
  }

  DeckListingCopyWith<DeckListing, DeckListing, DeckListing> get copyWith =>
      _DeckListingCopyWithImpl<DeckListing, DeckListing>(
          this as DeckListing, $identity, $identity);
  @override
  String toString() {
    return DeckListingMapper.ensureInitialized()
        .stringifyValue(this as DeckListing);
  }

  @override
  bool operator ==(Object other) {
    return DeckListingMapper.ensureInitialized()
        .equalsValue(this as DeckListing, other);
  }

  @override
  int get hashCode {
    return DeckListingMapper.ensureInitialized().hashValue(this as DeckListing);
  }
}

extension DeckListingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckListing, $Out> {
  DeckListingCopyWith<$R, DeckListing, $Out> get $asDeckListing =>
      $base.as((v, t, t2) => _DeckListingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckListingCopyWith<$R, $In extends DeckListing, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Map<String, dynamic>,
          ObjectCopyWith<$R, Map<String, dynamic>, Map<String, dynamic>>>
      get featuredCards;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get featuredImages;
  $R call(
      {int? upvotesCount,
      int? downvotesCount,
      int? downloadsCount,
      int? favoritesCount,
      int? forksCount,
      int? commentsCount,
      int? reviewsCount,
      int? reportsCount,
      List<Map<String, dynamic>>? featuredCards,
      List<String>? featuredImages,
      DateTime? updatedAt,
      DateTime? createdAt,
      String? deckId});
  DeckListingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckListingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckListing, $Out>
    implements DeckListingCopyWith<$R, DeckListing, $Out> {
  _DeckListingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckListing> $mapper =
      DeckListingMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Map<String, dynamic>,
          ObjectCopyWith<$R, Map<String, dynamic>, Map<String, dynamic>>>
      get featuredCards => ListCopyWith(
          $value.featuredCards,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(featuredCards: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get featuredImages => ListCopyWith(
          $value.featuredImages,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(featuredImages: v));
  @override
  $R call(
          {int? upvotesCount,
          int? downvotesCount,
          int? downloadsCount,
          int? favoritesCount,
          int? forksCount,
          int? commentsCount,
          int? reviewsCount,
          int? reportsCount,
          List<Map<String, dynamic>>? featuredCards,
          List<String>? featuredImages,
          DateTime? updatedAt,
          DateTime? createdAt,
          String? deckId}) =>
      $apply(FieldCopyWithData({
        if (upvotesCount != null) #upvotesCount: upvotesCount,
        if (downvotesCount != null) #downvotesCount: downvotesCount,
        if (downloadsCount != null) #downloadsCount: downloadsCount,
        if (favoritesCount != null) #favoritesCount: favoritesCount,
        if (forksCount != null) #forksCount: forksCount,
        if (commentsCount != null) #commentsCount: commentsCount,
        if (reviewsCount != null) #reviewsCount: reviewsCount,
        if (reportsCount != null) #reportsCount: reportsCount,
        if (featuredCards != null) #featuredCards: featuredCards,
        if (featuredImages != null) #featuredImages: featuredImages,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (createdAt != null) #createdAt: createdAt,
        if (deckId != null) #deckId: deckId
      }));
  @override
  DeckListing $make(CopyWithData data) => DeckListing(
      upvotesCount: data.get(#upvotesCount, or: $value.upvotesCount),
      downvotesCount: data.get(#downvotesCount, or: $value.downvotesCount),
      downloadsCount: data.get(#downloadsCount, or: $value.downloadsCount),
      favoritesCount: data.get(#favoritesCount, or: $value.favoritesCount),
      forksCount: data.get(#forksCount, or: $value.forksCount),
      commentsCount: data.get(#commentsCount, or: $value.commentsCount),
      reviewsCount: data.get(#reviewsCount, or: $value.reviewsCount),
      reportsCount: data.get(#reportsCount, or: $value.reportsCount),
      featuredCards: data.get(#featuredCards, or: $value.featuredCards),
      featuredImages: data.get(#featuredImages, or: $value.featuredImages),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      deckId: data.get(#deckId, or: $value.deckId));

  @override
  DeckListingCopyWith<$R2, DeckListing, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DeckListingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
