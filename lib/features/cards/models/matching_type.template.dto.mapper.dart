// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'matching_type.template.dto.dart';

class MatchingTypeTemplateMapper
    extends SubClassMapperBase<MatchingTypeTemplate> {
  MatchingTypeTemplateMapper._();

  static MatchingTypeTemplateMapper? _instance;
  static MatchingTypeTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchingTypeTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
      TagMapper.ensureInitialized();
      MatchingTypeValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MatchingTypeTemplate';

  static String _$id(MatchingTypeTemplate v) => v.id;
  static const Field<MatchingTypeTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(MatchingTypeTemplate v) => v.deckId;
  static const Field<MatchingTypeTemplate, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static int _$sortOrder(MatchingTypeTemplate v) => v.sortOrder;
  static const Field<MatchingTypeTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder, key: r'sort_order');
  static DateTime _$createdAt(MatchingTypeTemplate v) => v.createdAt;
  static const Field<MatchingTypeTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(MatchingTypeTemplate v) => v.updatedAt;
  static const Field<MatchingTypeTemplate, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static DateTime? _$deletedAt(MatchingTypeTemplate v) => v.deletedAt;
  static const Field<MatchingTypeTemplate, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at', opt: true);
  static DateTime? _$purgeAfter(MatchingTypeTemplate v) => v.purgeAfter;
  static const Field<MatchingTypeTemplate, DateTime> _f$purgeAfter =
      Field('purgeAfter', _$purgeAfter, key: r'purge_after', opt: true);
  static String? _$sourceTemplateId(MatchingTypeTemplate v) =>
      v.sourceTemplateId;
  static const Field<MatchingTypeTemplate, String> _f$sourceTemplateId = Field(
      'sourceTemplateId', _$sourceTemplateId,
      key: r'source_template_id', opt: true);
  static List<Tag> _$tags(MatchingTypeTemplate v) => v.tags;
  static const Field<MatchingTypeTemplate, List<Tag>> _f$tags =
      Field('tags', _$tags, opt: true, def: const []);
  static bool _$verticallyCentered(MatchingTypeTemplate v) =>
      v.verticallyCentered;
  static const Field<MatchingTypeTemplate, bool> _f$verticallyCentered = Field(
      'verticallyCentered', _$verticallyCentered,
      key: r'vertically_centered', opt: true, def: true);
  static List<MatchingTypeValue> _$values(MatchingTypeTemplate v) => v.values;
  static const Field<MatchingTypeTemplate, List<MatchingTypeValue>> _f$values =
      Field('values', _$values);
  static int _$maxIncorrectAnswers(MatchingTypeTemplate v) =>
      v.maxIncorrectAnswers;
  static const Field<MatchingTypeTemplate, int> _f$maxIncorrectAnswers = Field(
      'maxIncorrectAnswers', _$maxIncorrectAnswers,
      key: r'max_incorrect_answers', opt: true, def: -1);

  @override
  final MappableFields<MatchingTypeTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
    #purgeAfter: _f$purgeAfter,
    #sourceTemplateId: _f$sourceTemplateId,
    #tags: _f$tags,
    #verticallyCentered: _f$verticallyCentered,
    #values: _f$values,
    #maxIncorrectAnswers: _f$maxIncorrectAnswers,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'matching_type';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static MatchingTypeTemplate _instantiate(DecodingData data) {
    return MatchingTypeTemplate(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        deletedAt: data.dec(_f$deletedAt),
        purgeAfter: data.dec(_f$purgeAfter),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        tags: data.dec(_f$tags),
        verticallyCentered: data.dec(_f$verticallyCentered),
        values: data.dec(_f$values),
        maxIncorrectAnswers: data.dec(_f$maxIncorrectAnswers));
  }

  @override
  final Function instantiate = _instantiate;

  static MatchingTypeTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchingTypeTemplate>(map);
  }

  static MatchingTypeTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<MatchingTypeTemplate>(json);
  }
}

