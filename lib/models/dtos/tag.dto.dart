// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/tag.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'tag.dto.mapper.dart';

const _uuid = Uuid();

@MappableClass()
class Tag with TagMappable {
  final String id;
  final String?
  userId; // Nullable: null means it was created globally/by the app
  final String name;
  final DateTime createdAt;

  const Tag({
    required this.id,
    this.userId,
    required this.name,
    required this.createdAt,
  });

  factory Tag.createNow({required String name, String? userId}) {
    return Tag(
      id: _uuid.v7(), // Use v7 for time-sorted sync
      userId: userId,
      name: name,
      createdAt: DateTime.now(),
    );
  }
}
