// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'theme_override.dto.dart';

class ThemeOverrideMapper extends ClassMapperBase<ThemeOverride> {
  ThemeOverrideMapper._();

  static ThemeOverrideMapper? _instance;
  static ThemeOverrideMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ThemeOverrideMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ThemeOverride';

  static int? _$primaryColorValue(ThemeOverride v) => v.primaryColorValue;
  static const Field<ThemeOverride, int> _f$primaryColorValue = Field(
    'primaryColorValue',
    _$primaryColorValue,
    key: r'primary_color_value',
    opt: true,
  );
  static String? _$fontFamily(ThemeOverride v) => v.fontFamily;
  static const Field<ThemeOverride, String> _f$fontFamily = Field(
    'fontFamily',
    _$fontFamily,
    key: r'font_family',
    opt: true,
  );
  static double? _$radiusScale(ThemeOverride v) => v.radiusScale;
  static const Field<ThemeOverride, double> _f$radiusScale = Field(
    'radiusScale',
    _$radiusScale,
    key: r'radius_scale',
    opt: true,
  );
  static double? _$spacingScale(ThemeOverride v) => v.spacingScale;
  static const Field<ThemeOverride, double> _f$spacingScale = Field(
    'spacingScale',
    _$spacingScale,
    key: r'spacing_scale',
    opt: true,
  );
  static double? _$textScale(ThemeOverride v) => v.textScale;
  static const Field<ThemeOverride, double> _f$textScale = Field(
    'textScale',
    _$textScale,
    key: r'text_scale',
    opt: true,
  );
  static bool? _$highContrast(ThemeOverride v) => v.highContrast;
  static const Field<ThemeOverride, bool> _f$highContrast = Field(
    'highContrast',
    _$highContrast,
    key: r'high_contrast',
    opt: true,
  );
  static bool? _$reducedMotion(ThemeOverride v) => v.reducedMotion;
  static const Field<ThemeOverride, bool> _f$reducedMotion = Field(
    'reducedMotion',
    _$reducedMotion,
    key: r'reduced_motion',
    opt: true,
  );
  static Map<String, dynamic> _$extraTokens(ThemeOverride v) => v.extraTokens;
  static const Field<ThemeOverride, Map<String, dynamic>> _f$extraTokens =
      Field(
        'extraTokens',
        _$extraTokens,
        key: r'extra_tokens',
        opt: true,
        def: const {},
      );

  @override
  final MappableFields<ThemeOverride> fields = const {
    #primaryColorValue: _f$primaryColorValue,
    #fontFamily: _f$fontFamily,
    #radiusScale: _f$radiusScale,
    #spacingScale: _f$spacingScale,
    #textScale: _f$textScale,
    #highContrast: _f$highContrast,
    #reducedMotion: _f$reducedMotion,
    #extraTokens: _f$extraTokens,
  };

  static ThemeOverride _instantiate(DecodingData data) {
    return ThemeOverride(
      primaryColorValue: data.dec(_f$primaryColorValue),
      fontFamily: data.dec(_f$fontFamily),
      radiusScale: data.dec(_f$radiusScale),
      spacingScale: data.dec(_f$spacingScale),
      textScale: data.dec(_f$textScale),
      highContrast: data.dec(_f$highContrast),
      reducedMotion: data.dec(_f$reducedMotion),
      extraTokens: data.dec(_f$extraTokens),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ThemeOverride fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ThemeOverride>(map);
  }

  static ThemeOverride fromJson(String json) {
    return ensureInitialized().decodeJson<ThemeOverride>(json);
  }
}

mixin ThemeOverrideMappable {
  String toJson() {
    return ThemeOverrideMapper.ensureInitialized().encodeJson<ThemeOverride>(
      this as ThemeOverride,
    );
  }

  Map<String, dynamic> toMap() {
    return ThemeOverrideMapper.ensureInitialized().encodeMap<ThemeOverride>(
      this as ThemeOverride,
    );
  }

  ThemeOverrideCopyWith<ThemeOverride, ThemeOverride, ThemeOverride>
  get copyWith => _ThemeOverrideCopyWithImpl<ThemeOverride, ThemeOverride>(
    this as ThemeOverride,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ThemeOverrideMapper.ensureInitialized().stringifyValue(
      this as ThemeOverride,
    );
  }

  @override
  bool operator ==(Object other) {
    return ThemeOverrideMapper.ensureInitialized().equalsValue(
      this as ThemeOverride,
      other,
    );
  }

  @override
  int get hashCode {
    return ThemeOverrideMapper.ensureInitialized().hashValue(
      this as ThemeOverride,
    );
  }
}

extension ThemeOverrideValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ThemeOverride, $Out> {
  ThemeOverrideCopyWith<$R, ThemeOverride, $Out> get $asThemeOverride =>
      $base.as((v, t, t2) => _ThemeOverrideCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ThemeOverrideCopyWith<$R, $In extends ThemeOverride, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get extraTokens;
  $R call({
    int? primaryColorValue,
    String? fontFamily,
    double? radiusScale,
    double? spacingScale,
    double? textScale,
    bool? highContrast,
    bool? reducedMotion,
    Map<String, dynamic>? extraTokens,
  });
  ThemeOverrideCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ThemeOverrideCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ThemeOverride, $Out>
    implements ThemeOverrideCopyWith<$R, ThemeOverride, $Out> {
  _ThemeOverrideCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ThemeOverride> $mapper =
      ThemeOverrideMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get extraTokens => MapCopyWith(
    $value.extraTokens,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(extraTokens: v),
  );
  @override
  $R call({
    Object? primaryColorValue = $none,
    Object? fontFamily = $none,
    Object? radiusScale = $none,
    Object? spacingScale = $none,
    Object? textScale = $none,
    Object? highContrast = $none,
    Object? reducedMotion = $none,
    Map<String, dynamic>? extraTokens,
  }) => $apply(
    FieldCopyWithData({
      if (primaryColorValue != $none) #primaryColorValue: primaryColorValue,
      if (fontFamily != $none) #fontFamily: fontFamily,
      if (radiusScale != $none) #radiusScale: radiusScale,
      if (spacingScale != $none) #spacingScale: spacingScale,
      if (textScale != $none) #textScale: textScale,
      if (highContrast != $none) #highContrast: highContrast,
      if (reducedMotion != $none) #reducedMotion: reducedMotion,
      if (extraTokens != null) #extraTokens: extraTokens,
    }),
  );
  @override
  ThemeOverride $make(CopyWithData data) => ThemeOverride(
    primaryColorValue: data.get(
      #primaryColorValue,
      or: $value.primaryColorValue,
    ),
    fontFamily: data.get(#fontFamily, or: $value.fontFamily),
    radiusScale: data.get(#radiusScale, or: $value.radiusScale),
    spacingScale: data.get(#spacingScale, or: $value.spacingScale),
    textScale: data.get(#textScale, or: $value.textScale),
    highContrast: data.get(#highContrast, or: $value.highContrast),
    reducedMotion: data.get(#reducedMotion, or: $value.reducedMotion),
    extraTokens: data.get(#extraTokens, or: $value.extraTokens),
  );

  @override
  ThemeOverrideCopyWith<$R2, ThemeOverride, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ThemeOverrideCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