mixin MatchingTypeTemplateMappable {
  String toJson() {
    return MatchingTypeTemplateMapper.ensureInitialized()
        .encodeJson<MatchingTypeTemplate>(this as MatchingTypeTemplate);
  }

  Map<String, dynamic> toMap() {
    return MatchingTypeTemplateMapper.ensureInitialized()
        .encodeMap<MatchingTypeTemplate>(this as MatchingTypeTemplate);
  }

  MatchingTypeTemplateCopyWith<MatchingTypeTemplate, MatchingTypeTemplate,
      MatchingTypeTemplate> get copyWith => _MatchingTypeTemplateCopyWithImpl<
          MatchingTypeTemplate, MatchingTypeTemplate>(
      this as MatchingTypeTemplate, $identity, $identity);
  @override
  String toString() {
    return MatchingTypeTemplateMapper.ensureInitialized()
        .stringifyValue(this as MatchingTypeTemplate);
  }

  @override
  bool operator ==(Object other) {
    return MatchingTypeTemplateMapper.ensureInitialized()
        .equalsValue(this as MatchingTypeTemplate, other);
  }

  @override
  int get hashCode {
    return MatchingTypeTemplateMapper.ensureInitialized()
        .hashValue(this as MatchingTypeTemplate);
  }
}

extension MatchingTypeTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchingTypeTemplate, $Out> {
  MatchingTypeTemplateCopyWith<$R, MatchingTypeTemplate, $Out>
      get $asMatchingTypeTemplate => $base.as(
          (v, t, t2) => _MatchingTypeTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchingTypeTemplateCopyWith<
    $R,
    $In extends MatchingTypeTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get tags;
  ListCopyWith<$R, MatchingTypeValue,
          MatchingTypeValueCopyWith<$R, MatchingTypeValue, MatchingTypeValue>>
      get values;
  @override
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      DateTime? purgeAfter,
      String? sourceTemplateId,
      List<Tag>? tags,
      bool? verticallyCentered,
      List<MatchingTypeValue>? values,
      int? maxIncorrectAnswers});
  MatchingTypeTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MatchingTypeTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchingTypeTemplate, $Out>
    implements MatchingTypeTemplateCopyWith<$R, MatchingTypeTemplate, $Out> {
  _MatchingTypeTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchingTypeTemplate> $mapper =
      MatchingTypeTemplateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get tags => ListCopyWith(
      $value.tags, (v, t) => v.copyWith.$chain(t), (v) => call(tags: v));
  @override
  ListCopyWith<$R, MatchingTypeValue,
          MatchingTypeValueCopyWith<$R, MatchingTypeValue, MatchingTypeValue>>
      get values => ListCopyWith($value.values, (v, t) => v.copyWith.$chain(t),
          (v) => call(values: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? deletedAt = $none,
          Object? purgeAfter = $none,
          Object? sourceTemplateId = $none,
          List<Tag>? tags,
          bool? verticallyCentered,
          List<MatchingTypeValue>? values,
          int? maxIncorrectAnswers}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (deletedAt != $none) #deletedAt: deletedAt,
        if (purgeAfter != $none) #purgeAfter: purgeAfter,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (tags != null) #tags: tags,
        if (verticallyCentered != null) #verticallyCentered: verticallyCentered,
        if (values != null) #values: values,
        if (maxIncorrectAnswers != null)
          #maxIncorrectAnswers: maxIncorrectAnswers
      }));
  @override
  MatchingTypeTemplate $make(CopyWithData data) => MatchingTypeTemplate(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      deletedAt: data.get(#deletedAt, or: $value.deletedAt),
      purgeAfter: data.get(#purgeAfter, or: $value.purgeAfter),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      tags: data.get(#tags, or: $value.tags),
      verticallyCentered:
          data.get(#verticallyCentered, or: $value.verticallyCentered),
      values: data.get(#values, or: $value.values),
      maxIncorrectAnswers:
          data.get(#maxIncorrectAnswers, or: $value.maxIncorrectAnswers));

  @override
  MatchingTypeTemplateCopyWith<$R2, MatchingTypeTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MatchingTypeTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
