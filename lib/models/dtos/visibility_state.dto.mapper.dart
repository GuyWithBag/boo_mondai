// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'visibility_state.dto.dart';

class VisibilityStateMapper extends EnumMapper<VisibilityState> {
  VisibilityStateMapper._();

  static VisibilityStateMapper? _instance;
  static VisibilityStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VisibilityStateMapper._());
    }
    return _instance!;
  }

  static VisibilityState fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  VisibilityState decode(dynamic value) {
    switch (value) {
      case r'public':
        return VisibilityState.public;
      case r'private':
        return VisibilityState.private;
      case r'unlisted':
        return VisibilityState.unlisted;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(VisibilityState self) {
    switch (self) {
      case VisibilityState.public:
        return r'public';
      case VisibilityState.private:
        return r'private';
      case VisibilityState.unlisted:
        return r'unlisted';
    }
  }
}

extension VisibilityStateMapperExtension on VisibilityState {
  String toValue() {
    VisibilityStateMapper.ensureInitialized();
    return MapperContainer.globals.toValue<VisibilityState>(this) as String;
  }
}
