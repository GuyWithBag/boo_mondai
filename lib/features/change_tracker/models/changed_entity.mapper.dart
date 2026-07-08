// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'changed_entity.dart';

class ChangedEntityMapper extends ClassMapperBase<ChangedEntity> {
  ChangedEntityMapper._();

  static ChangedEntityMapper? _instance;
  static ChangedEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChangedEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChangedEntity';
  @override
  Function get typeFactory => <T>(f) => f<ChangedEntity<T>>();

  static ChangeSource _$source(ChangedEntity v) => v.source;
  static const Field<ChangedEntity, ChangeSource> _f$source =
      Field('source', _$source);
  static ChangeType _$changeType(ChangedEntity v) => v.changeType;
  static const Field<ChangedEntity, ChangeType> _f$changeType =
      Field('changeType', _$changeType, key: r'change_type');
  static String _$id(ChangedEntity v) => v.id;
  static const Field<ChangedEntity, String> _f$id = Field('id', _$id);
  static dynamic _$beforeChange(ChangedEntity v) => v.beforeChange;
  static dynamic _arg$beforeChange<T>(f) => f<T>();
  static const Field<ChangedEntity, dynamic> _f$beforeChange = Field(
      'beforeChange', _$beforeChange,
      key: r'before_change', opt: true, arg: _arg$beforeChange);
  static dynamic _$afterChange(ChangedEntity v) => v.afterChange;
  static dynamic _arg$afterChange<T>(f) => f<T>();
  static const Field<ChangedEntity, dynamic> _f$afterChange = Field(
      'afterChange', _$afterChange,
      key: r'after_change', arg: _arg$afterChange);
  static List<ChangedProperty<Object?>> _$changedProperties(ChangedEntity v) =>
      v.changedProperties;
  static const Field<ChangedEntity, List<ChangedProperty<Object?>>>
      _f$changedProperties = Field('changedProperties', _$changedProperties,
          key: r'changed_properties', opt: true, def: const []);
  static String? _$localId(ChangedEntity v) => v.localId;
  static const Field<ChangedEntity, String> _f$localId =
      Field('localId', _$localId, key: r'local_id', opt: true);
  static String? _$remoteId(ChangedEntity v) => v.remoteId;
  static const Field<ChangedEntity, String> _f$remoteId =
      Field('remoteId', _$remoteId, key: r'remote_id', opt: true);
  static DateTime? _$localUpdatedAt(ChangedEntity v) => v.localUpdatedAt;
  static const Field<ChangedEntity, DateTime> _f$localUpdatedAt = Field(
      'localUpdatedAt', _$localUpdatedAt,
      key: r'local_updated_at', opt: true);
  static DateTime? _$remoteUpdatedAt(ChangedEntity v) => v.remoteUpdatedAt;
  static const Field<ChangedEntity, DateTime> _f$remoteUpdatedAt = Field(
      'remoteUpdatedAt', _$remoteUpdatedAt,
      key: r'remote_updated_at', opt: true);

  @override
  final MappableFields<ChangedEntity> fields = const {
    #source: _f$source,
    #changeType: _f$changeType,
    #id: _f$id,
    #beforeChange: _f$beforeChange,
    #afterChange: _f$afterChange,
    #changedProperties: _f$changedProperties,
    #localId: _f$localId,
    #remoteId: _f$remoteId,
    #localUpdatedAt: _f$localUpdatedAt,
    #remoteUpdatedAt: _f$remoteUpdatedAt,
  };

