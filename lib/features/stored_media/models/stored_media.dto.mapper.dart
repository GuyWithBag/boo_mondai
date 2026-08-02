// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'stored_media.dto.dart';

class StoredMediaMapper extends ClassMapperBase<StoredMedia> {
  StoredMediaMapper._();

  static StoredMediaMapper? _instance;
  static StoredMediaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StoredMediaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'StoredMedia';

  static String _$id(StoredMedia v) => v.id;
  static const Field<StoredMedia, String> _f$id = Field('id', _$id);
  static String _$localPath(StoredMedia v) => v.localPath;
  static const Field<StoredMedia, String> _f$localPath =
      Field('localPath', _$localPath, key: r'local_path');
  static String? _$remoteUrl(StoredMedia v) => v.remoteUrl;
  static const Field<StoredMedia, String> _f$remoteUrl =
      Field('remoteUrl', _$remoteUrl, key: r'remote_url', opt: true);
  static String? _$mimeType(StoredMedia v) => v.mimeType;
  static const Field<StoredMedia, String> _f$mimeType =
      Field('mimeType', _$mimeType, key: r'mime_type', opt: true);
  static int? _$byteSize(StoredMedia v) => v.byteSize;
  static const Field<StoredMedia, int> _f$byteSize =
      Field('byteSize', _$byteSize, key: r'byte_size', opt: true);
  static DateTime _$createdAt(StoredMedia v) => v.createdAt;
  static const Field<StoredMedia, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(StoredMedia v) => v.updatedAt;
  static const Field<StoredMedia, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');

  @override
  final MappableFields<StoredMedia> fields = const {
    #id: _f$id,
    #localPath: _f$localPath,
    #remoteUrl: _f$remoteUrl,
    #mimeType: _f$mimeType,
    #byteSize: _f$byteSize,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static StoredMedia _instantiate(DecodingData data) {
    return StoredMedia(
        id: data.dec(_f$id),
        localPath: data.dec(_f$localPath),
        remoteUrl: data.dec(_f$remoteUrl),
        mimeType: data.dec(_f$mimeType),
        byteSize: data.dec(_f$byteSize),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static StoredMedia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StoredMedia>(map);
  }

  static StoredMedia fromJson(String json) {
    return ensureInitialized().decodeJson<StoredMedia>(json);
  }
}

mixin StoredMediaMappable {
  String toJson() {
    return StoredMediaMapper.ensureInitialized()
        .encodeJson<StoredMedia>(this as StoredMedia);
  }

  Map<String, dynamic> toMap() {
    return StoredMediaMapper.ensureInitialized()
        .encodeMap<StoredMedia>(this as StoredMedia);
  }

  StoredMediaCopyWith<StoredMedia, StoredMedia, StoredMedia> get copyWith =>
      _StoredMediaCopyWithImpl<StoredMedia, StoredMedia>(
          this as StoredMedia, $identity, $identity);
  @override
  String toString() {
    return StoredMediaMapper.ensureInitialized()
        .stringifyValue(this as StoredMedia);
  }

  @override
  bool operator ==(Object other) {
    return StoredMediaMapper.ensureInitialized()
        .equalsValue(this as StoredMedia, other);
  }

  @override
  int get hashCode {
    return StoredMediaMapper.ensureInitialized().hashValue(this as StoredMedia);
  }
}

extension StoredMediaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StoredMedia, $Out> {
  StoredMediaCopyWith<$R, StoredMedia, $Out> get $asStoredMedia =>
      $base.as((v, t, t2) => _StoredMediaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StoredMediaCopyWith<$R, $In extends StoredMedia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? localPath,
      String? remoteUrl,
      String? mimeType,
      int? byteSize,
      DateTime? createdAt,
      DateTime? updatedAt});
  StoredMediaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StoredMediaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StoredMedia, $Out>
    implements StoredMediaCopyWith<$R, StoredMedia, $Out> {
  _StoredMediaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StoredMedia> $mapper =
      StoredMediaMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? localPath,
          Object? remoteUrl = $none,
          Object? mimeType = $none,
          Object? byteSize = $none,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (localPath != null) #localPath: localPath,
        if (remoteUrl != $none) #remoteUrl: remoteUrl,
        if (mimeType != $none) #mimeType: mimeType,
        if (byteSize != $none) #byteSize: byteSize,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  StoredMedia $make(CopyWithData data) => StoredMedia(
      id: data.get(#id, or: $value.id),
      localPath: data.get(#localPath, or: $value.localPath),
      remoteUrl: data.get(#remoteUrl, or: $value.remoteUrl),
      mimeType: data.get(#mimeType, or: $value.mimeType),
      byteSize: data.get(#byteSize, or: $value.byteSize),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  StoredMediaCopyWith<$R2, StoredMedia, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _StoredMediaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
