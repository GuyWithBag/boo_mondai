// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/drill_session_repository.dart
// PURPOSE: Hive CRUD for DrillSession only
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class DrillSessionLocalDB extends HiveLocalDB<DrillSession> {
  @override
  String get boxName => 'drill_session_box';

  @override
  String getId(DrillSession item) => item.id;

  List<DrillSession> getRecent(int count) => guardSync(() {
    final sorted = box.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(count).toList();
  }, action: 'getRecent($count)');
}
