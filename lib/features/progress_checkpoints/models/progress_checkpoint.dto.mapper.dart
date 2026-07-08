// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'progress_checkpoint.dto.dart';

class ProgressCheckpointMapper extends ClassMapperBase<ProgressCheckpoint> {
  ProgressCheckpointMapper._();

  static ProgressCheckpointMapper? _instance;
  static ProgressCheckpointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProgressCheckpointMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProgressCheckpoint';

  static String _$id(ProgressCheckpoint v) => v.id;
  static const Field<ProgressCheckpoint, String> _f$id = Field('id', _$id);
  static ProgressCheckpointType _$type(ProgressCheckpoint v) => v.type;
  static const Field<ProgressCheckpoint, ProgressCheckpointType> _f$type =
      Field('type', _$type);
  static String _$targetId(ProgressCheckpoint v) => v.targetId;
  static const Field<ProgressCheckpoint, String> _f$targetId =
      Field('targetId', _$targetId, key: r'target_id');
  static String _$operationDescription(ProgressCheckpoint v) =>
      v.operationDescription;
  static const Field<ProgressCheckpoint, String> _f$operationDescription =
      Field('operationDescription', _$operationDescription,
          key: r'operation_description');
  static int _$totalItems(ProgressCheckpoint v) => v.totalItems;
  static const Field<ProgressCheckpoint, int> _f$totalItems =
      Field('totalItems', _$totalItems, key: r'total_items');
  static List<String> _$completedTargetItemIds(ProgressCheckpoint v) =>
      v.completedTargetItemIds;
  static const Field<ProgressCheckpoint, List<String>>
      _f$completedTargetItemIds = Field(
          'completedTargetItemIds', _$completedTargetItemIds,
          key: r'completed_target_item_ids');
  static ProgressCheckpointStatus _$status(ProgressCheckpoint v) => v.status;
  static const Field<ProgressCheckpoint, ProgressCheckpointStatus> _f$status =
      Field('status', _$status);
  static DateTime _$createdAt(ProgressCheckpoint v) => v.createdAt;
  static const Field<ProgressCheckpoint, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(ProgressCheckpoint v) => v.updatedAt;
  static const Field<ProgressCheckpoint, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');

  @override
  final MappableFields<ProgressCheckpoint> fields = const {
    #id: _f$id,
    #type: _f$type,
    #targetId: _f$targetId,
    #operationDescription: _f$operationDescription,
    #totalItems: _f$totalItems,
    #completedTargetItemIds: _f$completedTargetItemIds,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static ProgressCheckpoint _instantiate(DecodingData data) {
    return ProgressCheckpoint(
        id: data.dec(_f$id),
        type: data.dec(_f$type),
        targetId: data.dec(_f$targetId),
        operationDescription: data.dec(_f$operationDescription),
        totalItems: data.dec(_f$totalItems),
        completedTargetItemIds: data.dec(_f$completedTargetItemIds),
        status: data.dec(_f$status),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ProgressCheckpoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProgressCheckpoint>(map);
  }

  static ProgressCheckpoint fromJson(String json) {
    return ensureInitialized().decodeJson<ProgressCheckpoint>(json);
  }
}

mixin ProgressCheckpointMappable {
  String toJson() {
    return ProgressCheckpointMapper.ensureInitialized()
        .encodeJson<ProgressCheckpoint>(this as ProgressCheckpoint);
  }

  Map<String, dynamic> toMap() {
    return ProgressCheckpointMapper.ensureInitialized()
        .encodeMap<ProgressCheckpoint>(this as ProgressCheckpoint);
  }

  ProgressCheckpointCopyWith<ProgressCheckpoint, ProgressCheckpoint,
          ProgressCheckpoint>
      get copyWith => _ProgressCheckpointCopyWithImpl<ProgressCheckpoint,
          ProgressCheckpoint>(this as ProgressCheckpoint, $identity, $identity);
  @override
  String toString() {
    return ProgressCheckpointMapper.ensureInitialized()
        .stringifyValue(this as ProgressCheckpoint);
  }

  @override
  bool operator ==(Object other) {
    return ProgressCheckpointMapper.ensureInitialized()
        .equalsValue(this as ProgressCheckpoint, other);
  }

  @override
  int get hashCode {
    return ProgressCheckpointMapper.ensureInitialized()
        .hashValue(this as ProgressCheckpoint);
  }
}

extension ProgressCheckpointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProgressCheckpoint, $Out> {
  ProgressCheckpointCopyWith<$R, ProgressCheckpoint, $Out>
      get $asProgressCheckpoint => $base.as(
          (v, t, t2) => _ProgressCheckpointCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProgressCheckpointCopyWith<$R, $In extends ProgressCheckpoint,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get completedTargetItemIds;
  $R call(
      {String? id,
      ProgressCheckpointType? type,
      String? targetId,
      String? operationDescription,
      int? totalItems,
      List<String>? completedTargetItemIds,
      ProgressCheckpointStatus? status,
      DateTime? createdAt,
      DateTime? updatedAt});
  ProgressCheckpointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ProgressCheckpointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProgressCheckpoint, $Out>
    implements ProgressCheckpointCopyWith<$R, ProgressCheckpoint, $Out> {
  _ProgressCheckpointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProgressCheckpoint> $mapper =
      ProgressCheckpointMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get completedTargetItemIds => ListCopyWith(
          $value.completedTargetItemIds,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(completedTargetItemIds: v));
  @override
  $R call(
          {String? id,
          ProgressCheckpointType? type,
          String? targetId,
          String? operationDescription,
          int? totalItems,
          List<String>? completedTargetItemIds,
          ProgressCheckpointStatus? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (type != null) #type: type,
        if (targetId != null) #targetId: targetId,
        if (operationDescription != null)
          #operationDescription: operationDescription,
        if (totalItems != null) #totalItems: totalItems,
        if (completedTargetItemIds != null)
          #completedTargetItemIds: completedTargetItemIds,
        if (status != null) #status: status,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  ProgressCheckpoint $make(CopyWithData data) => ProgressCheckpoint(
      id: data.get(#id, or: $value.id),
      type: data.get(#type, or: $value.type),
      targetId: data.get(#targetId, or: $value.targetId),
      operationDescription:
          data.get(#operationDescription, or: $value.operationDescription),
      totalItems: data.get(#totalItems, or: $value.totalItems),
      completedTargetItemIds:
          data.get(#completedTargetItemIds, or: $value.completedTargetItemIds),
      status: data.get(#status, or: $value.status),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  ProgressCheckpointCopyWith<$R2, ProgressCheckpoint, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ProgressCheckpointCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
