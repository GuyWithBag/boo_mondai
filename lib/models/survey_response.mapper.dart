// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_response.dart';

class SurveyResponseMapper extends ClassMapperBase<SurveyResponse> {
  SurveyResponseMapper._();

  static SurveyResponseMapper? _instance;
  static SurveyResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyResponse';

  static String _$id(SurveyResponse v) => v.id;
  static const Field<SurveyResponse, String> _f$id = Field('id', _$id);
  static String _$userId(SurveyResponse v) => v.userId;
  static const Field<SurveyResponse, String> _f$userId =
      Field('userId', _$userId);
  static String _$surveyType(SurveyResponse v) => v.surveyType;
  static const Field<SurveyResponse, String> _f$surveyType =
      Field('surveyType', _$surveyType);
  static String? _$timePoint(SurveyResponse v) => v.timePoint;
  static const Field<SurveyResponse, String> _f$timePoint =
      Field('timePoint', _$timePoint, opt: true);
  static Map<String, dynamic> _$responses(SurveyResponse v) => v.responses;
  static const Field<SurveyResponse, Map<String, dynamic>> _f$responses =
      Field('responses', _$responses);
  static double? _$computedScore(SurveyResponse v) => v.computedScore;
  static const Field<SurveyResponse, double> _f$computedScore =
      Field('computedScore', _$computedScore, opt: true);
  static DateTime _$submittedAt(SurveyResponse v) => v.submittedAt;
  static const Field<SurveyResponse, DateTime> _f$submittedAt =
      Field('submittedAt', _$submittedAt);

  @override
  final MappableFields<SurveyResponse> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #surveyType: _f$surveyType,
    #timePoint: _f$timePoint,
    #responses: _f$responses,
    #computedScore: _f$computedScore,
    #submittedAt: _f$submittedAt,
  };

  static SurveyResponse _instantiate(DecodingData data) {
    return SurveyResponse(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        surveyType: data.dec(_f$surveyType),
        timePoint: data.dec(_f$timePoint),
        responses: data.dec(_f$responses),
        computedScore: data.dec(_f$computedScore),
        submittedAt: data.dec(_f$submittedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyResponse>(map);
  }

  static SurveyResponse fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyResponse>(json);
  }
}

mixin SurveyResponseMappable {
  String toJson() {
    return SurveyResponseMapper.ensureInitialized()
        .encodeJson<SurveyResponse>(this as SurveyResponse);
  }

  Map<String, dynamic> toMap() {
    return SurveyResponseMapper.ensureInitialized()
        .encodeMap<SurveyResponse>(this as SurveyResponse);
  }

  SurveyResponseCopyWith<SurveyResponse, SurveyResponse, SurveyResponse>
      get copyWith =>
          _SurveyResponseCopyWithImpl<SurveyResponse, SurveyResponse>(
              this as SurveyResponse, $identity, $identity);
  @override
  String toString() {
    return SurveyResponseMapper.ensureInitialized()
        .stringifyValue(this as SurveyResponse);
  }

  @override
  bool operator ==(Object other) {
    return SurveyResponseMapper.ensureInitialized()
        .equalsValue(this as SurveyResponse, other);
  }

  @override
  int get hashCode {
    return SurveyResponseMapper.ensureInitialized()
        .hashValue(this as SurveyResponse);
  }
}

extension SurveyResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyResponse, $Out> {
  SurveyResponseCopyWith<$R, SurveyResponse, $Out> get $asSurveyResponse =>
      $base.as((v, t, t2) => _SurveyResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyResponseCopyWith<$R, $In extends SurveyResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get responses;
  $R call(
      {String? id,
      String? userId,
      String? surveyType,
      String? timePoint,
      Map<String, dynamic>? responses,
      double? computedScore,
      DateTime? submittedAt});
  SurveyResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyResponse, $Out>
    implements SurveyResponseCopyWith<$R, SurveyResponse, $Out> {
  _SurveyResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyResponse> $mapper =
      SurveyResponseMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get responses => MapCopyWith($value.responses,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(responses: v));
  @override
  $R call(
          {String? id,
          String? userId,
          String? surveyType,
          Object? timePoint = $none,
          Map<String, dynamic>? responses,
          Object? computedScore = $none,
          DateTime? submittedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (surveyType != null) #surveyType: surveyType,
        if (timePoint != $none) #timePoint: timePoint,
        if (responses != null) #responses: responses,
        if (computedScore != $none) #computedScore: computedScore,
        if (submittedAt != null) #submittedAt: submittedAt
      }));
  @override
  SurveyResponse $make(CopyWithData data) => SurveyResponse(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      surveyType: data.get(#surveyType, or: $value.surveyType),
      timePoint: data.get(#timePoint, or: $value.timePoint),
      responses: data.get(#responses, or: $value.responses),
      computedScore: data.get(#computedScore, or: $value.computedScore),
      submittedAt: data.get(#submittedAt, or: $value.submittedAt));

  @override
  SurveyResponseCopyWith<$R2, SurveyResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
