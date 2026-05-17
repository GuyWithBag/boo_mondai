// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck.dto.dart';

class DeckMapper extends ClassMapperBase<Deck> {
  DeckMapper._();

  static DeckMapper? _instance;
  static DeckMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckMapper._());
      VisibilityStateMapper.ensureInitialized();
      TagMapper.ensureInitialized();
      DeckListingMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Deck';

  static String _$id(Deck v) => v.id;
  static const Field<Deck, String> _f$id = Field('id', _$id);
  static String _$userId(Deck v) => v.userId;
  static const Field<Deck, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String _$title(Deck v) => v.title;
  static const Field<Deck, String> _f$title = Field('title', _$title);
  static String _$shortDescription(Deck v) => v.shortDescription;
  static const Field<Deck, String> _f$shortDescription = Field(
      'shortDescription', _$shortDescription,
      key: r'short_description', opt: true, def: '');
  static String _$longDescription(Deck v) => v.longDescription;
  static const Field<Deck, String> _f$longDescription = Field(
      'longDescription', _$longDescription,
      key: r'long_description', opt: true, def: '');
  static String? _$coverImageUrl(Deck v) => v.coverImageUrl;
  static const Field<Deck, String> _f$coverImageUrl = Field(
      'coverImageUrl', _$coverImageUrl,
      key: r'cover_image_url', opt: true);
  static String? _$sourceDeckId(Deck v) => v.sourceDeckId;
  static const Field<Deck, String> _f$sourceDeckId =
      Field('sourceDeckId', _$sourceDeckId, key: r'source_deck_id', opt: true);
  static bool _$isPremade(Deck v) => v.isPremade;
  static const Field<Deck, bool> _f$isPremade = Field('isPremade', _$isPremade,
      key: r'is_premade', opt: true, def: false);
  static VisibilityState _$visibilityState(Deck v) => v.visibilityState;
  static const Field<Deck, VisibilityState> _f$visibilityState =
      Field('visibilityState', _$visibilityState, key: r'visibility_state');
  static bool _$isPublished(Deck v) => v.isPublished;
  static const Field<Deck, bool> _f$isPublished =
      Field('isPublished', _$isPublished, key: r'is_published');
  static bool _$isEditable(Deck v) => v.isEditable;
  static const Field<Deck, bool> _f$isEditable = Field(
      'isEditable', _$isEditable,
      key: r'is_editable', opt: true, def: true);
  static int _$cardCount(Deck v) => v.cardCount;
  static const Field<Deck, int> _f$cardCount =
      Field('cardCount', _$cardCount, key: r'card_count');
  static String _$version(Deck v) => v.version;
  static const Field<Deck, String> _f$version =
      Field('version', _$version, opt: true, def: '1.0.0');
  static int _$buildNumber(Deck v) => v.buildNumber;
  static const Field<Deck, int> _f$buildNumber = Field(
      'buildNumber', _$buildNumber,
      key: r'build_number', opt: true, def: 1);
  static DateTime _$createdAt(Deck v) => v.createdAt;
  static const Field<Deck, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(Deck v) => v.updatedAt;
  static const Field<Deck, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static List<Tag> _$tags(Deck v) => v.tags;
  static const Field<Deck, List<Tag>> _f$tags =
      Field('tags', _$tags, opt: true, def: const []);
  static DeckListing? _$listing(Deck v) => v.listing;
  static const Field<Deck, DeckListing> _f$listing =
      Field('listing', _$listing, opt: true);

  @override
  final MappableFields<Deck> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #title: _f$title,
    #shortDescription: _f$shortDescription,
    #longDescription: _f$longDescription,
    #coverImageUrl: _f$coverImageUrl,
    #sourceDeckId: _f$sourceDeckId,
    #isPremade: _f$isPremade,
    #visibilityState: _f$visibilityState,
    #isPublished: _f$isPublished,
    #isEditable: _f$isEditable,
    #cardCount: _f$cardCount,
    #version: _f$version,
    #buildNumber: _f$buildNumber,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #tags: _f$tags,
    #listing: _f$listing,
  };

  static Deck _instantiate(DecodingData data) {
    return Deck(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        title: data.dec(_f$title),
        shortDescription: data.dec(_f$shortDescription),
        longDescription: data.dec(_f$longDescription),
        coverImageUrl: data.dec(_f$coverImageUrl),
        sourceDeckId: data.dec(_f$sourceDeckId),
        isPremade: data.dec(_f$isPremade),
        visibilityState: data.dec(_f$visibilityState),
        isPublished: data.dec(_f$isPublished),
        isEditable: data.dec(_f$isEditable),
        cardCount: data.dec(_f$cardCount),
        version: data.dec(_f$version),
        buildNumber: data.dec(_f$buildNumber),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        tags: data.dec(_f$tags),
        listing: data.dec(_f$listing));
  }

  @override
  final Function instantiate = _instantiate;

  static Deck fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Deck>(map);
  }

  static Deck fromJson(String json) {
    return ensureInitialized().decodeJson<Deck>(json);
  }
}

