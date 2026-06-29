// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'import_export_backup.dto.dart';

class ImportExportBackupMapper extends ClassMapperBase<ImportExportBackup> {
  ImportExportBackupMapper._();

  static ImportExportBackupMapper? _instance;
  static ImportExportBackupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ImportExportBackupMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ImportExportBackup';

  static String _$id(ImportExportBackup v) => v.id;
  static const Field<ImportExportBackup, String> _f$id = Field('id', _$id);
  static String _$operation(ImportExportBackup v) => v.operation;
  static const Field<ImportExportBackup, String> _f$operation =
      Field('operation', _$operation);
  static String _$entityType(ImportExportBackup v) => v.entityType;
  static const Field<ImportExportBackup, String> _f$entityType =
      Field('entityType', _$entityType, key: r'entity_type');
  static String? _$entityId(ImportExportBackup v) => v.entityId;
  static const Field<ImportExportBackup, String> _f$entityId =
      Field('entityId', _$entityId, key: r'entity_id', opt: true);
  static String _$title(ImportExportBackup v) => v.title;
  static const Field<ImportExportBackup, String> _f$title =
      Field('title', _$title);
  static String _$payloadJson(ImportExportBackup v) => v.payloadJson;
  static const Field<ImportExportBackup, String> _f$payloadJson =
      Field('payloadJson', _$payloadJson, key: r'payload_json');
  static String _$changeLogsJson(ImportExportBackup v) => v.changeLogsJson;
  static const Field<ImportExportBackup, String> _f$changeLogsJson =
      Field('changeLogsJson', _$changeLogsJson, key: r'change_logs_json');
  static DateTime _$createdAt(ImportExportBackup v) => v.createdAt;
  static const Field<ImportExportBackup, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<ImportExportBackup> fields = const {
    #id: _f$id,
    #operation: _f$operation,
    #entityType: _f$entityType,
    #entityId: _f$entityId,
    #title: _f$title,
    #payloadJson: _f$payloadJson,
    #changeLogsJson: _f$changeLogsJson,
    #createdAt: _f$createdAt,
  };

  static ImportExportBackup _instantiate(DecodingData data) {
    return ImportExportBackup(
        id: data.dec(_f$id),
        operation: data.dec(_f$operation),
        entityType: data.dec(_f$entityType),
        entityId: data.dec(_f$entityId),
        title: data.dec(_f$title),
        payloadJson: data.dec(_f$payloadJson),
        changeLogsJson: data.dec(_f$changeLogsJson),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ImportExportBackup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ImportExportBackup>(map);
  }

  static ImportExportBackup fromJson(String json) {
    return ensureInitialized().decodeJson<ImportExportBackup>(json);
  }
}

mixin ImportExportBackupMappable {
  String toJson() {
    return ImportExportBackupMapper.ensureInitialized()
        .encodeJson<ImportExportBackup>(this as ImportExportBackup);
  }

  Map<String, dynamic> toMap() {
    return ImportExportBackupMapper.ensureInitialized()
        .encodeMap<ImportExportBackup>(this as ImportExportBackup);
  }

  ImportExportBackupCopyWith<ImportExportBackup, ImportExportBackup,
          ImportExportBackup>
      get copyWith => _ImportExportBackupCopyWithImpl<ImportExportBackup,
          ImportExportBackup>(this as ImportExportBackup, $identity, $identity);
  @override
  String toString() {
    return ImportExportBackupMapper.ensureInitialized()
        .stringifyValue(this as ImportExportBackup);
  }

  @override
  bool operator ==(Object other) {
    return ImportExportBackupMapper.ensureInitialized()
        .equalsValue(this as ImportExportBackup, other);
  }

  @override
  int get hashCode {
    return ImportExportBackupMapper.ensureInitialized()
        .hashValue(this as ImportExportBackup);
  }
}

extension ImportExportBackupValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ImportExportBackup, $Out> {
  ImportExportBackupCopyWith<$R, ImportExportBackup, $Out>
      get $asImportExportBackup => $base.as(
          (v, t, t2) => _ImportExportBackupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ImportExportBackupCopyWith<$R, $In extends ImportExportBackup,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? operation,
      String? entityType,
      String? entityId,
      String? title,
      String? payloadJson,
      String? changeLogsJson,
      DateTime? createdAt});
  ImportExportBackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ImportExportBackupCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ImportExportBackup, $Out>
    implements ImportExportBackupCopyWith<$R, ImportExportBackup, $Out> {
  _ImportExportBackupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ImportExportBackup> $mapper =
      ImportExportBackupMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? operation,
          String? entityType,
          Object? entityId = $none,
          String? title,
          String? payloadJson,
          String? changeLogsJson,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (operation != null) #operation: operation,
        if (entityType != null) #entityType: entityType,
        if (entityId != $none) #entityId: entityId,
        if (title != null) #title: title,
        if (payloadJson != null) #payloadJson: payloadJson,
        if (changeLogsJson != null) #changeLogsJson: changeLogsJson,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  ImportExportBackup $make(CopyWithData data) => ImportExportBackup(
      id: data.get(#id, or: $value.id),
      operation: data.get(#operation, or: $value.operation),
      entityType: data.get(#entityType, or: $value.entityType),
      entityId: data.get(#entityId, or: $value.entityId),
      title: data.get(#title, or: $value.title),
      payloadJson: data.get(#payloadJson, or: $value.payloadJson),
      changeLogsJson: data.get(#changeLogsJson, or: $value.changeLogsJson),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  ImportExportBackupCopyWith<$R2, ImportExportBackup, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ImportExportBackupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
