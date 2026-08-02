// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message.session_step.dart';

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
