// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'custom_theme_preset.dto.dart';

class CustomThemePresetMapper extends ClassMapperBase<CustomThemePreset> {
  CustomThemePresetMapper._();

  static CustomThemePresetMapper? _instance;
  static CustomThemePresetMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CustomThemePresetMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CustomThemePreset';

  static String _$id(CustomThemePreset v) => v.id;
  static const Field<CustomThemePreset, String> _f$id = Field('id', _$id);
  static String _$name(CustomThemePreset v) => v.name;
  static const Field<CustomThemePreset, String> _f$name = Field('name', _$name);
  static Map<String, dynamic> _$lightTokens(CustomThemePreset v) =>
      v.lightTokens;
  static const Field<CustomThemePreset, Map<String, dynamic>> _f$lightTokens =
      Field('lightTokens', _$lightTokens, key: r'light_tokens');
  static Map<String, dynamic> _$darkTokens(CustomThemePreset v) => v.darkTokens;
  static const Field<CustomThemePreset, Map<String, dynamic>> _f$darkTokens =
      Field('darkTokens', _$darkTokens, key: r'dark_tokens');
  static String _$source(CustomThemePreset v) => v.source;
  static const Field<CustomThemePreset, String> _f$source =
      Field('source', _$source, opt: true, def: 'imported');
  static int _$schemaVersion(CustomThemePreset v) => v.schemaVersion;
  static const Field<CustomThemePreset, int> _f$schemaVersion = Field(
      'schemaVersion', _$schemaVersion,
      key: r'schema_version', opt: true, def: 1);
  static Map<String, dynamic> _$extraTokens(CustomThemePreset v) =>
      v.extraTokens;
  static const Field<CustomThemePreset, Map<String, dynamic>> _f$extraTokens =
      Field('extraTokens', _$extraTokens,
          key: r'extra_tokens', opt: true, def: const {});
  static DateTime _$createdAt(CustomThemePreset v) => v.createdAt;
  static const Field<CustomThemePreset, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(CustomThemePreset v) => v.updatedAt;
  static const Field<CustomThemePreset, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');

  @override
  final MappableFields<CustomThemePreset> fields = const {
    #id: _f$id,
    #name: _f$name,
    #lightTokens: _f$lightTokens,
    #darkTokens: _f$darkTokens,
    #source: _f$source,
    #schemaVersion: _f$schemaVersion,
    #extraTokens: _f$extraTokens,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static CustomThemePreset _instantiate(DecodingData data) {
    return CustomThemePreset(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        lightTokens: data.dec(_f$lightTokens),
        darkTokens: data.dec(_f$darkTokens),
        source: data.dec(_f$source),
        schemaVersion: data.dec(_f$schemaVersion),
        extraTokens: data.dec(_f$extraTokens),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static CustomThemePreset fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CustomThemePreset>(map);
  }

  static CustomThemePreset fromJson(String json) {
    return ensureInitialized().decodeJson<CustomThemePreset>(json);
  }
}

mixin CustomThemePresetMappable {
  String toJson() {
    return CustomThemePresetMapper.ensureInitialized()
        .encodeJson<CustomThemePreset>(this as CustomThemePreset);
  }

  Map<String, dynamic> toMap() {
    return CustomThemePresetMapper.ensureInitialized()
        .encodeMap<CustomThemePreset>(this as CustomThemePreset);
  }

  CustomThemePresetCopyWith<CustomThemePreset, CustomThemePreset,
          CustomThemePreset>
      get copyWith =>
          _CustomThemePresetCopyWithImpl<CustomThemePreset, CustomThemePreset>(
              this as CustomThemePreset, $identity, $identity);
  @override
  String toString() {
    return CustomThemePresetMapper.ensureInitialized()
        .stringifyValue(this as CustomThemePreset);
  }

  @override
  bool operator ==(Object other) {
    return CustomThemePresetMapper.ensureInitialized()
        .equalsValue(this as CustomThemePreset, other);
  }

  @override
  int get hashCode {
    return CustomThemePresetMapper.ensureInitialized()
        .hashValue(this as CustomThemePreset);
  }
}

extension CustomThemePresetValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CustomThemePreset, $Out> {
  CustomThemePresetCopyWith<$R, CustomThemePreset, $Out>
      get $asCustomThemePreset => $base
          .as((v, t, t2) => _CustomThemePresetCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CustomThemePresetCopyWith<$R, $In extends CustomThemePreset,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get lightTokens;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get darkTokens;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get extraTokens;
  $R call(
      {String? id,
      String? name,
      Map<String, dynamic>? lightTokens,
      Map<String, dynamic>? darkTokens,
      String? source,
      int? schemaVersion,
      Map<String, dynamic>? extraTokens,
      DateTime? createdAt,
      DateTime? updatedAt});
  CustomThemePresetCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _CustomThemePresetCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CustomThemePreset, $Out>
    implements CustomThemePresetCopyWith<$R, CustomThemePreset, $Out> {
  _CustomThemePresetCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CustomThemePreset> $mapper =
      CustomThemePresetMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get lightTokens => MapCopyWith(
          $value.lightTokens,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(lightTokens: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get darkTokens => MapCopyWith(
          $value.darkTokens,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(darkTokens: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get extraTokens => MapCopyWith(
          $value.extraTokens,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(extraTokens: v));
  @override
  $R call(
          {String? id,
          String? name,
          Map<String, dynamic>? lightTokens,
          Map<String, dynamic>? darkTokens,
          String? source,
          int? schemaVersion,
          Map<String, dynamic>? extraTokens,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (lightTokens != null) #lightTokens: lightTokens,
        if (darkTokens != null) #darkTokens: darkTokens,
        if (source != null) #source: source,
        if (schemaVersion != null) #schemaVersion: schemaVersion,
        if (extraTokens != null) #extraTokens: extraTokens,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  CustomThemePreset $make(CopyWithData data) => CustomThemePreset(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      lightTokens: data.get(#lightTokens, or: $value.lightTokens),
      darkTokens: data.get(#darkTokens, or: $value.darkTokens),
      source: data.get(#source, or: $value.source),
      schemaVersion: data.get(#schemaVersion, or: $value.schemaVersion),
      extraTokens: data.get(#extraTokens, or: $value.extraTokens),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  CustomThemePresetCopyWith<$R2, CustomThemePreset, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CustomThemePresetCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
