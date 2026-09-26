// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'content.type.dart';

class ContentTypeMapper extends EnumMapper<ContentType> {
  ContentTypeMapper._();

  static ContentTypeMapper? _instance;
  static ContentTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContentTypeMapper._());
    }
    return _instance!;
  }

  static ContentType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ContentType decode(dynamic value) {
    switch (value) {
      case r'deck_listing':
        return ContentType.deckListing;
      case r'review':
        return ContentType.review;
      case r'comment':
        return ContentType.comment;
      case r'deck':
        return ContentType.deck;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ContentType self) {
    switch (self) {
      case ContentType.deckListing:
        return r'deck_listing';
      case ContentType.review:
        return r'review';
      case ContentType.comment:
        return r'comment';
      case ContentType.deck:
        return r'deck';
    }
  }
}

extension ContentTypeMapperExtension on ContentType {
  String toValue() {
    ContentTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ContentType>(this) as String;
  }
}
