import 'package:dart_mappable/dart_mappable.dart';

part 'content.type.mapper.dart';

@MappableEnum()
enum ContentType { deckListing, review, comment, deck }
