// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fsrs_card.dart';

class FsrsCardMapper extends ClassMapperBase<FsrsCard> {
  FsrsCardMapper._();

  static FsrsCardMapper? _instance;
  static FsrsCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FsrsCardMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FsrsCard';

  static String _$deckCardId(FsrsCard v) => v.deckCardId;
  static const Field<FsrsCard, String> _f$deckCardId =
      Field('deckCardId', _$deckCardId);
  static Card _$state(FsrsCard v) => v.state;
  static const Field<FsrsCard, Card> _f$state = Field('state', _$state);
  static String _$id(FsrsCard v) => v.id;
  static const Field<FsrsCard, String> _f$id = Field('id', _$id);

  @override
  final MappableFields<FsrsCard> fields = const {
    #deckCardId: _f$deckCardId,
    #state: _f$state,
    #id: _f$id,
  };

  static FsrsCard _instantiate(DecodingData data) {
    return FsrsCard(
        deckCardId: data.dec(_f$deckCardId),
        state: data.dec(_f$state),
        id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static FsrsCard fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FsrsCard>(map);
  }

  static FsrsCard fromJson(String json) {
    return ensureInitialized().decodeJson<FsrsCard>(json);
  }
}

mixin FsrsCardMappable {
  String toJson() {
    return FsrsCardMapper.ensureInitialized()
        .encodeJson<FsrsCard>(this as FsrsCard);
  }

  Map<String, dynamic> toMap() {
    return FsrsCardMapper.ensureInitialized()
        .encodeMap<FsrsCard>(this as FsrsCard);
  }

  FsrsCardCopyWith<FsrsCard, FsrsCard, FsrsCard> get copyWith =>
      _FsrsCardCopyWithImpl<FsrsCard, FsrsCard>(
          this as FsrsCard, $identity, $identity);
  @override
  String toString() {
    return FsrsCardMapper.ensureInitialized().stringifyValue(this as FsrsCard);
  }

  @override
  bool operator ==(Object other) {
    return FsrsCardMapper.ensureInitialized()
        .equalsValue(this as FsrsCard, other);
  }

  @override
  int get hashCode {
    return FsrsCardMapper.ensureInitialized().hashValue(this as FsrsCard);
  }
}

extension FsrsCardValueCopy<$R, $Out> on ObjectCopyWith<$R, FsrsCard, $Out> {
  FsrsCardCopyWith<$R, FsrsCard, $Out> get $asFsrsCard =>
      $base.as((v, t, t2) => _FsrsCardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FsrsCardCopyWith<$R, $In extends FsrsCard, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? deckCardId, Card? state, String? id});
  FsrsCardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FsrsCardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FsrsCard, $Out>
    implements FsrsCardCopyWith<$R, FsrsCard, $Out> {
  _FsrsCardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FsrsCard> $mapper =
      FsrsCardMapper.ensureInitialized();
  @override
  $R call({String? deckCardId, Card? state, String? id}) =>
      $apply(FieldCopyWithData({
        if (deckCardId != null) #deckCardId: deckCardId,
        if (state != null) #state: state,
        if (id != null) #id: id
      }));
  @override
  FsrsCard $make(CopyWithData data) => FsrsCard(
      deckCardId: data.get(#deckCardId, or: $value.deckCardId),
      state: data.get(#state, or: $value.state),
      id: data.get(#id, or: $value.id));

  @override
  FsrsCardCopyWith<$R2, FsrsCard, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FsrsCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
