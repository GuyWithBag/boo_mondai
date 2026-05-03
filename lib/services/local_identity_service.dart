// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/local_identity_service.dart
// PURPOSE: Persistent device-local UUID — the identity anchor for all offline data
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:boo_mondai/services/uuid_service.dart';

/// Manages a persistent device-local UUID stored in a plain Hive box.
///
/// Timeline:
///   First launch        → UUID generated and stored as [_guestIdKey]
///   Guest usage         → all Hive records keyed by this UUID
///   Sign-up / sign-in   → [overwrite] replaces it with the Supabase UID
///   Thereafter          → [getOrCreate] returns the Supabase UID
///
/// The box is a plain dynamic box so no custom Hive adapter is needed.
class LocalIdentityService {
  static const _boxName = 'settings_box';
  static const _guestIdKey = 'local_user_id';

  static late final Box<dynamic> _box;

  /// Must be called once in main() before any call to [getOrCreate] or [overwrite].
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Returns the stored local user ID, creating and persisting a new UUID
  /// on the very first call (first launch).
  static String getOrCreate() {
    final existing = _box.get(_guestIdKey) as String?;
    if (existing != null) return existing;
    final newId = UuidService.uuid.v4();
    _box.put(_guestIdKey, newId);
    return newId;
  }

  /// Replaces the stored ID with [newId].
  ///
  /// Called after successful sign-up or sign-in so that the local identity
  /// is permanently aligned with the Supabase UID going forward.
  static Future<void> overwrite(String newId) async {
    await _box.put(_guestIdKey, newId);
  }
}