  static ChangedEntity<T> _instantiate<T>(DecodingData data) {
    return ChangedEntity(
        source: data.dec(_f$source),
        changeType: data.dec(_f$changeType),
        id: data.dec(_f$id),
        beforeChange: data.dec(_f$beforeChange),
        afterChange: data.dec(_f$afterChange),
        changedProperties: data.dec(_f$changedProperties),
        localId: data.dec(_f$localId),
        remoteId: data.dec(_f$remoteId),
        localUpdatedAt: data.dec(_f$localUpdatedAt),
        remoteUpdatedAt: data.dec(_f$remoteUpdatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ChangedEntity<T> fromMap<T>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChangedEntity<T>>(map);
  }

  static ChangedEntity<T> fromJson<T>(String json) {
    return ensureInitialized().decodeJson<ChangedEntity<T>>(json);
  }
}

mixin ChangedEntityMappable<T> {
  String toJson() {
    return ChangedEntityMapper.ensureInitialized()
        .encodeJson<ChangedEntity<T>>(this as ChangedEntity<T>);
  }

  Map<String, dynamic> toMap() {
    return ChangedEntityMapper.ensureInitialized()
        .encodeMap<ChangedEntity<T>>(this as ChangedEntity<T>);
  }

  ChangedEntityCopyWith<ChangedEntity<T>, ChangedEntity<T>, ChangedEntity<T>, T>
      get copyWith =>
          _ChangedEntityCopyWithImpl<ChangedEntity<T>, ChangedEntity<T>, T>(
              this as ChangedEntity<T>, $identity, $identity);
  @override
  String toString() {
    return ChangedEntityMapper.ensureInitialized()
        .stringifyValue(this as ChangedEntity<T>);
  }

  @override
  bool operator ==(Object other) {
    return ChangedEntityMapper.ensureInitialized()
        .equalsValue(this as ChangedEntity<T>, other);
  }

  @override
  int get hashCode {
    return ChangedEntityMapper.ensureInitialized()
        .hashValue(this as ChangedEntity<T>);
  }
}

extension ChangedEntityValueCopy<$R, $Out, T>
    on ObjectCopyWith<$R, ChangedEntity<T>, $Out> {
  ChangedEntityCopyWith<$R, ChangedEntity<T>, $Out, T> get $asChangedEntity =>
      $base.as((v, t, t2) => _ChangedEntityCopyWithImpl<$R, $Out, T>(v, t, t2));
}

abstract class ChangedEntityCopyWith<$R, $In extends ChangedEntity<T>, $Out, T>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      ChangedProperty<Object?>,
      ObjectCopyWith<$R, ChangedProperty<Object?>,
          ChangedProperty<Object?>>> get changedProperties;
  $R call(
      {ChangeSource? source,
      ChangeType? changeType,
      String? id,
      T? beforeChange,
      T? afterChange,
      List<ChangedProperty<Object?>>? changedProperties,
      String? localId,
      String? remoteId,
      DateTime? localUpdatedAt,
      DateTime? remoteUpdatedAt});
  ChangedEntityCopyWith<$R2, $In, $Out2, T> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ChangedEntityCopyWithImpl<$R, $Out, T>
    extends ClassCopyWithBase<$R, ChangedEntity<T>, $Out>
    implements ChangedEntityCopyWith<$R, ChangedEntity<T>, $Out, T> {
  _ChangedEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChangedEntity> $mapper =
      ChangedEntityMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      ChangedProperty<Object?>,
      ObjectCopyWith<$R, ChangedProperty<Object?>,
          ChangedProperty<Object?>>> get changedProperties => ListCopyWith(
      $value.changedProperties,
      (v, t) => ObjectCopyWith(v, $identity, t),
      (v) => call(changedProperties: v));
  @override
  $R call(
          {ChangeSource? source,
          ChangeType? changeType,
          String? id,
          Object? beforeChange = $none,
          Object? afterChange = $none,
          List<ChangedProperty<Object?>>? changedProperties,
          Object? localId = $none,
          Object? remoteId = $none,
          Object? localUpdatedAt = $none,
          Object? remoteUpdatedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (source != null) #source: source,
        if (changeType != null) #changeType: changeType,
        if (id != null) #id: id,
        if (beforeChange != $none) #beforeChange: beforeChange,
        if (afterChange != $none) #afterChange: afterChange,
        if (changedProperties != null) #changedProperties: changedProperties,
        if (localId != $none) #localId: localId,
        if (remoteId != $none) #remoteId: remoteId,
        if (localUpdatedAt != $none) #localUpdatedAt: localUpdatedAt,
        if (remoteUpdatedAt != $none) #remoteUpdatedAt: remoteUpdatedAt
      }));
  @override
  ChangedEntity<T> $make(CopyWithData data) => ChangedEntity(
      source: data.get(#source, or: $value.source),
      changeType: data.get(#changeType, or: $value.changeType),
      id: data.get(#id, or: $value.id),
      beforeChange: data.get(#beforeChange, or: $value.beforeChange),
      afterChange: data.get(#afterChange, or: $value.afterChange),
      changedProperties:
          data.get(#changedProperties, or: $value.changedProperties),
      localId: data.get(#localId, or: $value.localId),
      remoteId: data.get(#remoteId, or: $value.remoteId),
      localUpdatedAt: data.get(#localUpdatedAt, or: $value.localUpdatedAt),
      remoteUpdatedAt: data.get(#remoteUpdatedAt, or: $value.remoteUpdatedAt));

  @override
  ChangedEntityCopyWith<$R2, ChangedEntity<T>, $Out2, T> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ChangedEntityCopyWithImpl<$R2, $Out2, T>($value, $cast, t);
}
