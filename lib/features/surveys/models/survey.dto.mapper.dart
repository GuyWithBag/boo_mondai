// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey.dto.dart';

class SurveyMapper extends ClassMapperBase<Survey> {
  SurveyMapper._();

  static SurveyMapper? _instance;
  static SurveyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyMapper._());
      SurveyStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Survey';

  static String _$id(Survey v) => v.id;
  static const Field<Survey, String> _f$id = Field('id', _$id);
  static String _$profileId(Survey v) => v.profileId;
  static const Field<Survey, String> _f$profileId = Field(
    'profileId',
    _$profileId,
    key: r'profile_id',
  );
  static String _$title(Survey v) => v.title;
  static const Field<Survey, String> _f$title = Field('title', _$title);
  static String _$description(Survey v) => v.description;
  static const Field<Survey, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
    def: '',
  );
  static SurveyStatus _$status(Survey v) => v.status;
  static const Field<Survey, SurveyStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: SurveyStatus.draft,
  );
  static DateTime _$createdAt(Survey v) => v.createdAt;
  static const Field<Survey, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(Survey v) => v.updatedAt;
  static const Field<Survey, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<Survey> fields = const {
    #id: _f$id,
    #profileId: _f$profileId,
    #title: _f$title,
    #description: _f$description,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static Survey _instantiate(DecodingData data) {
    return Survey(
      id: data.dec(_f$id),
      profileId: data.dec(_f$profileId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Survey fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Survey>(map);
  }

  static Survey fromJson(String json) {
    return ensureInitialized().decodeJson<Survey>(json);
  }
}

mixin SurveyMappable {
  String toJson() {
    return SurveyMapper.ensureInitialized().encodeJson<Survey>(this as Survey);
  }

  Map<String, dynamic> toMap() {
    return SurveyMapper.ensureInitialized().encodeMap<Survey>(this as Survey);
  }

  SurveyCopyWith<Survey, Survey, Survey> get copyWith =>
      _SurveyCopyWithImpl<Survey, Survey>(this as Survey, $identity, $identity);
  @override
  String toString() {
    return SurveyMapper.ensureInitialized().stringifyValue(this as Survey);
  }

  @override
  bool operator ==(Object other) {
    return SurveyMapper.ensureInitialized().equalsValue(this as Survey, other);
  }

  @override
  int get hashCode {
    return SurveyMapper.ensureInitialized().hashValue(this as Survey);
  }
}

extension SurveyValueCopy<$R, $Out> on ObjectCopyWith<$R, Survey, $Out> {
  SurveyCopyWith<$R, Survey, $Out> get $asSurvey =>
      $base.as((v, t, t2) => _SurveyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyCopyWith<$R, $In extends Survey, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? profileId,
    String? title,
    String? description,
    SurveyStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  SurveyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SurveyCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Survey, $Out>
    implements SurveyCopyWith<$R, Survey, $Out> {
  _SurveyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Survey> $mapper = SurveyMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? profileId,
    String? title,
    String? description,
    SurveyStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (profileId != null) #profileId: profileId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  Survey $make(CopyWithData data) => Survey(
    id: data.get(#id, or: $value.id),
    profileId: data.get(#profileId, or: $value.profileId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  SurveyCopyWith<$R2, Survey, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SurveyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
