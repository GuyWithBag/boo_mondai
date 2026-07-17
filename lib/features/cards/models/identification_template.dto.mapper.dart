// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'identification_template.dto.dart';

class IdentificationTemplateMapper
    extends SubClassMapperBase<IdentificationTemplate> {
  IdentificationTemplateMapper._();

  static IdentificationTemplateMapper? _instance;
  static IdentificationTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = IdentificationTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
      TagMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'IdentificationTemplate';

  static String _$id(IdentificationTemplate v) => v.id;
  static const Field<IdentificationTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(IdentificationTemplate v) => v.deckId;
  static const Field<IdentificationTemplate, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static int _$sortOrder(IdentificationTemplate v) => v.sortOrder;
  static const Field<IdentificationTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder, key: r'sort_order');
  static DateTime _$createdAt(IdentificationTemplate v) => v.createdAt;
  static const Field<IdentificationTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(IdentificationTemplate v) => v.updatedAt;
  static const Field<IdentificationTemplate, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static DateTime? _$deletedAt(IdentificationTemplate v) => v.deletedAt;
  static const Field<IdentificationTemplate, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at', opt: true);
  static DateTime? _$purgeAfter(IdentificationTemplate v) => v.purgeAfter;
  static const Field<IdentificationTemplate, DateTime> _f$purgeAfter =
      Field('purgeAfter', _$purgeAfter, key: r'purge_after', opt: true);
  static String? _$sourceTemplateId(IdentificationTemplate v) =>
      v.sourceTemplateId;
  static const Field<IdentificationTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId,
          key: r'source_template_id', opt: true);
  static List<Tag> _$tags(IdentificationTemplate v) => v.tags;
  static const Field<IdentificationTemplate, List<Tag>> _f$tags =
      Field('tags', _$tags, opt: true, def: const []);
  static bool _$verticallyCentered(IdentificationTemplate v) =>
      v.verticallyCentered;
  static const Field<IdentificationTemplate, bool> _f$verticallyCentered =
      Field('verticallyCentered', _$verticallyCentered,
          key: r'vertically_centered', opt: true, def: true);
  static String _$promptText(IdentificationTemplate v) => v.promptText;
  static const Field<IdentificationTemplate, String> _f$promptText =
      Field('promptText', _$promptText, key: r'prompt_text');
  static String _$acceptedAnswers(IdentificationTemplate v) =>
      v.acceptedAnswers;
  static const Field<IdentificationTemplate, String> _f$acceptedAnswers =
      Field('acceptedAnswers', _$acceptedAnswers, key: r'accepted_answers');

  @override
  final MappableFields<IdentificationTemplate> fields = const {
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
    #promptText: _f$promptText,
    #acceptedAnswers: _f$acceptedAnswers,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'identification';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static IdentificationTemplate _instantiate(DecodingData data) {
    return IdentificationTemplate(
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
        promptText: data.dec(_f$promptText),
        acceptedAnswers: data.dec(_f$acceptedAnswers));
  }

  @override
  final Function instantiate = _instantiate;

  static IdentificationTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IdentificationTemplate>(map);
  }

  static IdentificationTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<IdentificationTemplate>(json);
  }
}

mixin IdentificationTemplateMappable {
  String toJson() {
    return IdentificationTemplateMapper.ensureInitialized()
        .encodeJson<IdentificationTemplate>(this as IdentificationTemplate);
  }

  Map<String, dynamic> toMap() {
    return IdentificationTemplateMapper.ensureInitialized()
        .encodeMap<IdentificationTemplate>(this as IdentificationTemplate);
  }

  IdentificationTemplateCopyWith<IdentificationTemplate, IdentificationTemplate,
          IdentificationTemplate>
      get copyWith => _IdentificationTemplateCopyWithImpl<
              IdentificationTemplate, IdentificationTemplate>(
          this as IdentificationTemplate, $identity, $identity);
  @override
  String toString() {
    return IdentificationTemplateMapper.ensureInitialized()
        .stringifyValue(this as IdentificationTemplate);
  }

  @override
  bool operator ==(Object other) {
    return IdentificationTemplateMapper.ensureInitialized()
        .equalsValue(this as IdentificationTemplate, other);
  }

  @override
  int get hashCode {
    return IdentificationTemplateMapper.ensureInitialized()
        .hashValue(this as IdentificationTemplate);
  }
}

extension IdentificationTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IdentificationTemplate, $Out> {
  IdentificationTemplateCopyWith<$R, IdentificationTemplate, $Out>
      get $asIdentificationTemplate => $base.as((v, t, t2) =>
          _IdentificationTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class IdentificationTemplateCopyWith<
    $R,
    $In extends IdentificationTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get tags;
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
      String? promptText,
      String? acceptedAnswers});
  IdentificationTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _IdentificationTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IdentificationTemplate, $Out>
    implements
        IdentificationTemplateCopyWith<$R, IdentificationTemplate, $Out> {
  _IdentificationTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IdentificationTemplate> $mapper =
      IdentificationTemplateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get tags => ListCopyWith(
      $value.tags, (v, t) => v.copyWith.$chain(t), (v) => call(tags: v));
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
          String? promptText,
          String? acceptedAnswers}) =>
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
        if (promptText != null) #promptText: promptText,
        if (acceptedAnswers != null) #acceptedAnswers: acceptedAnswers
      }));
  @override
  IdentificationTemplate $make(CopyWithData data) => IdentificationTemplate(
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
      promptText: data.get(#promptText, or: $value.promptText),
      acceptedAnswers: data.get(#acceptedAnswers, or: $value.acceptedAnswers));

  @override
  IdentificationTemplateCopyWith<$R2, IdentificationTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _IdentificationTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
