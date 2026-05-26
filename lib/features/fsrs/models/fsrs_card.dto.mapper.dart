// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fsrs_card.dto.dart';

class FsrsCardMapper extends ClassMapperBase<FsrsCard> {
  FsrsCardMapper._();

  static FsrsCardMapper? _instance;
  static FsrsCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FsrsCardMapper._());
      StudyCardMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FsrsCard';

  static String _$id(FsrsCard v) => v.id;
  static const Field<FsrsCard, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(FsrsCard v) => v.createdAt;
  static const Field<FsrsCard, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(FsrsCard v) => v.updatedAt;
  static const Field<FsrsCard, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static String _$userId(FsrsCard v) => v.userId;
  static const Field<FsrsCard, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String _$studyCardId(FsrsCard v) => v.studyCardId;
  static const Field<FsrsCard, String> _f$studyCardId =
      Field('studyCardId', _$studyCardId, key: r'study_card_id');
  static Card _$state(FsrsCard v) => v.state;
  static const Field<FsrsCard, Card> _f$state = Field('state', _$state);
  static StudyCard? _$studyCard(FsrsCard v) => v.studyCard;
  static const Field<FsrsCard, StudyCard> _f$studyCard =
      Field('studyCard', _$studyCard, key: r'study_card', opt: true);

  @override
  final MappableFields<FsrsCard> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #userId: _f$userId,
    #studyCardId: _f$studyCardId,
    #state: _f$state,
    #studyCard: _f$studyCard,
  };

  static FsrsCard _instantiate(DecodingData data) {
    return FsrsCard(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        userId: data.dec(_f$userId),
        studyCardId: data.dec(_f$studyCardId),
        state: data.dec(_f$state),
        studyCard: data.dec(_f$studyCard));
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
  StudyCardCopyWith<$R, StudyCard, StudyCard>? get studyCard;
  $R call(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? userId,
      String? studyCardId,
      Card? state,
      StudyCard? studyCard});
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
  StudyCardCopyWith<$R, StudyCard, StudyCard>? get studyCard =>
      $value.studyCard?.copyWith.$chain((v) => call(studyCard: v));
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? userId,
          String? studyCardId,
          Card? state,
          Object? studyCard = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (userId != null) #userId: userId,
        if (studyCardId != null) #studyCardId: studyCardId,
        if (state != null) #state: state,
        if (studyCard != $none) #studyCard: studyCard
      }));
  @override
  FsrsCard $make(CopyWithData data) => FsrsCard(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      userId: data.get(#userId, or: $value.userId),
      studyCardId: data.get(#studyCardId, or: $value.studyCardId),
      state: data.get(#state, or: $value.state),
      studyCard: data.get(#studyCard, or: $value.studyCard));

  @override
  FsrsCardCopyWith<$R2, FsrsCard, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FsrsCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
