// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_response.dto.dart';

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
  static String _$surveyId(SurveyResponse v) => v.surveyId;
  static const Field<SurveyResponse, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$profileId(SurveyResponse v) => v.profileId;
  static const Field<SurveyResponse, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');
  static String? _$assignmentId(SurveyResponse v) => v.assignmentId;
  static const Field<SurveyResponse, String> _f$assignmentId =
      Field('assignmentId', _$assignmentId, key: r'assignment_id', opt: true);
  static Map<String, dynamic> _$answers(SurveyResponse v) => v.answers;
  static const Field<SurveyResponse, Map<String, dynamic>> _f$answers =
      Field('answers', _$answers);
  static DateTime _$submittedAt(SurveyResponse v) => v.submittedAt;
  static const Field<SurveyResponse, DateTime> _f$submittedAt =
      Field('submittedAt', _$submittedAt, key: r'submitted_at');

  @override
  final MappableFields<SurveyResponse> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #profileId: _f$profileId,
    #assignmentId: _f$assignmentId,
    #answers: _f$answers,
    #submittedAt: _f$submittedAt,
  };

  static SurveyResponse _instantiate(DecodingData data) {
    return SurveyResponse(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        profileId: data.dec(_f$profileId),
        assignmentId: data.dec(_f$assignmentId),
        answers: data.dec(_f$answers),
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
      get answers;
  $R call(
      {String? id,
      String? surveyId,
      String? profileId,
      String? assignmentId,
      Map<String, dynamic>? answers,
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
      get answers => MapCopyWith($value.answers,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(answers: v));
  @override
  $R call(
          {String? id,
          String? surveyId,
          String? profileId,
          Object? assignmentId = $none,
          Map<String, dynamic>? answers,
          DateTime? submittedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (profileId != null) #profileId: profileId,
        if (assignmentId != $none) #assignmentId: assignmentId,
        if (answers != null) #answers: answers,
        if (submittedAt != null) #submittedAt: submittedAt
      }));
  @override
  SurveyResponse $make(CopyWithData data) => SurveyResponse(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      profileId: data.get(#profileId, or: $value.profileId),
      assignmentId: data.get(#assignmentId, or: $value.assignmentId),
      answers: data.get(#answers, or: $value.answers),
      submittedAt: data.get(#submittedAt, or: $value.submittedAt));

  @override
  SurveyResponseCopyWith<$R2, SurveyResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
