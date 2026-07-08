abstract class Service {
  Service() : _createdAt = DateTime.now().microsecondsSinceEpoch;

  String get name => throw UnimplementedError();

  final int _createdAt;

  late final String id = '$name-$_createdAt';
}
