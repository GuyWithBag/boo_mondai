// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'immutable_entity.dart';

class ImmutableEntityMapper extends ClassMapperBase<ImmutableEntity> {
  ImmutableEntityMapper._();

  static ImmutableEntityMapper? _instance;
  static ImmutableEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ImmutableEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ImmutableEntity';

  static String _$id(ImmutableEntity v) => v.id;
  static const Field<ImmutableEntity, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(ImmutableEntity v) => v.createdAt;
  static const Field<ImmutableEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );

  @override
  final MappableFields<ImmutableEntity> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
  };

  static ImmutableEntity _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('ImmutableEntity');
  }

  @override
  final Function instantiate = _instantiate;

  static ImmutableEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ImmutableEntity>(map);
  }

  static ImmutableEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ImmutableEntity>(json);
  }
}

mixin ImmutableEntityMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ImmutableEntityCopyWith<ImmutableEntity, ImmutableEntity, ImmutableEntity>
  get copyWith;
}

abstract class ImmutableEntityCopyWith<$R, $In extends ImmutableEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, DateTime? createdAt});
  ImmutableEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}
