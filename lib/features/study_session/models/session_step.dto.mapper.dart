// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'session_step.dto.dart';

class SessionStepMapper extends ClassMapperBase<SessionStep> {
  SessionStepMapper._();

  static SessionStepMapper? _instance;
  static SessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SessionStepMapper._());
      CardSessionStepMapper.ensureInitialized();
      MessageSessionStepMapper.ensureInitialized();
      SummarySessionStepMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SessionStep';

  static String _$id(SessionStep v) => v.id;
  static const Field<SessionStep, String> _f$id = Field('id', _$id);
  static String? _$insertedByRuleId(SessionStep v) => v.insertedByRuleId;
  static const Field<SessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(SessionStep v) => v.insertionReason;
  static const Field<SessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<SessionStep> fields = const {
    #id: _f$id,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  static SessionStep _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
        'SessionStep', 'step_type', '${data.value['step_type']}');
  }

  @override
  final Function instantiate = _instantiate;

  static SessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SessionStep>(map);
  }

  static SessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<SessionStep>(json);
  }
}

mixin SessionStepMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SessionStepCopyWith<SessionStep, SessionStep, SessionStep> get copyWith;
}

abstract class SessionStepCopyWith<$R, $In extends SessionStep, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? insertedByRuleId, String? insertionReason});
  SessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class CardSessionStepMapper extends SubClassMapperBase<CardSessionStep> {
  CardSessionStepMapper._();

  static CardSessionStepMapper? _instance;
  static CardSessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardSessionStepMapper._());
      SessionStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'CardSessionStep';

  static String _$id(CardSessionStep v) => v.id;
  static const Field<CardSessionStep, String> _f$id = Field('id', _$id);
  static String _$studyCardId(CardSessionStep v) => v.studyCardId;
  static const Field<CardSessionStep, String> _f$studyCardId =
      Field('studyCardId', _$studyCardId, key: r'study_card_id');
  static int _$attemptNumber(CardSessionStep v) => v.attemptNumber;
  static const Field<CardSessionStep, int> _f$attemptNumber = Field(
      'attemptNumber', _$attemptNumber,
      key: r'attempt_number', opt: true, def: 1);
  static String? _$insertedByRuleId(CardSessionStep v) => v.insertedByRuleId;
  static const Field<CardSessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(CardSessionStep v) => v.insertionReason;
  static const Field<CardSessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<CardSessionStep> fields = const {
    #id: _f$id,
    #studyCardId: _f$studyCardId,
    #attemptNumber: _f$attemptNumber,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  @override
  final String discriminatorKey = 'step_type';
  @override
  final dynamic discriminatorValue = 'card';
  @override
  late final ClassMapperBase superMapper =
      SessionStepMapper.ensureInitialized();

  static CardSessionStep _instantiate(DecodingData data) {
    return CardSessionStep(
        id: data.dec(_f$id),
        studyCardId: data.dec(_f$studyCardId),
        attemptNumber: data.dec(_f$attemptNumber),
        insertedByRuleId: data.dec(_f$insertedByRuleId),
        insertionReason: data.dec(_f$insertionReason));
  }

  @override
  final Function instantiate = _instantiate;

  static CardSessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardSessionStep>(map);
  }

  static CardSessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<CardSessionStep>(json);
  }
}

mixin CardSessionStepMappable {
  String toJson() {
    return CardSessionStepMapper.ensureInitialized()
        .encodeJson<CardSessionStep>(this as CardSessionStep);
  }

  Map<String, dynamic> toMap() {
    return CardSessionStepMapper.ensureInitialized()
        .encodeMap<CardSessionStep>(this as CardSessionStep);
  }

  CardSessionStepCopyWith<CardSessionStep, CardSessionStep, CardSessionStep>
      get copyWith =>
          _CardSessionStepCopyWithImpl<CardSessionStep, CardSessionStep>(
              this as CardSessionStep, $identity, $identity);
  @override
  String toString() {
    return CardSessionStepMapper.ensureInitialized()
        .stringifyValue(this as CardSessionStep);
  }

  @override
  bool operator ==(Object other) {
    return CardSessionStepMapper.ensureInitialized()
        .equalsValue(this as CardSessionStep, other);
  }

  @override
  int get hashCode {
    return CardSessionStepMapper.ensureInitialized()
        .hashValue(this as CardSessionStep);
  }
}

