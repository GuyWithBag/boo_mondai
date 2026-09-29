import 'package:dart_mappable/dart_mappable.dart';

part 'vector2.hive.mapper.dart';

@MappableClass()
class Vector2Hive with Vector2HiveMappable {
  final double x;
  final double y;

  const Vector2Hive(this.x, this.y);

  const Vector2Hive.zero() : this(0, 0);
}
