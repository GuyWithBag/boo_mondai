// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'matching_type.value.dto.dart';

class MatchingTypeValueMapper extends ClassMapperBase<MatchingTypeValue> {
  MatchingTypeValueMapper._();

  static MatchingTypeValueMapper? _instance;
  static MatchingTypeValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchingTypeValueMapper._());
      Vector2HiveMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MatchingTypeValue';

  static String _$text(MatchingTypeValue v) => v.text;
  static const Field<MatchingTypeValue, String> _f$text = Field('text', _$text);
  static Vector2Hive _$matchPosition(MatchingTypeValue v) => v.matchPosition;
  static const Field<MatchingTypeValue, Vector2Hive> _f$matchPosition =
      Field('matchPosition', _$matchPosition, key: r'match_position');
  static Vector2Hive _$position(MatchingTypeValue v) => v.position;
  static const Field<MatchingTypeValue, Vector2Hive> _f$position =
      Field('position', _$position);

  @override
  final MappableFields<MatchingTypeValue> fields = const {
    #text: _f$text,
    #matchPosition: _f$matchPosition,
    #position: _f$position,
  };

  static MatchingTypeValue _instantiate(DecodingData data) {
    return MatchingTypeValue(
        text: data.dec(_f$text),
        matchPosition: data.dec(_f$matchPosition),
        position: data.dec(_f$position));
  }

  @override
  final Function instantiate = _instantiate;

  static MatchingTypeValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchingTypeValue>(map);
  }

  static MatchingTypeValue fromJson(String json) {
    return ensureInitialized().decodeJson<MatchingTypeValue>(json);
  }
}

mixin MatchingTypeValueMappable {
  String toJson() {
    return MatchingTypeValueMapper.ensureInitialized()
        .encodeJson<MatchingTypeValue>(this as MatchingTypeValue);
  }

  Map<String, dynamic> toMap() {
    return MatchingTypeValueMapper.ensureInitialized()
        .encodeMap<MatchingTypeValue>(this as MatchingTypeValue);
  }

  MatchingTypeValueCopyWith<MatchingTypeValue, MatchingTypeValue,
          MatchingTypeValue>
      get copyWith =>
          _MatchingTypeValueCopyWithImpl<MatchingTypeValue, MatchingTypeValue>(
              this as MatchingTypeValue, $identity, $identity);
  @override
  String toString() {
    return MatchingTypeValueMapper.ensureInitialized()
        .stringifyValue(this as MatchingTypeValue);
  }

  @override
  bool operator ==(Object other) {
    return MatchingTypeValueMapper.ensureInitialized()
        .equalsValue(this as MatchingTypeValue, other);
  }

  @override
  int get hashCode {
    return MatchingTypeValueMapper.ensureInitialized()
        .hashValue(this as MatchingTypeValue);
  }
}

extension MatchingTypeValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchingTypeValue, $Out> {
  MatchingTypeValueCopyWith<$R, MatchingTypeValue, $Out>
      get $asMatchingTypeValue => $base
          .as((v, t, t2) => _MatchingTypeValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchingTypeValueCopyWith<$R, $In extends MatchingTypeValue,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  Vector2HiveCopyWith<$R, Vector2Hive, Vector2Hive> get matchPosition;
  Vector2HiveCopyWith<$R, Vector2Hive, Vector2Hive> get position;
  $R call({String? text, Vector2Hive? matchPosition, Vector2Hive? position});
  MatchingTypeValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MatchingTypeValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchingTypeValue, $Out>
    implements MatchingTypeValueCopyWith<$R, MatchingTypeValue, $Out> {
  _MatchingTypeValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchingTypeValue> $mapper =
      MatchingTypeValueMapper.ensureInitialized();
  @override
  Vector2HiveCopyWith<$R, Vector2Hive, Vector2Hive> get matchPosition =>
      $value.matchPosition.copyWith.$chain((v) => call(matchPosition: v));
  @override
  Vector2HiveCopyWith<$R, Vector2Hive, Vector2Hive> get position =>
      $value.position.copyWith.$chain((v) => call(position: v));
  @override
  $R call({String? text, Vector2Hive? matchPosition, Vector2Hive? position}) =>
      $apply(FieldCopyWithData({
        if (text != null) #text: text,
        if (matchPosition != null) #matchPosition: matchPosition,
        if (position != null) #position: position
      }));
  @override
  MatchingTypeValue $make(CopyWithData data) => MatchingTypeValue(
      text: data.get(#text, or: $value.text),
      matchPosition: data.get(#matchPosition, or: $value.matchPosition),
      position: data.get(#position, or: $value.position));

  @override
  MatchingTypeValueCopyWith<$R2, MatchingTypeValue, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MatchingTypeValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
