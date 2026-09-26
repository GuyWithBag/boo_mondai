// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card_type.dto.dart';

class CardTemplateDirectionMapper extends EnumMapper<CardTemplateDirection> {
  CardTemplateDirectionMapper._();

  static CardTemplateDirectionMapper? _instance;
  static CardTemplateDirectionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardTemplateDirectionMapper._());
    }
    return _instance!;
  }

  static CardTemplateDirection fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CardTemplateDirection decode(dynamic value) {
    switch (value) {
      case r'normal':
        return CardTemplateDirection.normal;
      case r'reversed':
        return CardTemplateDirection.reversed;
      case r'both':
        return CardTemplateDirection.both;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CardTemplateDirection self) {
    switch (self) {
      case CardTemplateDirection.normal:
        return r'normal';
      case CardTemplateDirection.reversed:
        return r'reversed';
      case CardTemplateDirection.both:
        return r'both';
    }
  }
}

extension CardTemplateDirectionMapperExtension on CardTemplateDirection {
  String toValue() {
    CardTemplateDirectionMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CardTemplateDirection>(this)
        as String;
  }
}
