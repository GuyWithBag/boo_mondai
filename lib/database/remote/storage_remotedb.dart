// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_storage_service.dart
// PURPOSE: Supabase storage operations for image upload/delete
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:typed_data';
import 'package:boo_mondai/services/app_exception.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class StorageRemoteDB extends SupabaseRemoteDB<Never> {
  // Storage operates on buckets, not a DB table — these are never called.
  @override
  String get tableName => throw UnimplementedError();

  @override
  Never Function(Map<String, dynamic>) get fromMap =>
      throw UnimplementedError();
  @override
  Map<String, dynamic> toMap(Never item) => {};

  Future<String> uploadImage(
    String bucket,
    String path,
    Uint8List bytes,
  ) async {
    try {
      await client.storage.from(bucket).uploadBinary(path, bytes);
      return client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      throw AppException('Failed to upload image: $e');
    }
  }

  Future<void> deleteImage(String bucket, String path) async {
    try {
      await client.storage.from(bucket).remove([path]);
    } catch (e) {
      throw AppException('Failed to delete image: $e');
    }
  }
}
