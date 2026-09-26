// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'study_card.dto.dart';

class StudyCardMapper extends ClassMapperBase<StudyCard> {
  StudyCardMapper._();

  static StudyCardMapper? _instance;
  static StudyCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudyCardMapper._());
      MutableEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StudyCard';

  static String _$id(StudyCard v) => v.id;
  static const Field<StudyCard, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(StudyCard v) => v.createdAt;
  static const Field<StudyCard, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(StudyCard v) => v.updatedAt;
  static const Field<StudyCard, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static DateTime? _$deletedAt(StudyCard v) => v.deletedAt;
  static const Field<StudyCard, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at', opt: true);
  static DateTime? _$purgeAfter(StudyCard v) => v.purgeAfter;
  static const Field<StudyCard, DateTime> _f$purgeAfter =
      Field('purgeAfter', _$purgeAfter, key: r'purge_after', opt: true);
  static String _$templateId(StudyCard v) => v.templateId;
  static const Field<StudyCard, String> _f$templateId =
      Field('templateId', _$templateId, key: r'template_id');
  static bool _$isReversed(StudyCard v) => v.isReversed;
  static const Field<StudyCard, bool> _f$isReversed = Field(
      'isReversed', _$isReversed,
      key: r'is_reversed', opt: true, def: false);
  static String _$deckId(StudyCard v) => v.deckId;
  static const Field<StudyCard, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');

  @override
  final MappableFields<StudyCard> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
    #purgeAfter: _f$purgeAfter,
    #templateId: _f$templateId,
    #isReversed: _f$isReversed,
    #deckId: _f$deckId,
  };

  static StudyCard _instantiate(DecodingData data) {
    return StudyCard(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        deletedAt: data.dec(_f$deletedAt),
        purgeAfter: data.dec(_f$purgeAfter),
        templateId: data.dec(_f$templateId),
        isReversed: data.dec(_f$isReversed),
        deckId: data.dec(_f$deckId));
  }

  @override
  final Function instantiate = _instantiate;

  static StudyCard fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudyCard>(map);
  }

  static StudyCard fromJson(String json) {
    return ensureInitialized().decodeJson<StudyCard>(json);
  }
}

mixin StudyCardMappable {
  String toJson() {
    return StudyCardMapper.ensureInitialized()
        .encodeJson<StudyCard>(this as StudyCard);
  }

  Map<String, dynamic> toMap() {
    return StudyCardMapper.ensureInitialized()
        .encodeMap<StudyCard>(this as StudyCard);
  }

  StudyCardCopyWith<StudyCard, StudyCard, StudyCard> get copyWith =>
      _StudyCardCopyWithImpl<StudyCard, StudyCard>(
          this as StudyCard, $identity, $identity);
  @override
  String toString() {
    return StudyCardMapper.ensureInitialized()
        .stringifyValue(this as StudyCard);
  }

  @override
  bool operator ==(Object other) {
    return StudyCardMapper.ensureInitialized()
        .equalsValue(this as StudyCard, other);
  }

  @override
  int get hashCode {
    return StudyCardMapper.ensureInitialized().hashValue(this as StudyCard);
  }
}

extension StudyCardValueCopy<$R, $Out> on ObjectCopyWith<$R, StudyCard, $Out> {
  StudyCardCopyWith<$R, StudyCard, $Out> get $asStudyCard =>
      $base.as((v, t, t2) => _StudyCardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StudyCardCopyWith<$R, $In extends StudyCard, $Out>
    implements MutableEntityCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      DateTime? purgeAfter,
      String? templateId,
      bool? isReversed,
      String? deckId});
  StudyCardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StudyCardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StudyCard, $Out>
    implements StudyCardCopyWith<$R, StudyCard, $Out> {
  _StudyCardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StudyCard> $mapper =
      StudyCardMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? deletedAt = $none,
          Object? purgeAfter = $none,
          String? templateId,
          bool? isReversed,
          String? deckId}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (deletedAt != $none) #deletedAt: deletedAt,
        if (purgeAfter != $none) #purgeAfter: purgeAfter,
        if (templateId != null) #templateId: templateId,
        if (isReversed != null) #isReversed: isReversed,
        if (deckId != null) #deckId: deckId
      }));
  @override
  StudyCard $make(CopyWithData data) => StudyCard(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      deletedAt: data.get(#deletedAt, or: $value.deletedAt),
      purgeAfter: data.get(#purgeAfter, or: $value.purgeAfter),
      templateId: data.get(#templateId, or: $value.templateId),
      isReversed: data.get(#isReversed, or: $value.isReversed),
      deckId: data.get(#deckId, or: $value.deckId));

  @override
  StudyCardCopyWith<$R2, StudyCard, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _StudyCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
