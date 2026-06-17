// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_settings.dart';

class UserSettingsMapper extends ClassMapperBase<UserSettings> {
  UserSettingsMapper._();

  static UserSettingsMapper? _instance;
  static UserSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserSettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserSettings';

  static String _$id(UserSettings v) => v.id;
  static const Field<UserSettings, String> _f$id = Field('id', _$id);
  static String _$userId(UserSettings v) => v.userId;
  static const Field<UserSettings, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static Map<String, dynamic> _$preferences(UserSettings v) => v.preferences;
  static const Field<UserSettings, Map<String, dynamic>> _f$preferences =
      Field('preferences', _$preferences);
  static DateTime _$createdAt(UserSettings v) => v.createdAt;
  static const Field<UserSettings, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(UserSettings v) => v.updatedAt;
  static const Field<UserSettings, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');

  @override
  final MappableFields<UserSettings> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #preferences: _f$preferences,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static UserSettings _instantiate(DecodingData data) {
    return UserSettings(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        preferences: data.dec(_f$preferences),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static UserSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserSettings>(map);
  }

  static UserSettings fromJson(String json) {
    return ensureInitialized().decodeJson<UserSettings>(json);
  }
}

mixin UserSettingsMappable {
  String toJson() {
    return UserSettingsMapper.ensureInitialized()
        .encodeJson<UserSettings>(this as UserSettings);
  }

  Map<String, dynamic> toMap() {
    return UserSettingsMapper.ensureInitialized()
        .encodeMap<UserSettings>(this as UserSettings);
  }

  UserSettingsCopyWith<UserSettings, UserSettings, UserSettings> get copyWith =>
      _UserSettingsCopyWithImpl<UserSettings, UserSettings>(
          this as UserSettings, $identity, $identity);
  @override
  String toString() {
    return UserSettingsMapper.ensureInitialized()
        .stringifyValue(this as UserSettings);
  }

  @override
  bool operator ==(Object other) {
    return UserSettingsMapper.ensureInitialized()
        .equalsValue(this as UserSettings, other);
  }

  @override
  int get hashCode {
    return UserSettingsMapper.ensureInitialized()
        .hashValue(this as UserSettings);
  }
}

extension UserSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserSettings, $Out> {
  UserSettingsCopyWith<$R, UserSettings, $Out> get $asUserSettings =>
      $base.as((v, t, t2) => _UserSettingsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserSettingsCopyWith<$R, $In extends UserSettings, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get preferences;
  $R call(
      {String? id,
      String? userId,
      Map<String, dynamic>? preferences,
      DateTime? createdAt,
      DateTime? updatedAt});
  UserSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserSettings, $Out>
    implements UserSettingsCopyWith<$R, UserSettings, $Out> {
  _UserSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserSettings> $mapper =
      UserSettingsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get preferences => MapCopyWith(
          $value.preferences,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(preferences: v));
  @override
  $R call(
          {String? id,
          String? userId,
          Map<String, dynamic>? preferences,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (preferences != null) #preferences: preferences,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  UserSettings $make(CopyWithData data) => UserSettings(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      preferences: data.get(#preferences, or: $value.preferences),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  UserSettingsCopyWith<$R2, UserSettings, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
