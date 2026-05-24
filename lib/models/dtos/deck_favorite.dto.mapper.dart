// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_favorite.dto.dart';

class DeckFavoriteMapper extends ClassMapperBase<DeckFavorite> {
  DeckFavoriteMapper._();

  static DeckFavoriteMapper? _instance;
  static DeckFavoriteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckFavoriteMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeckFavorite';

  static String _$deckId(DeckFavorite v) => v.deckId;
  static const Field<DeckFavorite, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static String _$userId(DeckFavorite v) => v.userId;
  static const Field<DeckFavorite, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static DateTime _$createdAt(DeckFavorite v) => v.createdAt;
  static const Field<DeckFavorite, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<DeckFavorite> fields = const {
    #deckId: _f$deckId,
    #userId: _f$userId,
    #createdAt: _f$createdAt,
  };

  static DeckFavorite _instantiate(DecodingData data) {
    return DeckFavorite(
        deckId: data.dec(_f$deckId),
        userId: data.dec(_f$userId),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckFavorite fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckFavorite>(map);
  }

  static DeckFavorite fromJson(String json) {
    return ensureInitialized().decodeJson<DeckFavorite>(json);
  }
}

mixin DeckFavoriteMappable {
  String toJson() {
    return DeckFavoriteMapper.ensureInitialized()
        .encodeJson<DeckFavorite>(this as DeckFavorite);
  }

  Map<String, dynamic> toMap() {
    return DeckFavoriteMapper.ensureInitialized()
        .encodeMap<DeckFavorite>(this as DeckFavorite);
  }

  DeckFavoriteCopyWith<DeckFavorite, DeckFavorite, DeckFavorite> get copyWith =>
      _DeckFavoriteCopyWithImpl<DeckFavorite, DeckFavorite>(
          this as DeckFavorite, $identity, $identity);
  @override
  String toString() {
    return DeckFavoriteMapper.ensureInitialized()
        .stringifyValue(this as DeckFavorite);
  }

  @override
  bool operator ==(Object other) {
    return DeckFavoriteMapper.ensureInitialized()
        .equalsValue(this as DeckFavorite, other);
  }

  @override
  int get hashCode {
    return DeckFavoriteMapper.ensureInitialized()
        .hashValue(this as DeckFavorite);
  }
}

extension DeckFavoriteValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckFavorite, $Out> {
  DeckFavoriteCopyWith<$R, DeckFavorite, $Out> get $asDeckFavorite =>
      $base.as((v, t, t2) => _DeckFavoriteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckFavoriteCopyWith<$R, $In extends DeckFavorite, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? deckId, String? userId, DateTime? createdAt});
  DeckFavoriteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckFavoriteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckFavorite, $Out>
    implements DeckFavoriteCopyWith<$R, DeckFavorite, $Out> {
  _DeckFavoriteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckFavorite> $mapper =
      DeckFavoriteMapper.ensureInitialized();
  @override
  $R call({String? deckId, String? userId, DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (deckId != null) #deckId: deckId,
        if (userId != null) #userId: userId,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  DeckFavorite $make(CopyWithData data) => DeckFavorite(
      deckId: data.get(#deckId, or: $value.deckId),
      userId: data.get(#userId, or: $value.userId),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  DeckFavoriteCopyWith<$R2, DeckFavorite, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DeckFavoriteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
