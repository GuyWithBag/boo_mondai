// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card_type.dart';

class CardTypeMapper extends EnumMapper<CardType> {
  CardTypeMapper._();

  static CardTypeMapper? _instance;
  static CardTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardTypeMapper._());
    }
    return _instance!;
  }

  static CardType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CardType decode(dynamic value) {
    switch (value) {
      case r'normal':
        return CardType.normal;
      case r'reversed':
        return CardType.reversed;
      case r'both':
        return CardType.both;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CardType self) {
    switch (self) {
      case CardType.normal:
        return r'normal';
      case CardType.reversed:
        return r'reversed';
      case CardType.both:
        return r'both';
    }
  }
}

extension CardTypeMapperExtension on CardType {
  String toValue() {
    CardTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CardType>(this) as String;
  }
}
