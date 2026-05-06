import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract class HiveSingleDataLocalDB<T> {
  String get boxName;

  late final Box<T> box;

  Future<HiveSingleDataLocalDB<T>> init() async {
    // Hive.deleteBoxFromDisk(boxName);
    box = await Hive.openBox<T>(boxName);
    return this;
  }

  /// Extracts the String key used for Hive put/get from an item.
  String getId(T item);

  T createValue();

  T? retrieve() {
    try {
      return box.values.toList()[0];
    } catch (exception) {
      return null;
    }
  }

  T getOrCreate() {
    final value = retrieve();
    if (value == null) {
      // final profile = Profile(
      //   id: UuidService.uuid.v4(),
      //   // This will be replaced by supabase's auth.user auto generated uuid.
      //   userId: UuidService.uuid.v4(),
      //   role: '',
      //   updatedAt: DateTime.now(),
      //   createdAt: DateTime.now(),
      //   username: 'guest',
      // );
      final newValue = createValue();
      upsert(newValue);
    }
    return retrieve()!;
  }

  Future<void> upsert(T item) async {
    clear();
    final map = {getId(item): item};
    await box.putAll(map);
  }

  Future<void> clear() => box.clear();
}
