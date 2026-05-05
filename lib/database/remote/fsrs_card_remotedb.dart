// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_fsrs_service.dart
// PURPOSE: Supabase sync for FSRS card states and review logs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class FsrsCardRemoteDB extends SupabaseRemoteDB<FsrsCard> {
  @override
  String get tableName => 'fsrs_cards';

  @override
  FsrsCard Function(Map<String, dynamic>) get fromMap => FsrsCardMapper.fromMap;

  @override
  Map<String, dynamic> toMap(FsrsCard item) => item.toMap();
}
