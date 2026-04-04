// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'quiz_answer.dart';

class DrillAnswerMapper extends ClassMapperBase<DrillAnswer> {
  DrillAnswerMapper._();

  static DrillAnswerMapper? _instance;
  static DrillAnswerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DrillAnswerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DrillAnswer';

  static String _$id(DrillAnswer v) => v.id;
  static const Field<DrillAnswer, String> _f$id = Field('id', _$id);
  static String _$sessionId(DrillAnswer v) => v.sessionId;
  static const Field<DrillAnswer, String> _f$sessionId =
      Field('sessionId', _$sessionId);
  static String _$cardId(DrillAnswer v) => v.cardId;
  static const Field<DrillAnswer, String> _f$cardId = Field('cardId', _$cardId);
  static String _$userAnswer(DrillAnswer v) => v.userAnswer;
  static const Field<DrillAnswer, String> _f$userAnswer =
      Field('userAnswer', _$userAnswer);
  static StudyRating _$type(DrillAnswer v) => v.type;
  static const Field<DrillAnswer, StudyRating> _f$type = Field('type', _$type);
  static DateTime _$createdAt(DrillAnswer v) => v.createdAt;
  static const Field<DrillAnswer, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);

  @override
  final MappableFields<DrillAnswer> fields = const {
    #id: _f$id,
    #sessionId: _f$sessionId,
    #cardId: _f$cardId,
    #userAnswer: _f$userAnswer,
    #type: _f$type,
    #createdAt: _f$createdAt,
  };

  static DrillAnswer _instantiate(DecodingData data) {
    return DrillAnswer(
        id: data.dec(_f$id),
        sessionId: data.dec(_f$sessionId),
        cardId: data.dec(_f$cardId),
        userAnswer: data.dec(_f$userAnswer),
        type: data.dec(_f$type),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static DrillAnswer fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DrillAnswer>(map);
  }

  static DrillAnswer fromJson(String json) {
    return ensureInitialized().decodeJson<DrillAnswer>(json);
  }
}

mixin DrillAnswerMappable {
  String toJson() {
    return DrillAnswerMapper.ensureInitialized()
        .encodeJson<DrillAnswer>(this as DrillAnswer);
  }

  Map<String, dynamic> toMap() {
    return DrillAnswerMapper.ensureInitialized()
        .encodeMap<DrillAnswer>(this as DrillAnswer);
  }

  DrillAnswerCopyWith<DrillAnswer, DrillAnswer, DrillAnswer> get copyWith =>
      _DrillAnswerCopyWithImpl<DrillAnswer, DrillAnswer>(
          this as DrillAnswer, $identity, $identity);
  @override
  String toString() {
    return DrillAnswerMapper.ensureInitialized()
        .stringifyValue(this as DrillAnswer);
  }

  @override
  bool operator ==(Object other) {
    return DrillAnswerMapper.ensureInitialized()
        .equalsValue(this as DrillAnswer, other);
  }

  @override
  int get hashCode {
    return DrillAnswerMapper.ensureInitialized().hashValue(this as DrillAnswer);
  }
}

extension DrillAnswerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DrillAnswer, $Out> {
  DrillAnswerCopyWith<$R, DrillAnswer, $Out> get $asDrillAnswer =>
      $base.as((v, t, t2) => _DrillAnswerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DrillAnswerCopyWith<$R, $In extends DrillAnswer, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? sessionId,
      String? cardId,
      String? userAnswer,
      StudyRating? type,
      DateTime? createdAt});
  DrillAnswerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DrillAnswerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DrillAnswer, $Out>
    implements DrillAnswerCopyWith<$R, DrillAnswer, $Out> {
  _DrillAnswerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DrillAnswer> $mapper =
      DrillAnswerMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? sessionId,
          String? cardId,
          String? userAnswer,
          StudyRating? type,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (sessionId != null) #sessionId: sessionId,
        if (cardId != null) #cardId: cardId,
        if (userAnswer != null) #userAnswer: userAnswer,
        if (type != null) #type: type,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  DrillAnswer $make(CopyWithData data) => DrillAnswer(
      id: data.get(#id, or: $value.id),
      sessionId: data.get(#sessionId, or: $value.sessionId),
      cardId: data.get(#cardId, or: $value.cardId),
      userAnswer: data.get(#userAnswer, or: $value.userAnswer),
      type: data.get(#type, or: $value.type),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  DrillAnswerCopyWith<$R2, DrillAnswer, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DrillAnswerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
