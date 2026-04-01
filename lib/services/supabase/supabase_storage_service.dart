// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_storage_service.dart
// PURPOSE: Supabase storage operations for image upload/delete
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:typed_data';
import 'package:boo_mondai/services/app_exception.dart';
import 'supabase_service.dart';

class SupabaseStorageService extends SupabaseService {
  Future<String> uploadImage(
      String bucket, String path, Uint8List bytes) async {
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
