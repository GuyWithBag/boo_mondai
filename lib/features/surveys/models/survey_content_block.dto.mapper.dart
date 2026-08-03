// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_content_block.dto.dart';

class SurveyContentBlockMapper extends SubClassMapperBase<SurveyContentBlock> {
  SurveyContentBlockMapper._();

  static SurveyContentBlockMapper? _instance;
  static SurveyContentBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyContentBlockMapper._());
      SurveyBlockMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyContentBlock';

  static String _$id(SurveyContentBlock v) => v.id;
  static const Field<SurveyContentBlock, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyContentBlock v) => v.surveyId;
  static const Field<SurveyContentBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyContentBlock v) => v.pageId;
  static const Field<SurveyContentBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyContentBlock v) => v.position;
  static const Field<SurveyContentBlock, int> _f$position =
      Field('position', _$position);
  static String _$markdown(SurveyContentBlock v) => v.markdown;
  static const Field<SurveyContentBlock, String> _f$markdown =
      Field('markdown', _$markdown);

  @override
  final MappableFields<SurveyContentBlock> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #pageId: _f$pageId,
    #position: _f$position,
    #markdown: _f$markdown,
  };

  @override
  final String discriminatorKey = 'block_type';
  @override
  final dynamic discriminatorValue = 'content';
  @override
  late final ClassMapperBase superMapper =
      SurveyBlockMapper.ensureInitialized();

  static SurveyContentBlock _instantiate(DecodingData data) {
    return SurveyContentBlock(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        pageId: data.dec(_f$pageId),
        position: data.dec(_f$position),
        markdown: data.dec(_f$markdown));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyContentBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyContentBlock>(map);
  }

  static SurveyContentBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyContentBlock>(json);
  }
}

mixin SurveyContentBlockMappable {
  String toJson() {
    return SurveyContentBlockMapper.ensureInitialized()
        .encodeJson<SurveyContentBlock>(this as SurveyContentBlock);
  }

  Map<String, dynamic> toMap() {
    return SurveyContentBlockMapper.ensureInitialized()
        .encodeMap<SurveyContentBlock>(this as SurveyContentBlock);
  }

  SurveyContentBlockCopyWith<SurveyContentBlock, SurveyContentBlock,
          SurveyContentBlock>
      get copyWith => _SurveyContentBlockCopyWithImpl<SurveyContentBlock,
          SurveyContentBlock>(this as SurveyContentBlock, $identity, $identity);
  @override
  String toString() {
    return SurveyContentBlockMapper.ensureInitialized()
        .stringifyValue(this as SurveyContentBlock);
  }

  @override
  bool operator ==(Object other) {
    return SurveyContentBlockMapper.ensureInitialized()
        .equalsValue(this as SurveyContentBlock, other);
  }

  @override
  int get hashCode {
    return SurveyContentBlockMapper.ensureInitialized()
        .hashValue(this as SurveyContentBlock);
  }
}

extension SurveyContentBlockValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyContentBlock, $Out> {
  SurveyContentBlockCopyWith<$R, SurveyContentBlock, $Out>
      get $asSurveyContentBlock => $base.as(
          (v, t, t2) => _SurveyContentBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyContentBlockCopyWith<$R, $In extends SurveyContentBlock,
    $Out> implements SurveyBlockCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? surveyId,
      String? pageId,
      int? position,
      String? markdown});
  SurveyContentBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyContentBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyContentBlock, $Out>
    implements SurveyContentBlockCopyWith<$R, SurveyContentBlock, $Out> {
  _SurveyContentBlockCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyContentBlock> $mapper =
      SurveyContentBlockMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? surveyId,
          String? pageId,
          int? position,
          String? markdown}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (pageId != null) #pageId: pageId,
        if (position != null) #position: position,
        if (markdown != null) #markdown: markdown
      }));
  @override
  SurveyContentBlock $make(CopyWithData data) => SurveyContentBlock(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      pageId: data.get(#pageId, or: $value.pageId),
      position: data.get(#position, or: $value.position),
      markdown: data.get(#markdown, or: $value.markdown));

  @override
  SurveyContentBlockCopyWith<$R2, SurveyContentBlock, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyContentBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
