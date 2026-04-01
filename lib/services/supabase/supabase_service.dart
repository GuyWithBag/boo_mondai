// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_service.dart
// PURPOSE: Abstract base for all Supabase services — shared client access
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:boo_mondai/services/app_exception.dart';

/// Base class for domain-specific Supabase services.
///
/// Provides the shared [client] accessor and a helper [guard] that wraps
/// Supabase calls and converts exceptions into [AppException].
abstract class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;

  /// Runs [fn] and converts [PostgrestException] / [AuthException] into
  /// [AppException]. Use this in every public method to keep error handling
  /// consistent across all subclasses.
  Future<T> guard<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }
}
