// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vector2.hive.dart';

class Vector2HiveMapper extends ClassMapperBase<Vector2Hive> {
  Vector2HiveMapper._();

  static Vector2HiveMapper? _instance;
  static Vector2HiveMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = Vector2HiveMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Vector2Hive';

  static double _$x(Vector2Hive v) => v.x;
  static const Field<Vector2Hive, double> _f$x = Field('x', _$x);
  static double _$y(Vector2Hive v) => v.y;
  static const Field<Vector2Hive, double> _f$y = Field('y', _$y);

  @override
  final MappableFields<Vector2Hive> fields = const {
    #x: _f$x,
    #y: _f$y,
  };

  static Vector2Hive _instantiate(DecodingData data) {
    return Vector2Hive(data.dec(_f$x), data.dec(_f$y));
  }

  @override
  final Function instantiate = _instantiate;

  static Vector2Hive fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Vector2Hive>(map);
  }

  static Vector2Hive fromJson(String json) {
    return ensureInitialized().decodeJson<Vector2Hive>(json);
  }
}

mixin Vector2HiveMappable {
  String toJson() {
    return Vector2HiveMapper.ensureInitialized()
        .encodeJson<Vector2Hive>(this as Vector2Hive);
  }

  Map<String, dynamic> toMap() {
    return Vector2HiveMapper.ensureInitialized()
        .encodeMap<Vector2Hive>(this as Vector2Hive);
  }

  Vector2HiveCopyWith<Vector2Hive, Vector2Hive, Vector2Hive> get copyWith =>
      _Vector2HiveCopyWithImpl<Vector2Hive, Vector2Hive>(
          this as Vector2Hive, $identity, $identity);
  @override
  String toString() {
    return Vector2HiveMapper.ensureInitialized()
        .stringifyValue(this as Vector2Hive);
  }

  @override
  bool operator ==(Object other) {
    return Vector2HiveMapper.ensureInitialized()
        .equalsValue(this as Vector2Hive, other);
  }

  @override
  int get hashCode {
    return Vector2HiveMapper.ensureInitialized().hashValue(this as Vector2Hive);
  }
}

extension Vector2HiveValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Vector2Hive, $Out> {
  Vector2HiveCopyWith<$R, Vector2Hive, $Out> get $asVector2Hive =>
      $base.as((v, t, t2) => _Vector2HiveCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class Vector2HiveCopyWith<$R, $In extends Vector2Hive, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? x, double? y});
  Vector2HiveCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _Vector2HiveCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Vector2Hive, $Out>
    implements Vector2HiveCopyWith<$R, Vector2Hive, $Out> {
  _Vector2HiveCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Vector2Hive> $mapper =
      Vector2HiveMapper.ensureInitialized();
  @override
  $R call({double? x, double? y}) =>
      $apply(FieldCopyWithData({if (x != null) #x: x, if (y != null) #y: y}));
  @override
  Vector2Hive $make(CopyWithData data) =>
      Vector2Hive(data.get(#x, or: $value.x), data.get(#y, or: $value.y));

  @override
  Vector2HiveCopyWith<$R2, Vector2Hive, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _Vector2HiveCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
