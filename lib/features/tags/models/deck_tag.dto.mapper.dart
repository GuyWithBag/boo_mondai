// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_tag.dto.dart';

class DeckTagMapper extends ClassMapperBase<DeckTag> {
  DeckTagMapper._();

  static DeckTagMapper? _instance;
  static DeckTagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckTagMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeckTag';

  static String _$deckId(DeckTag v) => v.deckId;
  static const Field<DeckTag, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static String _$tagId(DeckTag v) => v.tagId;
  static const Field<DeckTag, String> _f$tagId =
      Field('tagId', _$tagId, key: r'tag_id');

  @override
  final MappableFields<DeckTag> fields = const {
    #deckId: _f$deckId,
    #tagId: _f$tagId,
  };

  static DeckTag _instantiate(DecodingData data) {
    return DeckTag(deckId: data.dec(_f$deckId), tagId: data.dec(_f$tagId));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckTag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckTag>(map);
  }

  static DeckTag fromJson(String json) {
    return ensureInitialized().decodeJson<DeckTag>(json);
  }
}

mixin DeckTagMappable {
  String toJson() {
    return DeckTagMapper.ensureInitialized()
        .encodeJson<DeckTag>(this as DeckTag);
  }

  Map<String, dynamic> toMap() {
    return DeckTagMapper.ensureInitialized()
        .encodeMap<DeckTag>(this as DeckTag);
  }

  DeckTagCopyWith<DeckTag, DeckTag, DeckTag> get copyWith =>
      _DeckTagCopyWithImpl<DeckTag, DeckTag>(
          this as DeckTag, $identity, $identity);
  @override
  String toString() {
    return DeckTagMapper.ensureInitialized().stringifyValue(this as DeckTag);
  }

  @override
  bool operator ==(Object other) {
    return DeckTagMapper.ensureInitialized()
        .equalsValue(this as DeckTag, other);
  }

  @override
  int get hashCode {
    return DeckTagMapper.ensureInitialized().hashValue(this as DeckTag);
  }
}

extension DeckTagValueCopy<$R, $Out> on ObjectCopyWith<$R, DeckTag, $Out> {
  DeckTagCopyWith<$R, DeckTag, $Out> get $asDeckTag =>
      $base.as((v, t, t2) => _DeckTagCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckTagCopyWith<$R, $In extends DeckTag, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? deckId, String? tagId});
  DeckTagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckTagCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckTag, $Out>
    implements DeckTagCopyWith<$R, DeckTag, $Out> {
  _DeckTagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckTag> $mapper =
      DeckTagMapper.ensureInitialized();
  @override
  $R call({String? deckId, String? tagId}) => $apply(FieldCopyWithData(
      {if (deckId != null) #deckId: deckId, if (tagId != null) #tagId: tagId}));
  @override
  DeckTag $make(CopyWithData data) => DeckTag(
      deckId: data.get(#deckId, or: $value.deckId),
      tagId: data.get(#tagId, or: $value.tagId));

  @override
  DeckTagCopyWith<$R2, DeckTag, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeckTagCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
