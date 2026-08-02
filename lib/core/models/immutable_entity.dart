import 'package:dart_mappable/dart_mappable.dart';

part 'immutable_entity.mapper.dart';

/// Immutable model — written once, never modified. Synced by existence check only.
@MappableClass()
abstract class ImmutableEntity with ImmutableEntityMappable {
  final String id;
  final DateTime createdAt;

  const ImmutableEntity({required this.id, required this.createdAt});
}
