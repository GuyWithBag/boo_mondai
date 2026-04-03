// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fill_in_the_blanks_template.dart';

class FillInTheBlanksTemplateMapper
    extends SubClassMapperBase<FillInTheBlanksTemplate> {
  FillInTheBlanksTemplateMapper._();

  static FillInTheBlanksTemplateMapper? _instance;
  static FillInTheBlanksTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = FillInTheBlanksTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'FillInTheBlanksTemplate';

  static String _$id(FillInTheBlanksTemplate v) => v.id;
  static const Field<FillInTheBlanksTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(FillInTheBlanksTemplate v) => v.deckId;
  static const Field<FillInTheBlanksTemplate, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$sortOrder(FillInTheBlanksTemplate v) => v.sortOrder;
  static const Field<FillInTheBlanksTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(FillInTheBlanksTemplate v) => v.createdAt;
  static const Field<FillInTheBlanksTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceTemplateId(FillInTheBlanksTemplate v) =>
      v.sourceTemplateId;
  static const Field<FillInTheBlanksTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);
  static List<FillInTheBlankSegment> _$segments(FillInTheBlanksTemplate v) =>
      v.segments;
  static const Field<FillInTheBlanksTemplate, List<FillInTheBlankSegment>>
      _f$segments = Field('segments', _$segments);

  @override
  final MappableFields<FillInTheBlanksTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceTemplateId: _f$sourceTemplateId,
    #segments: _f$segments,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'fill_in_the_blanks';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static FillInTheBlanksTemplate _instantiate(DecodingData data) {
    return FillInTheBlanksTemplate(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        segments: data.dec(_f$segments));
  }

  @override
  final Function instantiate = _instantiate;

  static FillInTheBlanksTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FillInTheBlanksTemplate>(map);
  }

  static FillInTheBlanksTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<FillInTheBlanksTemplate>(json);
  }
}

mixin FillInTheBlanksTemplateMappable {
  String toJson() {
    return FillInTheBlanksTemplateMapper.ensureInitialized()
        .encodeJson<FillInTheBlanksTemplate>(this as FillInTheBlanksTemplate);
  }

  Map<String, dynamic> toMap() {
    return FillInTheBlanksTemplateMapper.ensureInitialized()
        .encodeMap<FillInTheBlanksTemplate>(this as FillInTheBlanksTemplate);
  }

  FillInTheBlanksTemplateCopyWith<FillInTheBlanksTemplate,
          FillInTheBlanksTemplate, FillInTheBlanksTemplate>
      get copyWith => _FillInTheBlanksTemplateCopyWithImpl<
              FillInTheBlanksTemplate, FillInTheBlanksTemplate>(
          this as FillInTheBlanksTemplate, $identity, $identity);
  @override
  String toString() {
    return FillInTheBlanksTemplateMapper.ensureInitialized()
        .stringifyValue(this as FillInTheBlanksTemplate);
  }

  @override
  bool operator ==(Object other) {
    return FillInTheBlanksTemplateMapper.ensureInitialized()
        .equalsValue(this as FillInTheBlanksTemplate, other);
  }

  @override
  int get hashCode {
    return FillInTheBlanksTemplateMapper.ensureInitialized()
        .hashValue(this as FillInTheBlanksTemplate);
  }
}

extension FillInTheBlanksTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FillInTheBlanksTemplate, $Out> {
  FillInTheBlanksTemplateCopyWith<$R, FillInTheBlanksTemplate, $Out>
      get $asFillInTheBlanksTemplate => $base.as((v, t, t2) =>
          _FillInTheBlanksTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FillInTheBlanksTemplateCopyWith<
    $R,
    $In extends FillInTheBlanksTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FillInTheBlankSegment,
          ObjectCopyWith<$R, FillInTheBlankSegment, FillInTheBlankSegment>>
      get segments;
  @override
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceTemplateId,
      List<FillInTheBlankSegment>? segments});
  FillInTheBlanksTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FillInTheBlanksTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FillInTheBlanksTemplate, $Out>
    implements
        FillInTheBlanksTemplateCopyWith<$R, FillInTheBlanksTemplate, $Out> {
  _FillInTheBlanksTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FillInTheBlanksTemplate> $mapper =
      FillInTheBlanksTemplateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FillInTheBlankSegment,
          ObjectCopyWith<$R, FillInTheBlankSegment, FillInTheBlankSegment>>
      get segments => ListCopyWith($value.segments,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(segments: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          int? sortOrder,
          DateTime? createdAt,
          Object? sourceTemplateId = $none,
          List<FillInTheBlankSegment>? segments}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (segments != null) #segments: segments
      }));
  @override
  FillInTheBlanksTemplate $make(CopyWithData data) => FillInTheBlanksTemplate(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      segments: data.get(#segments, or: $value.segments));

  @override
  FillInTheBlanksTemplateCopyWith<$R2, FillInTheBlanksTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _FillInTheBlanksTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
