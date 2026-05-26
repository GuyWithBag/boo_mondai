// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/drill_session_repository.dart
// PURPOSE: Hive CRUD for DrillSession only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, DrillSession;

class DrillSessionsLocalDB extends HiveLocalDB<DrillSession> {
  @override
  String get boxName => 'drill_sessions';

  @override
  Map<String, Object?> primaryKeyFromItem(DrillSession item) => {'id': item.id};

  List<DrillSession> getRecent(int count) => guardSync(() {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }, action: 'getRecent($count)');
}
