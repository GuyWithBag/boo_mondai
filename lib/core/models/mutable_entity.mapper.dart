// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mutable_entity.dart';

class MutableEntityMapper extends ClassMapperBase<MutableEntity> {
  MutableEntityMapper._();

  static MutableEntityMapper? _instance;
  static MutableEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MutableEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MutableEntity';

  static String _$id(MutableEntity v) => v.id;
  static const Field<MutableEntity, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(MutableEntity v) => v.createdAt;
  static const Field<MutableEntity, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(MutableEntity v) => v.updatedAt;
  static const Field<MutableEntity, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');

  @override
  final MappableFields<MutableEntity> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static MutableEntity _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('MutableEntity');
  }

  @override
  final Function instantiate = _instantiate;

  static MutableEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MutableEntity>(map);
  }

  static MutableEntity fromJson(String json) {
    return ensureInitialized().decodeJson<MutableEntity>(json);
  }
}

mixin MutableEntityMappable {
  String toJson();
  Map<String, dynamic> toMap();
  MutableEntityCopyWith<MutableEntity, MutableEntity, MutableEntity>
      get copyWith;
}

abstract class MutableEntityCopyWith<$R, $In extends MutableEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, DateTime? createdAt, DateTime? updatedAt});
  MutableEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}
