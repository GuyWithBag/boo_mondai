// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'quiz_session.dart';

class DrillSessionMapper extends ClassMapperBase<DrillSession> {
  DrillSessionMapper._();

  static DrillSessionMapper? _instance;
  static DrillSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DrillSessionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DrillSession';

  static String _$id(DrillSession v) => v.id;
  static const Field<DrillSession, String> _f$id = Field('id', _$id);
  static String _$userId(DrillSession v) => v.userId;
  static const Field<DrillSession, String> _f$userId =
      Field('userId', _$userId);
  static String _$deckId(DrillSession v) => v.deckId;
  static const Field<DrillSession, String> _f$deckId =
      Field('deckId', _$deckId);
  static bool _$previewed(DrillSession v) => v.previewed;
  static const Field<DrillSession, bool> _f$previewed =
      Field('previewed', _$previewed);
  static int _$totalQuestions(DrillSession v) => v.totalQuestions;
  static const Field<DrillSession, int> _f$totalQuestions =
      Field('totalQuestions', _$totalQuestions);
  static int _$correctCount(DrillSession v) => v.correctCount;
  static const Field<DrillSession, int> _f$correctCount =
      Field('correctCount', _$correctCount);
  static DateTime _$startedAt(DrillSession v) => v.startedAt;
  static const Field<DrillSession, DateTime> _f$startedAt =
      Field('startedAt', _$startedAt);
  static DateTime? _$completedAt(DrillSession v) => v.completedAt;
  static const Field<DrillSession, DateTime> _f$completedAt =
      Field('completedAt', _$completedAt, opt: true);

  @override
  final MappableFields<DrillSession> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #deckId: _f$deckId,
    #previewed: _f$previewed,
    #totalQuestions: _f$totalQuestions,
    #correctCount: _f$correctCount,
    #startedAt: _f$startedAt,
    #completedAt: _f$completedAt,
  };

  static DrillSession _instantiate(DecodingData data) {
    return DrillSession(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        deckId: data.dec(_f$deckId),
        previewed: data.dec(_f$previewed),
        totalQuestions: data.dec(_f$totalQuestions),
        correctCount: data.dec(_f$correctCount),
        startedAt: data.dec(_f$startedAt),
        completedAt: data.dec(_f$completedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static DrillSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DrillSession>(map);
  }

  static DrillSession fromJson(String json) {
    return ensureInitialized().decodeJson<DrillSession>(json);
  }
}

mixin DrillSessionMappable {
  String toJson() {
    return DrillSessionMapper.ensureInitialized()
        .encodeJson<DrillSession>(this as DrillSession);
  }

  Map<String, dynamic> toMap() {
    return DrillSessionMapper.ensureInitialized()
        .encodeMap<DrillSession>(this as DrillSession);
  }

  DrillSessionCopyWith<DrillSession, DrillSession, DrillSession> get copyWith =>
      _DrillSessionCopyWithImpl<DrillSession, DrillSession>(
          this as DrillSession, $identity, $identity);
  @override
  String toString() {
    return DrillSessionMapper.ensureInitialized()
        .stringifyValue(this as DrillSession);
  }

  @override
  bool operator ==(Object other) {
    return DrillSessionMapper.ensureInitialized()
        .equalsValue(this as DrillSession, other);
  }

  @override
  int get hashCode {
    return DrillSessionMapper.ensureInitialized()
        .hashValue(this as DrillSession);
  }
}

extension DrillSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DrillSession, $Out> {
  DrillSessionCopyWith<$R, DrillSession, $Out> get $asDrillSession =>
      $base.as((v, t, t2) => _DrillSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DrillSessionCopyWith<$R, $In extends DrillSession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? userId,
      String? deckId,
      bool? previewed,
      int? totalQuestions,
      int? correctCount,
      DateTime? startedAt,
      DateTime? completedAt});
  DrillSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DrillSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DrillSession, $Out>
    implements DrillSessionCopyWith<$R, DrillSession, $Out> {
  _DrillSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DrillSession> $mapper =
      DrillSessionMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userId,
          String? deckId,
          bool? previewed,
          int? totalQuestions,
          int? correctCount,
          DateTime? startedAt,
          Object? completedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (deckId != null) #deckId: deckId,
        if (previewed != null) #previewed: previewed,
        if (totalQuestions != null) #totalQuestions: totalQuestions,
        if (correctCount != null) #correctCount: correctCount,
        if (startedAt != null) #startedAt: startedAt,
        if (completedAt != $none) #completedAt: completedAt
      }));
  @override
  DrillSession $make(CopyWithData data) => DrillSession(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      deckId: data.get(#deckId, or: $value.deckId),
      previewed: data.get(#previewed, or: $value.previewed),
      totalQuestions: data.get(#totalQuestions, or: $value.totalQuestions),
      correctCount: data.get(#correctCount, or: $value.correctCount),
      startedAt: data.get(#startedAt, or: $value.startedAt),
      completedAt: data.get(#completedAt, or: $value.completedAt));

  @override
  DrillSessionCopyWith<$R2, DrillSession, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DrillSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
