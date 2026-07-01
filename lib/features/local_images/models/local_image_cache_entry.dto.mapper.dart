// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'local_image_cache_entry.dto.dart';

class LocalImageCacheEntryMapper extends ClassMapperBase<LocalImageCacheEntry> {
  LocalImageCacheEntryMapper._();

  static LocalImageCacheEntryMapper? _instance;
  static LocalImageCacheEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LocalImageCacheEntryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LocalImageCacheEntry';

  static String _$cacheKey(LocalImageCacheEntry v) => v.cacheKey;
  static const Field<LocalImageCacheEntry, String> _f$cacheKey = Field(
    'cacheKey',
    _$cacheKey,
    key: r'cache_key',
  );
  static String _$localPath(LocalImageCacheEntry v) => v.localPath;
  static const Field<LocalImageCacheEntry, String> _f$localPath = Field(
    'localPath',
    _$localPath,
    key: r'local_path',
  );
  static String? _$remotePath(LocalImageCacheEntry v) => v.remotePath;
  static const Field<LocalImageCacheEntry, String> _f$remotePath = Field(
    'remotePath',
    _$remotePath,
    key: r'remote_path',
    opt: true,
  );
  static String? _$mimeType(LocalImageCacheEntry v) => v.mimeType;
  static const Field<LocalImageCacheEntry, String> _f$mimeType = Field(
    'mimeType',
    _$mimeType,
    key: r'mime_type',
    opt: true,
  );
  static int? _$byteSize(LocalImageCacheEntry v) => v.byteSize;
  static const Field<LocalImageCacheEntry, int> _f$byteSize = Field(
    'byteSize',
    _$byteSize,
    key: r'byte_size',
    opt: true,
  );
  static DateTime _$createdAt(LocalImageCacheEntry v) => v.createdAt;
  static const Field<LocalImageCacheEntry, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(LocalImageCacheEntry v) => v.updatedAt;
  static const Field<LocalImageCacheEntry, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<LocalImageCacheEntry> fields = const {
    #cacheKey: _f$cacheKey,
    #localPath: _f$localPath,
    #remotePath: _f$remotePath,
    #mimeType: _f$mimeType,
    #byteSize: _f$byteSize,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static LocalImageCacheEntry _instantiate(DecodingData data) {
    return LocalImageCacheEntry(
      cacheKey: data.dec(_f$cacheKey),
      localPath: data.dec(_f$localPath),
      remotePath: data.dec(_f$remotePath),
      mimeType: data.dec(_f$mimeType),
      byteSize: data.dec(_f$byteSize),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LocalImageCacheEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LocalImageCacheEntry>(map);
  }

  static LocalImageCacheEntry fromJson(String json) {
    return ensureInitialized().decodeJson<LocalImageCacheEntry>(json);
  }
}

mixin LocalImageCacheEntryMappable {
  String toJson() {
    return LocalImageCacheEntryMapper.ensureInitialized()
        .encodeJson<LocalImageCacheEntry>(this as LocalImageCacheEntry);
  }

  Map<String, dynamic> toMap() {
    return LocalImageCacheEntryMapper.ensureInitialized()
        .encodeMap<LocalImageCacheEntry>(this as LocalImageCacheEntry);
  }

  LocalImageCacheEntryCopyWith<
    LocalImageCacheEntry,
    LocalImageCacheEntry,
    LocalImageCacheEntry
  >
  get copyWith =>
      _LocalImageCacheEntryCopyWithImpl<
        LocalImageCacheEntry,
        LocalImageCacheEntry
      >(this as LocalImageCacheEntry, $identity, $identity);
  @override
  String toString() {
    return LocalImageCacheEntryMapper.ensureInitialized().stringifyValue(
      this as LocalImageCacheEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    return LocalImageCacheEntryMapper.ensureInitialized().equalsValue(
      this as LocalImageCacheEntry,
      other,
    );
  }

  @override
  int get hashCode {
    return LocalImageCacheEntryMapper.ensureInitialized().hashValue(
      this as LocalImageCacheEntry,
    );
  }
}

extension LocalImageCacheEntryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LocalImageCacheEntry, $Out> {
  LocalImageCacheEntryCopyWith<$R, LocalImageCacheEntry, $Out>
  get $asLocalImageCacheEntry => $base.as(
    (v, t, t2) => _LocalImageCacheEntryCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LocalImageCacheEntryCopyWith<
  $R,
  $In extends LocalImageCacheEntry,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? cacheKey,
    String? localPath,
    String? remotePath,
    String? mimeType,
    int? byteSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  LocalImageCacheEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LocalImageCacheEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LocalImageCacheEntry, $Out>
    implements LocalImageCacheEntryCopyWith<$R, LocalImageCacheEntry, $Out> {
  _LocalImageCacheEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LocalImageCacheEntry> $mapper =
      LocalImageCacheEntryMapper.ensureInitialized();
  @override
  $R call({
    String? cacheKey,
    String? localPath,
    Object? remotePath = $none,
    Object? mimeType = $none,
    Object? byteSize = $none,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (cacheKey != null) #cacheKey: cacheKey,
      if (localPath != null) #localPath: localPath,
      if (remotePath != $none) #remotePath: remotePath,
      if (mimeType != $none) #mimeType: mimeType,
      if (byteSize != $none) #byteSize: byteSize,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  LocalImageCacheEntry $make(CopyWithData data) => LocalImageCacheEntry(
    cacheKey: data.get(#cacheKey, or: $value.cacheKey),
    localPath: data.get(#localPath, or: $value.localPath),
    remotePath: data.get(#remotePath, or: $value.remotePath),
    mimeType: data.get(#mimeType, or: $value.mimeType),
    byteSize: data.get(#byteSize, or: $value.byteSize),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  LocalImageCacheEntryCopyWith<$R2, LocalImageCacheEntry, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LocalImageCacheEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
