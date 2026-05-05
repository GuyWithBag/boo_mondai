// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_drill_service.dart
// PURPOSE: Supabase operations for drill sessions and answers
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class DrillSessionRemoteDB extends SupabaseRemoteDB<DrillSession> {
  @override
  String get tableName => 'drill_sessions';

  @override
  DrillSession Function(Map<String, dynamic>) get fromMap =>
      DrillSessionMapper.fromMap;

  /// Strips the dart_mappable discriminator key before writing to the DB.
  @override
  Map<String, dynamic> toMap(DrillSession item) =>
      item.toMap()..remove('session_type');
}
