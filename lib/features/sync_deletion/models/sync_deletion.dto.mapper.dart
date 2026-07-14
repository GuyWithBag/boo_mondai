// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sync_deletion.dto.dart';

class SyncDeletionMapper extends ClassMapperBase<SyncDeletion> {
  SyncDeletionMapper._();

  static SyncDeletionMapper? _instance;
  static SyncDeletionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyncDeletionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SyncDeletion';

  static String _$id(SyncDeletion v) => v.id;
  static const Field<SyncDeletion, String> _f$id = Field('id', _$id);
  static String _$entityType(SyncDeletion v) => v.entityType;
  static const Field<SyncDeletion, String> _f$entityType = Field(
    'entityType',
    _$entityType,
    key: r'entity_type',
  );
  static String _$entityId(SyncDeletion v) => v.entityId;
  static const Field<SyncDeletion, String> _f$entityId = Field(
    'entityId',
    _$entityId,
    key: r'entity_id',
  );
  static String _$userId(SyncDeletion v) => v.userId;
  static const Field<SyncDeletion, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static DateTime _$deletedAt(SyncDeletion v) => v.deletedAt;
  static const Field<SyncDeletion, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    key: r'deleted_at',
  );
  static DateTime _$createdAt(SyncDeletion v) => v.createdAt;
  static const Field<SyncDeletion, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String? _$scopeType(SyncDeletion v) => v.scopeType;
  static const Field<SyncDeletion, String> _f$scopeType = Field(
    'scopeType',
    _$scopeType,
    key: r'scope_type',
    opt: true,
  );
  static String? _$scopeId(SyncDeletion v) => v.scopeId;
  static const Field<SyncDeletion, String> _f$scopeId = Field(
    'scopeId',
    _$scopeId,
    key: r'scope_id',
    opt: true,
  );

  @override
  final MappableFields<SyncDeletion> fields = const {
    #id: _f$id,
    #entityType: _f$entityType,
    #entityId: _f$entityId,
    #userId: _f$userId,
    #deletedAt: _f$deletedAt,
    #createdAt: _f$createdAt,
    #scopeType: _f$scopeType,
    #scopeId: _f$scopeId,
  };

  static SyncDeletion _instantiate(DecodingData data) {
    return SyncDeletion(
      id: data.dec(_f$id),
      entityType: data.dec(_f$entityType),
      entityId: data.dec(_f$entityId),
      userId: data.dec(_f$userId),
      deletedAt: data.dec(_f$deletedAt),
      createdAt: data.dec(_f$createdAt),
      scopeType: data.dec(_f$scopeType),
      scopeId: data.dec(_f$scopeId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SyncDeletion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyncDeletion>(map);
  }

  static SyncDeletion fromJson(String json) {
    return ensureInitialized().decodeJson<SyncDeletion>(json);
  }
}

mixin SyncDeletionMappable {
  String toJson() {
    return SyncDeletionMapper.ensureInitialized().encodeJson<SyncDeletion>(
      this as SyncDeletion,
    );
  }

  Map<String, dynamic> toMap() {
    return SyncDeletionMapper.ensureInitialized().encodeMap<SyncDeletion>(
      this as SyncDeletion,
    );
  }

  SyncDeletionCopyWith<SyncDeletion, SyncDeletion, SyncDeletion> get copyWith =>
      _SyncDeletionCopyWithImpl<SyncDeletion, SyncDeletion>(
        this as SyncDeletion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SyncDeletionMapper.ensureInitialized().stringifyValue(
      this as SyncDeletion,
    );
  }

  @override
  bool operator ==(Object other) {
    return SyncDeletionMapper.ensureInitialized().equalsValue(
      this as SyncDeletion,
      other,
    );
  }

  @override
  int get hashCode {
    return SyncDeletionMapper.ensureInitialized().hashValue(
      this as SyncDeletion,
    );
  }
}

extension SyncDeletionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SyncDeletion, $Out> {
  SyncDeletionCopyWith<$R, SyncDeletion, $Out> get $asSyncDeletion =>
      $base.as((v, t, t2) => _SyncDeletionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SyncDeletionCopyWith<$R, $In extends SyncDeletion, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? entityType,
    String? entityId,
    String? userId,
    DateTime? deletedAt,
    DateTime? createdAt,
    String? scopeType,
    String? scopeId,
  });
  SyncDeletionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SyncDeletionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyncDeletion, $Out>
    implements SyncDeletionCopyWith<$R, SyncDeletion, $Out> {
  _SyncDeletionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyncDeletion> $mapper =
      SyncDeletionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? entityType,
    String? entityId,
    String? userId,
    DateTime? deletedAt,
    DateTime? createdAt,
    Object? scopeType = $none,
    Object? scopeId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (entityType != null) #entityType: entityType,
      if (entityId != null) #entityId: entityId,
      if (userId != null) #userId: userId,
      if (deletedAt != null) #deletedAt: deletedAt,
      if (createdAt != null) #createdAt: createdAt,
      if (scopeType != $none) #scopeType: scopeType,
      if (scopeId != $none) #scopeId: scopeId,
    }),
  );
  @override
  SyncDeletion $make(CopyWithData data) => SyncDeletion(
    id: data.get(#id, or: $value.id),
    entityType: data.get(#entityType, or: $value.entityType),
    entityId: data.get(#entityId, or: $value.entityId),
    userId: data.get(#userId, or: $value.userId),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    scopeType: data.get(#scopeType, or: $value.scopeType),
    scopeId: data.get(#scopeId, or: $value.scopeId),
  );

  @override
  SyncDeletionCopyWith<$R2, SyncDeletion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SyncDeletionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
