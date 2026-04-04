// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'research_profile.dart';

class ResearchProfileMapper extends ClassMapperBase<ResearchProfile> {
  ResearchProfileMapper._();

  static ResearchProfileMapper? _instance;
  static ResearchProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ResearchProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ResearchProfile';

  static String _$id(ResearchProfile v) => v.id;
  static const Field<ResearchProfile, String> _f$id = Field('id', _$id);
  static String _$userId(ResearchProfile v) => v.userId;
  static const Field<ResearchProfile, String> _f$userId =
      Field('userId', _$userId);
  static String? _$userName(ResearchProfile v) => v.userName;
  static const Field<ResearchProfile, String> _f$userName =
      Field('userName', _$userName, opt: true);
  static String _$role(ResearchProfile v) => v.role;
  static const Field<ResearchProfile, String> _f$role = Field('role', _$role);
  static String _$targetLanguage(ResearchProfile v) => v.targetLanguage;
  static const Field<ResearchProfile, String> _f$targetLanguage =
      Field('targetLanguage', _$targetLanguage);
  static DateTime _$createdAt(ResearchProfile v) => v.createdAt;
  static const Field<ResearchProfile, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String _$firstName(ResearchProfile v) => v.firstName;
  static const Field<ResearchProfile, String> _f$firstName =
      Field('firstName', _$firstName);
  static String _$lastName(ResearchProfile v) => v.lastName;
  static const Field<ResearchProfile, String> _f$lastName =
      Field('lastName', _$lastName);
  static int _$age(ResearchProfile v) => v.age;
  static const Field<ResearchProfile, int> _f$age = Field('age', _$age);

  @override
  final MappableFields<ResearchProfile> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #userName: _f$userName,
    #role: _f$role,
    #targetLanguage: _f$targetLanguage,
    #createdAt: _f$createdAt,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #age: _f$age,
  };

  static ResearchProfile _instantiate(DecodingData data) {
    return ResearchProfile(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        userName: data.dec(_f$userName),
        role: data.dec(_f$role),
        targetLanguage: data.dec(_f$targetLanguage),
        createdAt: data.dec(_f$createdAt),
        firstName: data.dec(_f$firstName),
        lastName: data.dec(_f$lastName),
        age: data.dec(_f$age));
  }

  @override
  final Function instantiate = _instantiate;

  static ResearchProfile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ResearchProfile>(map);
  }

  static ResearchProfile fromJson(String json) {
    return ensureInitialized().decodeJson<ResearchProfile>(json);
  }
}

mixin ResearchProfileMappable {
  String toJson() {
    return ResearchProfileMapper.ensureInitialized()
        .encodeJson<ResearchProfile>(this as ResearchProfile);
  }

  Map<String, dynamic> toMap() {
    return ResearchProfileMapper.ensureInitialized()
        .encodeMap<ResearchProfile>(this as ResearchProfile);
  }

  ResearchProfileCopyWith<ResearchProfile, ResearchProfile, ResearchProfile>
      get copyWith =>
          _ResearchProfileCopyWithImpl<ResearchProfile, ResearchProfile>(
              this as ResearchProfile, $identity, $identity);
  @override
  String toString() {
    return ResearchProfileMapper.ensureInitialized()
        .stringifyValue(this as ResearchProfile);
  }

  @override
  bool operator ==(Object other) {
    return ResearchProfileMapper.ensureInitialized()
        .equalsValue(this as ResearchProfile, other);
  }

  @override
  int get hashCode {
    return ResearchProfileMapper.ensureInitialized()
        .hashValue(this as ResearchProfile);
  }
}

extension ResearchProfileValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ResearchProfile, $Out> {
  ResearchProfileCopyWith<$R, ResearchProfile, $Out> get $asResearchProfile =>
      $base.as((v, t, t2) => _ResearchProfileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ResearchProfileCopyWith<$R, $In extends ResearchProfile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? userId,
      String? userName,
      String? role,
      String? targetLanguage,
      DateTime? createdAt,
      String? firstName,
      String? lastName,
      int? age});
  ResearchProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ResearchProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ResearchProfile, $Out>
    implements ResearchProfileCopyWith<$R, ResearchProfile, $Out> {
  _ResearchProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ResearchProfile> $mapper =
      ResearchProfileMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userId,
          Object? userName = $none,
          String? role,
          String? targetLanguage,
          DateTime? createdAt,
          String? firstName,
          String? lastName,
          int? age}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (userName != $none) #userName: userName,
        if (role != null) #role: role,
        if (targetLanguage != null) #targetLanguage: targetLanguage,
        if (createdAt != null) #createdAt: createdAt,
        if (firstName != null) #firstName: firstName,
        if (lastName != null) #lastName: lastName,
        if (age != null) #age: age
      }));
  @override
  ResearchProfile $make(CopyWithData data) => ResearchProfile(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      userName: data.get(#userName, or: $value.userName),
      role: data.get(#role, or: $value.role),
      targetLanguage: data.get(#targetLanguage, or: $value.targetLanguage),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      firstName: data.get(#firstName, or: $value.firstName),
      lastName: data.get(#lastName, or: $value.lastName),
      age: data.get(#age, or: $value.age));

  @override
  ResearchProfileCopyWith<$R2, ResearchProfile, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ResearchProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
