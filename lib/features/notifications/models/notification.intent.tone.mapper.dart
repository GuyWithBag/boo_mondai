// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification.intent.tone.dart';

class NotificationIntentToneMapper extends EnumMapper<NotificationIntentTone> {
  NotificationIntentToneMapper._();

  static NotificationIntentToneMapper? _instance;
  static NotificationIntentToneMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationIntentToneMapper._());
    }
    return _instance!;
  }

  static NotificationIntentTone fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NotificationIntentTone decode(dynamic value) {
    switch (value) {
      case r'inherit':
        return NotificationIntentTone.inherit;
      case r'success':
        return NotificationIntentTone.success;
      case r'danger':
        return NotificationIntentTone.danger;
      case r'warning':
        return NotificationIntentTone.warning;
      case r'announcement':
        return NotificationIntentTone.announcement;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NotificationIntentTone self) {
    switch (self) {
      case NotificationIntentTone.inherit:
        return r'inherit';
      case NotificationIntentTone.success:
        return r'success';
      case NotificationIntentTone.danger:
        return r'danger';
      case NotificationIntentTone.warning:
        return r'warning';
      case NotificationIntentTone.announcement:
        return r'announcement';
    }
  }
}

extension NotificationIntentToneMapperExtension on NotificationIntentTone {
  String toValue() {
    NotificationIntentToneMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NotificationIntentTone>(this)
        as String;
  }
}

