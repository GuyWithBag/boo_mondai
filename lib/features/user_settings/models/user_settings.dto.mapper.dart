// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_settings.dto.dart';

class UserSettingsMapper extends ClassMapperBase<UserSettings> {
  UserSettingsMapper._();

  static UserSettingsMapper? _instance;
  static UserSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserSettingsMapper._());
      ThemeOverrideMapper.ensureInitialized();
      CustomThemePresetMapper.ensureInitialized();
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
  static String _$themeModeName(UserSettings v) => v.themeModeName;
  static const Field<UserSettings, String> _f$themeModeName =
      Field('themeModeName', _$themeModeName, key: r'theme_mode_name');
  static String _$lightThemePresetId(UserSettings v) => v.lightThemePresetId;
  static const Field<UserSettings, String> _f$lightThemePresetId = Field(
      'lightThemePresetId', _$lightThemePresetId,
      key: r'light_theme_preset_id');
  static String _$darkThemePresetId(UserSettings v) => v.darkThemePresetId;
  static const Field<UserSettings, String> _f$darkThemePresetId = Field(
      'darkThemePresetId', _$darkThemePresetId,
      key: r'dark_theme_preset_id');
  static ThemeOverride? _$themeOverride(UserSettings v) => v.themeOverride;
  static const Field<UserSettings, ThemeOverride> _f$themeOverride = Field(
      'themeOverride', _$themeOverride,
      key: r'theme_override', opt: true);
  static List<CustomThemePreset> _$customThemePresets(UserSettings v) =>
      v.customThemePresets;
  static const Field<UserSettings, List<CustomThemePreset>>
      _f$customThemePresets = Field('customThemePresets', _$customThemePresets,
          key: r'custom_theme_presets', opt: true, def: const []);
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
    #themeModeName: _f$themeModeName,
    #lightThemePresetId: _f$lightThemePresetId,
    #darkThemePresetId: _f$darkThemePresetId,
    #themeOverride: _f$themeOverride,
    #customThemePresets: _f$customThemePresets,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static UserSettings _instantiate(DecodingData data) {
    return UserSettings(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        themeModeName: data.dec(_f$themeModeName),
        lightThemePresetId: data.dec(_f$lightThemePresetId),
        darkThemePresetId: data.dec(_f$darkThemePresetId),
        themeOverride: data.dec(_f$themeOverride),
        customThemePresets: data.dec(_f$customThemePresets),
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
  ThemeOverrideCopyWith<$R, ThemeOverride, ThemeOverride>? get themeOverride;
  ListCopyWith<$R, CustomThemePreset,
          CustomThemePresetCopyWith<$R, CustomThemePreset, CustomThemePreset>>
      get customThemePresets;
  $R call(
      {String? id,
      String? userId,
      String? themeModeName,
      String? lightThemePresetId,
      String? darkThemePresetId,
      ThemeOverride? themeOverride,
      List<CustomThemePreset>? customThemePresets,
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
  ThemeOverrideCopyWith<$R, ThemeOverride, ThemeOverride>? get themeOverride =>
      $value.themeOverride?.copyWith.$chain((v) => call(themeOverride: v));
  @override
  ListCopyWith<$R, CustomThemePreset,
          CustomThemePresetCopyWith<$R, CustomThemePreset, CustomThemePreset>>
      get customThemePresets => ListCopyWith($value.customThemePresets,
          (v, t) => v.copyWith.$chain(t), (v) => call(customThemePresets: v));
  @override
  $R call(
          {String? id,
          String? userId,
          String? themeModeName,
          String? lightThemePresetId,
          String? darkThemePresetId,
          Object? themeOverride = $none,
          List<CustomThemePreset>? customThemePresets,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (themeModeName != null) #themeModeName: themeModeName,
        if (lightThemePresetId != null) #lightThemePresetId: lightThemePresetId,
        if (darkThemePresetId != null) #darkThemePresetId: darkThemePresetId,
        if (themeOverride != $none) #themeOverride: themeOverride,
        if (customThemePresets != null) #customThemePresets: customThemePresets,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  UserSettings $make(CopyWithData data) => UserSettings(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      themeModeName: data.get(#themeModeName, or: $value.themeModeName),
      lightThemePresetId:
          data.get(#lightThemePresetId, or: $value.lightThemePresetId),
      darkThemePresetId:
          data.get(#darkThemePresetId, or: $value.darkThemePresetId),
      themeOverride: data.get(#themeOverride, or: $value.themeOverride),
      customThemePresets:
          data.get(#customThemePresets, or: $value.customThemePresets),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  UserSettingsCopyWith<$R2, UserSettings, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
