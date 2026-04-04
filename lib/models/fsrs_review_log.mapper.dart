// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fsrs_review_log.dart';

class FsrsReviewLogMapper extends ClassMapperBase<FsrsReviewLog> {
  FsrsReviewLogMapper._();

  static FsrsReviewLogMapper? _instance;
  static FsrsReviewLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FsrsReviewLogMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FsrsReviewLog';

  static String _$id(FsrsReviewLog v) => v.id;
  static const Field<FsrsReviewLog, String> _f$id = Field('id', _$id);
  static String _$cardId(FsrsReviewLog v) => v.cardId;
  static const Field<FsrsReviewLog, String> _f$cardId =
      Field('cardId', _$cardId);
  static ReviewLog _$log(FsrsReviewLog v) => v.log;
  static const Field<FsrsReviewLog, ReviewLog> _f$log = Field('log', _$log);

  @override
  final MappableFields<FsrsReviewLog> fields = const {
    #id: _f$id,
    #cardId: _f$cardId,
    #log: _f$log,
  };

  static FsrsReviewLog _instantiate(DecodingData data) {
    return FsrsReviewLog(
        id: data.dec(_f$id),
        cardId: data.dec(_f$cardId),
        log: data.dec(_f$log));
  }

  @override
  final Function instantiate = _instantiate;

  static FsrsReviewLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FsrsReviewLog>(map);
  }

  static FsrsReviewLog fromJson(String json) {
    return ensureInitialized().decodeJson<FsrsReviewLog>(json);
  }
}

mixin FsrsReviewLogMappable {
  String toJson() {
    return FsrsReviewLogMapper.ensureInitialized()
        .encodeJson<FsrsReviewLog>(this as FsrsReviewLog);
  }

  Map<String, dynamic> toMap() {
    return FsrsReviewLogMapper.ensureInitialized()
        .encodeMap<FsrsReviewLog>(this as FsrsReviewLog);
  }

  FsrsReviewLogCopyWith<FsrsReviewLog, FsrsReviewLog, FsrsReviewLog>
      get copyWith => _FsrsReviewLogCopyWithImpl<FsrsReviewLog, FsrsReviewLog>(
          this as FsrsReviewLog, $identity, $identity);
  @override
  String toString() {
    return FsrsReviewLogMapper.ensureInitialized()
        .stringifyValue(this as FsrsReviewLog);
  }

  @override
  bool operator ==(Object other) {
    return FsrsReviewLogMapper.ensureInitialized()
        .equalsValue(this as FsrsReviewLog, other);
  }

  @override
  int get hashCode {
    return FsrsReviewLogMapper.ensureInitialized()
        .hashValue(this as FsrsReviewLog);
  }
}

extension FsrsReviewLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FsrsReviewLog, $Out> {
  FsrsReviewLogCopyWith<$R, FsrsReviewLog, $Out> get $asFsrsReviewLog =>
      $base.as((v, t, t2) => _FsrsReviewLogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FsrsReviewLogCopyWith<$R, $In extends FsrsReviewLog, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? cardId, ReviewLog? log});
  FsrsReviewLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FsrsReviewLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FsrsReviewLog, $Out>
    implements FsrsReviewLogCopyWith<$R, FsrsReviewLog, $Out> {
  _FsrsReviewLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FsrsReviewLog> $mapper =
      FsrsReviewLogMapper.ensureInitialized();
  @override
  $R call({String? id, String? cardId, ReviewLog? log}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (cardId != null) #cardId: cardId,
        if (log != null) #log: log
      }));
  @override
  FsrsReviewLog $make(CopyWithData data) => FsrsReviewLog(
      id: data.get(#id, or: $value.id),
      cardId: data.get(#cardId, or: $value.cardId),
      log: data.get(#log, or: $value.log));

  @override
  FsrsReviewLogCopyWith<$R2, FsrsReviewLog, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FsrsReviewLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