extension CardSessionStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CardSessionStep, $Out> {
  CardSessionStepCopyWith<$R, CardSessionStep, $Out> get $asCardSessionStep =>
      $base.as((v, t, t2) => _CardSessionStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CardSessionStepCopyWith<$R, $In extends CardSessionStep, $Out>
    implements SessionStepCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? studyCardId,
      int? attemptNumber,
      String? insertedByRuleId,
      String? insertionReason});
  CardSessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _CardSessionStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardSessionStep, $Out>
    implements CardSessionStepCopyWith<$R, CardSessionStep, $Out> {
  _CardSessionStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardSessionStep> $mapper =
      CardSessionStepMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? studyCardId,
          int? attemptNumber,
          Object? insertedByRuleId = $none,
          Object? insertionReason = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (studyCardId != null) #studyCardId: studyCardId,
        if (attemptNumber != null) #attemptNumber: attemptNumber,
        if (insertedByRuleId != $none) #insertedByRuleId: insertedByRuleId,
        if (insertionReason != $none) #insertionReason: insertionReason
      }));
  @override
  CardSessionStep $make(CopyWithData data) => CardSessionStep(
      id: data.get(#id, or: $value.id),
      studyCardId: data.get(#studyCardId, or: $value.studyCardId),
      attemptNumber: data.get(#attemptNumber, or: $value.attemptNumber),
      insertedByRuleId:
          data.get(#insertedByRuleId, or: $value.insertedByRuleId),
      insertionReason: data.get(#insertionReason, or: $value.insertionReason));

  @override
  CardSessionStepCopyWith<$R2, CardSessionStep, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CardSessionStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageSessionStepMapper extends SubClassMapperBase<MessageSessionStep> {
  MessageSessionStepMapper._();

  static MessageSessionStepMapper? _instance;
  static MessageSessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageSessionStepMapper._());
      SessionStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'MessageSessionStep';

  static String _$id(MessageSessionStep v) => v.id;
  static const Field<MessageSessionStep, String> _f$id = Field('id', _$id);
  static String _$messageDefinitionId(MessageSessionStep v) =>
      v.messageDefinitionId;
  static const Field<MessageSessionStep, String> _f$messageDefinitionId = Field(
      'messageDefinitionId', _$messageDefinitionId,
      key: r'message_definition_id');
  static String _$title(MessageSessionStep v) => v.title;
  static const Field<MessageSessionStep, String> _f$title =
      Field('title', _$title);
  static String _$message(MessageSessionStep v) => v.message;
  static const Field<MessageSessionStep, String> _f$message =
      Field('message', _$message);
  static String? _$insertedByRuleId(MessageSessionStep v) => v.insertedByRuleId;
  static const Field<MessageSessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(MessageSessionStep v) => v.insertionReason;
  static const Field<MessageSessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<MessageSessionStep> fields = const {
    #id: _f$id,
    #messageDefinitionId: _f$messageDefinitionId,
    #title: _f$title,
    #message: _f$message,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  @override
  final String discriminatorKey = 'step_type';
  @override
  final dynamic discriminatorValue = 'message';
  @override
  late final ClassMapperBase superMapper =
      SessionStepMapper.ensureInitialized();

  static MessageSessionStep _instantiate(DecodingData data) {
    return MessageSessionStep(
        id: data.dec(_f$id),
        messageDefinitionId: data.dec(_f$messageDefinitionId),
        title: data.dec(_f$title),
        message: data.dec(_f$message),
        insertedByRuleId: data.dec(_f$insertedByRuleId),
        insertionReason: data.dec(_f$insertionReason));
  }

  @override
  final Function instantiate = _instantiate;

  static MessageSessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageSessionStep>(map);
  }

  static MessageSessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<MessageSessionStep>(json);
  }
}

mixin MessageSessionStepMappable {
  String toJson() {
    return MessageSessionStepMapper.ensureInitialized()
        .encodeJson<MessageSessionStep>(this as MessageSessionStep);
  }

  Map<String, dynamic> toMap() {
    return MessageSessionStepMapper.ensureInitialized()
        .encodeMap<MessageSessionStep>(this as MessageSessionStep);
  }

  MessageSessionStepCopyWith<MessageSessionStep, MessageSessionStep,
          MessageSessionStep>
      get copyWith => _MessageSessionStepCopyWithImpl<MessageSessionStep,
          MessageSessionStep>(this as MessageSessionStep, $identity, $identity);
  @override
  String toString() {
    return MessageSessionStepMapper.ensureInitialized()
        .stringifyValue(this as MessageSessionStep);
  }

  @override
  bool operator ==(Object other) {
    return MessageSessionStepMapper.ensureInitialized()
        .equalsValue(this as MessageSessionStep, other);
  }

  @override
  int get hashCode {
    return MessageSessionStepMapper.ensureInitialized()
        .hashValue(this as MessageSessionStep);
  }
}

extension MessageSessionStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageSessionStep, $Out> {
  MessageSessionStepCopyWith<$R, MessageSessionStep, $Out>
      get $asMessageSessionStep => $base.as(
          (v, t, t2) => _MessageSessionStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageSessionStepCopyWith<$R, $In extends MessageSessionStep,
    $Out> implements SessionStepCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? messageDefinitionId,
      String? title,
      String? message,
      String? insertedByRuleId,
      String? insertionReason});
  MessageSessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MessageSessionStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageSessionStep, $Out>
    implements MessageSessionStepCopyWith<$R, MessageSessionStep, $Out> {
  _MessageSessionStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageSessionStep> $mapper =
      MessageSessionStepMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? messageDefinitionId,
          String? title,
          String? message,
          Object? insertedByRuleId = $none,
          Object? insertionReason = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (messageDefinitionId != null)
          #messageDefinitionId: messageDefinitionId,
        if (title != null) #title: title,
        if (message != null) #message: message,
        if (insertedByRuleId != $none) #insertedByRuleId: insertedByRuleId,
        if (insertionReason != $none) #insertionReason: insertionReason
      }));
  @override
  MessageSessionStep $make(CopyWithData data) => MessageSessionStep(
      id: data.get(#id, or: $value.id),
      messageDefinitionId:
          data.get(#messageDefinitionId, or: $value.messageDefinitionId),
      title: data.get(#title, or: $value.title),
      message: data.get(#message, or: $value.message),
      insertedByRuleId:
          data.get(#insertedByRuleId, or: $value.insertedByRuleId),
      insertionReason: data.get(#insertionReason, or: $value.insertionReason));

  @override
  MessageSessionStepCopyWith<$R2, MessageSessionStep, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MessageSessionStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SummarySessionStepMapper extends SubClassMapperBase<SummarySessionStep> {
  SummarySessionStepMapper._();

  static SummarySessionStepMapper? _instance;
  static SummarySessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SummarySessionStepMapper._());
      SessionStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SummarySessionStep';

  static String _$id(SummarySessionStep v) => v.id;
  static const Field<SummarySessionStep, String> _f$id = Field('id', _$id);
  static String? _$insertedByRuleId(SummarySessionStep v) => v.insertedByRuleId;
  static const Field<SummarySessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(SummarySessionStep v) => v.insertionReason;
  static const Field<SummarySessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<SummarySessionStep> fields = const {
    #id: _f$id,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  @override
  final String discriminatorKey = 'step_type';
  @override
  final dynamic discriminatorValue = 'summary';
  @override
  late final ClassMapperBase superMapper =
      SessionStepMapper.ensureInitialized();

  static SummarySessionStep _instantiate(DecodingData data) {
    return SummarySessionStep(
        id: data.dec(_f$id),
        insertedByRuleId: data.dec(_f$insertedByRuleId),
        insertionReason: data.dec(_f$insertionReason));
  }

  @override
  final Function instantiate = _instantiate;

  static SummarySessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SummarySessionStep>(map);
  }

  static SummarySessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<SummarySessionStep>(json);
  }
}

mixin SummarySessionStepMappable {
  String toJson() {
    return SummarySessionStepMapper.ensureInitialized()
        .encodeJson<SummarySessionStep>(this as SummarySessionStep);
  }

  Map<String, dynamic> toMap() {
    return SummarySessionStepMapper.ensureInitialized()
        .encodeMap<SummarySessionStep>(this as SummarySessionStep);
  }

  SummarySessionStepCopyWith<SummarySessionStep, SummarySessionStep,
          SummarySessionStep>
      get copyWith => _SummarySessionStepCopyWithImpl<SummarySessionStep,
          SummarySessionStep>(this as SummarySessionStep, $identity, $identity);
  @override
  String toString() {
    return SummarySessionStepMapper.ensureInitialized()
        .stringifyValue(this as SummarySessionStep);
  }

  @override
  bool operator ==(Object other) {
    return SummarySessionStepMapper.ensureInitialized()
        .equalsValue(this as SummarySessionStep, other);
  }

  @override
  int get hashCode {
    return SummarySessionStepMapper.ensureInitialized()
        .hashValue(this as SummarySessionStep);
  }
}

extension SummarySessionStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SummarySessionStep, $Out> {
  SummarySessionStepCopyWith<$R, SummarySessionStep, $Out>
      get $asSummarySessionStep => $base.as(
          (v, t, t2) => _SummarySessionStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SummarySessionStepCopyWith<$R, $In extends SummarySessionStep,
    $Out> implements SessionStepCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? insertedByRuleId, String? insertionReason});
  SummarySessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SummarySessionStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SummarySessionStep, $Out>
    implements SummarySessionStepCopyWith<$R, SummarySessionStep, $Out> {
  _SummarySessionStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SummarySessionStep> $mapper =
      SummarySessionStepMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          Object? insertedByRuleId = $none,
          Object? insertionReason = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (insertedByRuleId != $none) #insertedByRuleId: insertedByRuleId,
        if (insertionReason != $none) #insertionReason: insertionReason
      }));
  @override
  SummarySessionStep $make(CopyWithData data) => SummarySessionStep(
      id: data.get(#id, or: $value.id),
      insertedByRuleId:
          data.get(#insertedByRuleId, or: $value.insertedByRuleId),
      insertionReason: data.get(#insertionReason, or: $value.insertionReason));

  @override
  SummarySessionStepCopyWith<$R2, SummarySessionStep, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SummarySessionStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
