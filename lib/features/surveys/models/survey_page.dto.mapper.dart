// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_page.dto.dart';

class SurveyPageMapper extends ClassMapperBase<SurveyPage> {
  SurveyPageMapper._();

  static SurveyPageMapper? _instance;
  static SurveyPageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyPageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyPage';

  static String _$id(SurveyPage v) => v.id;
  static const Field<SurveyPage, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyPage v) => v.surveyId;
  static const Field<SurveyPage, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static int _$position(SurveyPage v) => v.position;
  static const Field<SurveyPage, int> _f$position =
      Field('position', _$position);
  static String? _$title(SurveyPage v) => v.title;
  static const Field<SurveyPage, String> _f$title =
      Field('title', _$title, opt: true);

  @override
  final MappableFields<SurveyPage> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #title: _f$title,
  };

  static SurveyPage _instantiate(DecodingData data) {
    return SurveyPage(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        position: data.dec(_f$position),
        title: data.dec(_f$title));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyPage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyPage>(map);
  }

  static SurveyPage fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyPage>(json);
  }
}

mixin SurveyPageMappable {
  String toJson() {
    return SurveyPageMapper.ensureInitialized()
        .encodeJson<SurveyPage>(this as SurveyPage);
  }

  Map<String, dynamic> toMap() {
    return SurveyPageMapper.ensureInitialized()
        .encodeMap<SurveyPage>(this as SurveyPage);
  }

  SurveyPageCopyWith<SurveyPage, SurveyPage, SurveyPage> get copyWith =>
      _SurveyPageCopyWithImpl<SurveyPage, SurveyPage>(
          this as SurveyPage, $identity, $identity);
  @override
  String toString() {
    return SurveyPageMapper.ensureInitialized()
        .stringifyValue(this as SurveyPage);
  }

  @override
  bool operator ==(Object other) {
    return SurveyPageMapper.ensureInitialized()
        .equalsValue(this as SurveyPage, other);
  }

  @override
  int get hashCode {
    return SurveyPageMapper.ensureInitialized().hashValue(this as SurveyPage);
  }
}

extension SurveyPageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyPage, $Out> {
  SurveyPageCopyWith<$R, SurveyPage, $Out> get $asSurveyPage =>
      $base.as((v, t, t2) => _SurveyPageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyPageCopyWith<$R, $In extends SurveyPage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? surveyId, int? position, String? title});
  SurveyPageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SurveyPageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyPage, $Out>
    implements SurveyPageCopyWith<$R, SurveyPage, $Out> {
  _SurveyPageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyPage> $mapper =
      SurveyPageMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? surveyId,
          int? position,
          Object? title = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (position != null) #position: position,
        if (title != $none) #title: title
      }));
  @override
  SurveyPage $make(CopyWithData data) => SurveyPage(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      position: data.get(#position, or: $value.position),
      title: data.get(#title, or: $value.title));

  @override
  SurveyPageCopyWith<$R2, SurveyPage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyPageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
