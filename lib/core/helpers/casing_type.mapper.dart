// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'casing_type.dart';

class CasingTypeMapper extends EnumMapper<CasingType> {
  CasingTypeMapper._();

  static CasingTypeMapper? _instance;
  static CasingTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CasingTypeMapper._());
    }
    return _instance!;
  }

  static CasingType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CasingType decode(dynamic value) {
    switch (value) {
      case r'any':
        return CasingType.any;
      case r'exact':
        return CasingType.exact;
      case r'camel':
        return CasingType.camel;
      case r'pascal':
        return CasingType.pascal;
      case r'snake':
        return CasingType.snake;
      case r'kebab':
        return CasingType.kebab;
      case r'title':
        return CasingType.title;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CasingType self) {
    switch (self) {
      case CasingType.any:
        return r'any';
      case CasingType.exact:
        return r'exact';
      case CasingType.camel:
        return r'camel';
      case CasingType.pascal:
        return r'pascal';
      case CasingType.snake:
        return r'snake';
      case CasingType.kebab:
        return r'kebab';
      case CasingType.title:
        return r'title';
    }
  }
}

extension CasingTypeMapperExtension on CasingType {
  String toValue() {
    CasingTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CasingType>(this) as String;
  }
}
