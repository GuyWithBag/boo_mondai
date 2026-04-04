// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'research_code.dart';

class ResearchCodeMapper extends ClassMapperBase<ResearchCode> {
  ResearchCodeMapper._();

  static ResearchCodeMapper? _instance;
  static ResearchCodeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ResearchCodeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ResearchCode';

  static String _$id(ResearchCode v) => v.id;
  static const Field<ResearchCode, String> _f$id = Field('id', _$id);
  static String _$code(ResearchCode v) => v.code;
  static const Field<ResearchCode, String> _f$code = Field('code', _$code);
  static String _$targetRole(ResearchCode v) => v.targetRole;
  static const Field<ResearchCode, String> _f$targetRole =
      Field('targetRole', _$targetRole);
  static String _$unlocks(ResearchCode v) => v.unlocks;
  static const Field<ResearchCode, String> _f$unlocks =
      Field('unlocks', _$unlocks);
  static String _$createdBy(ResearchCode v) => v.createdBy;
  static const Field<ResearchCode, String> _f$createdBy =
      Field('createdBy', _$createdBy);
  static String? _$usedBy(ResearchCode v) => v.usedBy;
  static const Field<ResearchCode, String> _f$usedBy =
      Field('usedBy', _$usedBy, opt: true);
  static DateTime? _$usedAt(ResearchCode v) => v.usedAt;
  static const Field<ResearchCode, DateTime> _f$usedAt =
      Field('usedAt', _$usedAt, opt: true);
  static DateTime _$createdAt(ResearchCode v) => v.createdAt;
  static const Field<ResearchCode, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);

  @override
  final MappableFields<ResearchCode> fields = const {
    #id: _f$id,
    #code: _f$code,
    #targetRole: _f$targetRole,
    #unlocks: _f$unlocks,
    #createdBy: _f$createdBy,
    #usedBy: _f$usedBy,
    #usedAt: _f$usedAt,
    #createdAt: _f$createdAt,
  };

  static ResearchCode _instantiate(DecodingData data) {
    return ResearchCode(
        id: data.dec(_f$id),
        code: data.dec(_f$code),
        targetRole: data.dec(_f$targetRole),
        unlocks: data.dec(_f$unlocks),
        createdBy: data.dec(_f$createdBy),
        usedBy: data.dec(_f$usedBy),
        usedAt: data.dec(_f$usedAt),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ResearchCode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ResearchCode>(map);
  }

  static ResearchCode fromJson(String json) {
    return ensureInitialized().decodeJson<ResearchCode>(json);
  }
}

mixin ResearchCodeMappable {
  String toJson() {
    return ResearchCodeMapper.ensureInitialized()
        .encodeJson<ResearchCode>(this as ResearchCode);
  }

  Map<String, dynamic> toMap() {
    return ResearchCodeMapper.ensureInitialized()
        .encodeMap<ResearchCode>(this as ResearchCode);
  }

  ResearchCodeCopyWith<ResearchCode, ResearchCode, ResearchCode> get copyWith =>
      _ResearchCodeCopyWithImpl<ResearchCode, ResearchCode>(
          this as ResearchCode, $identity, $identity);
  @override
  String toString() {
    return ResearchCodeMapper.ensureInitialized()
        .stringifyValue(this as ResearchCode);
  }

  @override
  bool operator ==(Object other) {
    return ResearchCodeMapper.ensureInitialized()
        .equalsValue(this as ResearchCode, other);
  }

  @override
  int get hashCode {
    return ResearchCodeMapper.ensureInitialized()
        .hashValue(this as ResearchCode);
  }
}

extension ResearchCodeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ResearchCode, $Out> {
  ResearchCodeCopyWith<$R, ResearchCode, $Out> get $asResearchCode =>
      $base.as((v, t, t2) => _ResearchCodeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ResearchCodeCopyWith<$R, $In extends ResearchCode, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? code,
      String? targetRole,
      String? unlocks,
      String? createdBy,
      String? usedBy,
      DateTime? usedAt,
      DateTime? createdAt});
  ResearchCodeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ResearchCodeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ResearchCode, $Out>
    implements ResearchCodeCopyWith<$R, ResearchCode, $Out> {
  _ResearchCodeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ResearchCode> $mapper =
      ResearchCodeMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? code,
          String? targetRole,
          String? unlocks,
          String? createdBy,
          Object? usedBy = $none,
          Object? usedAt = $none,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (code != null) #code: code,
        if (targetRole != null) #targetRole: targetRole,
        if (unlocks != null) #unlocks: unlocks,
        if (createdBy != null) #createdBy: createdBy,
        if (usedBy != $none) #usedBy: usedBy,
        if (usedAt != $none) #usedAt: usedAt,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  ResearchCode $make(CopyWithData data) => ResearchCode(
      id: data.get(#id, or: $value.id),
      code: data.get(#code, or: $value.code),
      targetRole: data.get(#targetRole, or: $value.targetRole),
      unlocks: data.get(#unlocks, or: $value.unlocks),
      createdBy: data.get(#createdBy, or: $value.createdBy),
      usedBy: data.get(#usedBy, or: $value.usedBy),
      usedAt: data.get(#usedAt, or: $value.usedAt),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  ResearchCodeCopyWith<$R2, ResearchCode, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ResearchCodeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
