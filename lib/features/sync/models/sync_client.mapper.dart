// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sync_client.dart';

class SyncClientMapper extends ClassMapperBase<SyncClient> {
  SyncClientMapper._();

  static SyncClientMapper? _instance;
  static SyncClientMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyncClientMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SyncClient';

  static String _$id(SyncClient v) => v.id;
  static const Field<SyncClient, String> _f$id = Field('id', _$id);
  static String _$userId(SyncClient v) => v.userId;
  static const Field<SyncClient, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static DateTime _$createdAt(SyncClient v) => v.createdAt;
  static const Field<SyncClient, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$lastSeenAt(SyncClient v) => v.lastSeenAt;
  static const Field<SyncClient, DateTime> _f$lastSeenAt =
      Field('lastSeenAt', _$lastSeenAt, key: r'last_seen_at');
  static DateTime? _$lastSyncedAt(SyncClient v) => v.lastSyncedAt;
  static const Field<SyncClient, DateTime> _f$lastSyncedAt =
      Field('lastSyncedAt', _$lastSyncedAt, key: r'last_synced_at', opt: true);
  static String? _$deviceName(SyncClient v) => v.deviceName;
  static const Field<SyncClient, String> _f$deviceName =
      Field('deviceName', _$deviceName, key: r'device_name', opt: true);

  @override
  final MappableFields<SyncClient> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #createdAt: _f$createdAt,
    #lastSeenAt: _f$lastSeenAt,
    #lastSyncedAt: _f$lastSyncedAt,
    #deviceName: _f$deviceName,
  };

  static SyncClient _instantiate(DecodingData data) {
    return SyncClient(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        createdAt: data.dec(_f$createdAt),
        lastSeenAt: data.dec(_f$lastSeenAt),
        lastSyncedAt: data.dec(_f$lastSyncedAt),
        deviceName: data.dec(_f$deviceName));
  }

  @override
  final Function instantiate = _instantiate;

  static SyncClient fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyncClient>(map);
  }

  static SyncClient fromJson(String json) {
    return ensureInitialized().decodeJson<SyncClient>(json);
  }
}

mixin SyncClientMappable {
  String toJson() {
    return SyncClientMapper.ensureInitialized()
        .encodeJson<SyncClient>(this as SyncClient);
  }

  Map<String, dynamic> toMap() {
    return SyncClientMapper.ensureInitialized()
        .encodeMap<SyncClient>(this as SyncClient);
  }

  SyncClientCopyWith<SyncClient, SyncClient, SyncClient> get copyWith =>
      _SyncClientCopyWithImpl<SyncClient, SyncClient>(
          this as SyncClient, $identity, $identity);
  @override
  String toString() {
    return SyncClientMapper.ensureInitialized()
        .stringifyValue(this as SyncClient);
  }

  @override
  bool operator ==(Object other) {
    return SyncClientMapper.ensureInitialized()
        .equalsValue(this as SyncClient, other);
  }

  @override
  int get hashCode {
    return SyncClientMapper.ensureInitialized().hashValue(this as SyncClient);
  }
}

extension SyncClientValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SyncClient, $Out> {
  SyncClientCopyWith<$R, SyncClient, $Out> get $asSyncClient =>
      $base.as((v, t, t2) => _SyncClientCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SyncClientCopyWith<$R, $In extends SyncClient, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? userId,
      DateTime? createdAt,
      DateTime? lastSeenAt,
      DateTime? lastSyncedAt,
      String? deviceName});
  SyncClientCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SyncClientCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyncClient, $Out>
    implements SyncClientCopyWith<$R, SyncClient, $Out> {
  _SyncClientCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyncClient> $mapper =
      SyncClientMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userId,
          DateTime? createdAt,
          DateTime? lastSeenAt,
          Object? lastSyncedAt = $none,
          Object? deviceName = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (createdAt != null) #createdAt: createdAt,
        if (lastSeenAt != null) #lastSeenAt: lastSeenAt,
        if (lastSyncedAt != $none) #lastSyncedAt: lastSyncedAt,
        if (deviceName != $none) #deviceName: deviceName
      }));
  @override
  SyncClient $make(CopyWithData data) => SyncClient(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      lastSeenAt: data.get(#lastSeenAt, or: $value.lastSeenAt),
      lastSyncedAt: data.get(#lastSyncedAt, or: $value.lastSyncedAt),
      deviceName: data.get(#deviceName, or: $value.deviceName));

  @override
  SyncClientCopyWith<$R2, SyncClient, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SyncClientCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
