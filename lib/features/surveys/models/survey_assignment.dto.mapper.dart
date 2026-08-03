// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_assignment.dto.dart';

class SurveyAssignmentMapper extends ClassMapperBase<SurveyAssignment> {
  SurveyAssignmentMapper._();

  static SurveyAssignmentMapper? _instance;
  static SurveyAssignmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyAssignmentMapper._());
      SurveyAssignmentStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyAssignment';

  static String _$id(SurveyAssignment v) => v.id;
  static const Field<SurveyAssignment, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyAssignment v) => v.surveyId;
  static const Field<SurveyAssignment, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$profileId(SurveyAssignment v) => v.profileId;
  static const Field<SurveyAssignment, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');
  static SurveyAssignmentStatus _$status(SurveyAssignment v) => v.status;
  static const Field<SurveyAssignment, SurveyAssignmentStatus> _f$status =
      Field('status', _$status, opt: true, def: SurveyAssignmentStatus.pending);
  static DateTime _$assignedAt(SurveyAssignment v) => v.assignedAt;
  static const Field<SurveyAssignment, DateTime> _f$assignedAt =
      Field('assignedAt', _$assignedAt, key: r'assigned_at');
  static DateTime? _$dueAt(SurveyAssignment v) => v.dueAt;
  static const Field<SurveyAssignment, DateTime> _f$dueAt =
      Field('dueAt', _$dueAt, key: r'due_at', opt: true);
  static DateTime? _$completedAt(SurveyAssignment v) => v.completedAt;
  static const Field<SurveyAssignment, DateTime> _f$completedAt =
      Field('completedAt', _$completedAt, key: r'completed_at', opt: true);

  @override
  final MappableFields<SurveyAssignment> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #profileId: _f$profileId,
    #status: _f$status,
    #assignedAt: _f$assignedAt,
    #dueAt: _f$dueAt,
    #completedAt: _f$completedAt,
  };

  static SurveyAssignment _instantiate(DecodingData data) {
    return SurveyAssignment(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        profileId: data.dec(_f$profileId),
        status: data.dec(_f$status),
        assignedAt: data.dec(_f$assignedAt),
        dueAt: data.dec(_f$dueAt),
        completedAt: data.dec(_f$completedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyAssignment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyAssignment>(map);
  }

  static SurveyAssignment fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyAssignment>(json);
  }
}

mixin SurveyAssignmentMappable {
  String toJson() {
    return SurveyAssignmentMapper.ensureInitialized()
        .encodeJson<SurveyAssignment>(this as SurveyAssignment);
  }

  Map<String, dynamic> toMap() {
    return SurveyAssignmentMapper.ensureInitialized()
        .encodeMap<SurveyAssignment>(this as SurveyAssignment);
  }

  SurveyAssignmentCopyWith<SurveyAssignment, SurveyAssignment, SurveyAssignment>
      get copyWith =>
          _SurveyAssignmentCopyWithImpl<SurveyAssignment, SurveyAssignment>(
              this as SurveyAssignment, $identity, $identity);
  @override
  String toString() {
    return SurveyAssignmentMapper.ensureInitialized()
        .stringifyValue(this as SurveyAssignment);
  }

  @override
  bool operator ==(Object other) {
    return SurveyAssignmentMapper.ensureInitialized()
        .equalsValue(this as SurveyAssignment, other);
  }

  @override
  int get hashCode {
    return SurveyAssignmentMapper.ensureInitialized()
        .hashValue(this as SurveyAssignment);
  }
}

extension SurveyAssignmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyAssignment, $Out> {
  SurveyAssignmentCopyWith<$R, SurveyAssignment, $Out>
      get $asSurveyAssignment => $base
          .as((v, t, t2) => _SurveyAssignmentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyAssignmentCopyWith<$R, $In extends SurveyAssignment, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? surveyId,
      String? profileId,
      SurveyAssignmentStatus? status,
      DateTime? assignedAt,
      DateTime? dueAt,
      DateTime? completedAt});
  SurveyAssignmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyAssignmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyAssignment, $Out>
    implements SurveyAssignmentCopyWith<$R, SurveyAssignment, $Out> {
  _SurveyAssignmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyAssignment> $mapper =
      SurveyAssignmentMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? surveyId,
          String? profileId,
          SurveyAssignmentStatus? status,
          DateTime? assignedAt,
          Object? dueAt = $none,
          Object? completedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (profileId != null) #profileId: profileId,
        if (status != null) #status: status,
        if (assignedAt != null) #assignedAt: assignedAt,
        if (dueAt != $none) #dueAt: dueAt,
        if (completedAt != $none) #completedAt: completedAt
      }));
  @override
  SurveyAssignment $make(CopyWithData data) => SurveyAssignment(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      profileId: data.get(#profileId, or: $value.profileId),
      status: data.get(#status, or: $value.status),
      assignedAt: data.get(#assignedAt, or: $value.assignedAt),
      dueAt: data.get(#dueAt, or: $value.dueAt),
      completedAt: data.get(#completedAt, or: $value.completedAt));

  @override
  SurveyAssignmentCopyWith<$R2, SurveyAssignment, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyAssignmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