mixin DeckMappable {
  String toJson() {
    return DeckMapper.ensureInitialized().encodeJson<Deck>(this as Deck);
  }

  Map<String, dynamic> toMap() {
    return DeckMapper.ensureInitialized().encodeMap<Deck>(this as Deck);
  }

  DeckCopyWith<Deck, Deck, Deck> get copyWith =>
      _DeckCopyWithImpl<Deck, Deck>(this as Deck, $identity, $identity);
  @override
  String toString() {
    return DeckMapper.ensureInitialized().stringifyValue(this as Deck);
  }

  @override
  bool operator ==(Object other) {
    return DeckMapper.ensureInitialized().equalsValue(this as Deck, other);
  }

  @override
  int get hashCode {
    return DeckMapper.ensureInitialized().hashValue(this as Deck);
  }
}

extension DeckValueCopy<$R, $Out> on ObjectCopyWith<$R, Deck, $Out> {
  DeckCopyWith<$R, Deck, $Out> get $asDeck =>
      $base.as((v, t, t2) => _DeckCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckCopyWith<$R, $In extends Deck, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get tags;
  DeckListingCopyWith<$R, DeckListing, DeckListing>? get listing;
  $R call(
      {String? id,
      String? userId,
      String? title,
      String? shortDescription,
      String? longDescription,
      String? coverImageUrl,
      String? sourceDeckId,
      bool? isPremade,
      VisibilityState? visibilityState,
      bool? isPublished,
      bool? isEditable,
      int? cardCount,
      String? version,
      int? buildNumber,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<Tag>? tags,
      DeckListing? listing});
  DeckCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Deck, $Out>
    implements DeckCopyWith<$R, Deck, $Out> {
  _DeckCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Deck> $mapper = DeckMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get tags => ListCopyWith(
      $value.tags, (v, t) => v.copyWith.$chain(t), (v) => call(tags: v));
  @override
  DeckListingCopyWith<$R, DeckListing, DeckListing>? get listing =>
      $value.listing?.copyWith.$chain((v) => call(listing: v));
  @override
  $R call(
          {String? id,
          String? userId,
          String? title,
          String? shortDescription,
          String? longDescription,
          Object? coverImageUrl = $none,
          Object? sourceDeckId = $none,
          bool? isPremade,
          VisibilityState? visibilityState,
          bool? isPublished,
          bool? isEditable,
          int? cardCount,
          String? version,
          int? buildNumber,
          DateTime? createdAt,
          DateTime? updatedAt,
          List<Tag>? tags,
          Object? listing = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (title != null) #title: title,
        if (shortDescription != null) #shortDescription: shortDescription,
        if (longDescription != null) #longDescription: longDescription,
        if (coverImageUrl != $none) #coverImageUrl: coverImageUrl,
        if (sourceDeckId != $none) #sourceDeckId: sourceDeckId,
        if (isPremade != null) #isPremade: isPremade,
        if (visibilityState != null) #visibilityState: visibilityState,
        if (isPublished != null) #isPublished: isPublished,
        if (isEditable != null) #isEditable: isEditable,
        if (cardCount != null) #cardCount: cardCount,
        if (version != null) #version: version,
        if (buildNumber != null) #buildNumber: buildNumber,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (tags != null) #tags: tags,
        if (listing != $none) #listing: listing
      }));
  @override
  Deck $make(CopyWithData data) => Deck(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      title: data.get(#title, or: $value.title),
      shortDescription:
          data.get(#shortDescription, or: $value.shortDescription),
      longDescription: data.get(#longDescription, or: $value.longDescription),
      coverImageUrl: data.get(#coverImageUrl, or: $value.coverImageUrl),
      sourceDeckId: data.get(#sourceDeckId, or: $value.sourceDeckId),
      isPremade: data.get(#isPremade, or: $value.isPremade),
      visibilityState: data.get(#visibilityState, or: $value.visibilityState),
      isPublished: data.get(#isPublished, or: $value.isPublished),
      isEditable: data.get(#isEditable, or: $value.isEditable),
      cardCount: data.get(#cardCount, or: $value.cardCount),
      version: data.get(#version, or: $value.version),
      buildNumber: data.get(#buildNumber, or: $value.buildNumber),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      tags: data.get(#tags, or: $value.tags),
      listing: data.get(#listing, or: $value.listing));

  @override
  DeckCopyWith<$R2, Deck, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeckCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
