// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_study_card_tag.dto.dart';

class UserStudyCardTagMapper extends ClassMapperBase<UserStudyCardTag> {
  UserStudyCardTagMapper._();

  static UserStudyCardTagMapper? _instance;
  static UserStudyCardTagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserStudyCardTagMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserStudyCardTag';

  static String _$userId(UserStudyCardTag v) => v.userId;
  static const Field<UserStudyCardTag, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$studyCardId(UserStudyCardTag v) => v.studyCardId;
  static const Field<UserStudyCardTag, String> _f$studyCardId = Field(
    'studyCardId',
    _$studyCardId,
    key: r'study_card_id',
  );
  static String _$tagId(UserStudyCardTag v) => v.tagId;
  static const Field<UserStudyCardTag, String> _f$tagId = Field(
    'tagId',
    _$tagId,
    key: r'tag_id',
  );

  @override
  final MappableFields<UserStudyCardTag> fields = const {
    #userId: _f$userId,
    #studyCardId: _f$studyCardId,
    #tagId: _f$tagId,
  };

  static UserStudyCardTag _instantiate(DecodingData data) {
    return UserStudyCardTag(
      userId: data.dec(_f$userId),
      studyCardId: data.dec(_f$studyCardId),
      tagId: data.dec(_f$tagId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserStudyCardTag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserStudyCardTag>(map);
  }

  static UserStudyCardTag fromJson(String json) {
    return ensureInitialized().decodeJson<UserStudyCardTag>(json);
  }
}

mixin UserStudyCardTagMappable {
  String toJson() {
    return UserStudyCardTagMapper.ensureInitialized()
        .encodeJson<UserStudyCardTag>(this as UserStudyCardTag);
  }

  Map<String, dynamic> toMap() {
    return UserStudyCardTagMapper.ensureInitialized()
        .encodeMap<UserStudyCardTag>(this as UserStudyCardTag);
  }

  UserStudyCardTagCopyWith<UserStudyCardTag, UserStudyCardTag, UserStudyCardTag>
  get copyWith =>
      _UserStudyCardTagCopyWithImpl<UserStudyCardTag, UserStudyCardTag>(
        this as UserStudyCardTag,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserStudyCardTagMapper.ensureInitialized().stringifyValue(
      this as UserStudyCardTag,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserStudyCardTagMapper.ensureInitialized().equalsValue(
      this as UserStudyCardTag,
      other,
    );
  }

  @override
  int get hashCode {
    return UserStudyCardTagMapper.ensureInitialized().hashValue(
      this as UserStudyCardTag,
    );
  }
}

extension UserStudyCardTagValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserStudyCardTag, $Out> {
  UserStudyCardTagCopyWith<$R, UserStudyCardTag, $Out>
  get $asUserStudyCardTag =>
      $base.as((v, t, t2) => _UserStudyCardTagCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserStudyCardTagCopyWith<$R, $In extends UserStudyCardTag, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, String? studyCardId, String? tagId});
  UserStudyCardTagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserStudyCardTagCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserStudyCardTag, $Out>
    implements UserStudyCardTagCopyWith<$R, UserStudyCardTag, $Out> {
  _UserStudyCardTagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserStudyCardTag> $mapper =
      UserStudyCardTagMapper.ensureInitialized();
  @override
  $R call({String? userId, String? studyCardId, String? tagId}) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (studyCardId != null) #studyCardId: studyCardId,
      if (tagId != null) #tagId: tagId,
    }),
  );
  @override
  UserStudyCardTag $make(CopyWithData data) => UserStudyCardTag(
    userId: data.get(#userId, or: $value.userId),
    studyCardId: data.get(#studyCardId, or: $value.studyCardId),
    tagId: data.get(#tagId, or: $value.tagId),
  );

  @override
  UserStudyCardTagCopyWith<$R2, UserStudyCardTag, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserStudyCardTagCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
