// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'quiz_answer.dart';

class QuizAnswerMapper extends ClassMapperBase<QuizAnswer> {
  QuizAnswerMapper._();

  static QuizAnswerMapper? _instance;
  static QuizAnswerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizAnswerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuizAnswer';

  static String _$id(QuizAnswer v) => v.id;
  static const Field<QuizAnswer, String> _f$id = Field('id', _$id);
  static String _$sessionId(QuizAnswer v) => v.sessionId;
  static const Field<QuizAnswer, String> _f$sessionId =
      Field('sessionId', _$sessionId);
  static String _$cardId(QuizAnswer v) => v.cardId;
  static const Field<QuizAnswer, String> _f$cardId = Field('cardId', _$cardId);
  static String _$userAnswer(QuizAnswer v) => v.userAnswer;
  static const Field<QuizAnswer, String> _f$userAnswer =
      Field('userAnswer', _$userAnswer);
  static QuizAnswerType _$type(QuizAnswer v) => v.type;
  static const Field<QuizAnswer, QuizAnswerType> _f$type =
      Field('type', _$type);
  static DateTime _$createdAt(QuizAnswer v) => v.createdAt;
  static const Field<QuizAnswer, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);

  @override
  final MappableFields<QuizAnswer> fields = const {
    #id: _f$id,
    #sessionId: _f$sessionId,
    #cardId: _f$cardId,
    #userAnswer: _f$userAnswer,
    #type: _f$type,
    #createdAt: _f$createdAt,
  };

  static QuizAnswer _instantiate(DecodingData data) {
    return QuizAnswer(
        id: data.dec(_f$id),
        sessionId: data.dec(_f$sessionId),
        cardId: data.dec(_f$cardId),
        userAnswer: data.dec(_f$userAnswer),
        type: data.dec(_f$type),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static QuizAnswer fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizAnswer>(map);
  }

  static QuizAnswer fromJson(String json) {
    return ensureInitialized().decodeJson<QuizAnswer>(json);
  }
}

mixin QuizAnswerMappable {
  String toJson() {
    return QuizAnswerMapper.ensureInitialized()
        .encodeJson<QuizAnswer>(this as QuizAnswer);
  }

  Map<String, dynamic> toMap() {
    return QuizAnswerMapper.ensureInitialized()
        .encodeMap<QuizAnswer>(this as QuizAnswer);
  }

  QuizAnswerCopyWith<QuizAnswer, QuizAnswer, QuizAnswer> get copyWith =>
      _QuizAnswerCopyWithImpl<QuizAnswer, QuizAnswer>(
          this as QuizAnswer, $identity, $identity);
  @override
  String toString() {
    return QuizAnswerMapper.ensureInitialized()
        .stringifyValue(this as QuizAnswer);
  }

  @override
  bool operator ==(Object other) {
    return QuizAnswerMapper.ensureInitialized()
        .equalsValue(this as QuizAnswer, other);
  }

  @override
  int get hashCode {
    return QuizAnswerMapper.ensureInitialized().hashValue(this as QuizAnswer);
  }
}

extension QuizAnswerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizAnswer, $Out> {
  QuizAnswerCopyWith<$R, QuizAnswer, $Out> get $asQuizAnswer =>
      $base.as((v, t, t2) => _QuizAnswerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizAnswerCopyWith<$R, $In extends QuizAnswer, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? sessionId,
      String? cardId,
      String? userAnswer,
      QuizAnswerType? type,
      DateTime? createdAt});
  QuizAnswerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizAnswerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizAnswer, $Out>
    implements QuizAnswerCopyWith<$R, QuizAnswer, $Out> {
  _QuizAnswerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizAnswer> $mapper =
      QuizAnswerMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? sessionId,
          String? cardId,
          String? userAnswer,
          QuizAnswerType? type,
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
  QuizAnswer $make(CopyWithData data) => QuizAnswer(
      id: data.get(#id, or: $value.id),
      sessionId: data.get(#sessionId, or: $value.sessionId),
      cardId: data.get(#cardId, or: $value.cardId),
      userAnswer: data.get(#userAnswer, or: $value.userAnswer),
      type: data.get(#type, or: $value.type),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  QuizAnswerCopyWith<$R2, QuizAnswer, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _QuizAnswerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
