import 'package:boo_mondai/lib.barrel.dart'
    show AuthService, LocalDB, Profile, ProfileMediaService, RemoteDB;
import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class ProfileService {
  static Profile getCurrentProfile() => LocalDB.profile.getOrCreate();

  static Future<void> updateDisplayName(String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return;

    final profile = getCurrentProfile();
    final updated = profile.copyWith(
      displayName: trimmed,
      updatedAt: DateTime.now(),
    );
    await LocalDB.profile.upsert(updated);

    if (AuthService.isAuthenticatedRemote) {
      await RemoteDB.profile.upsert(
        await ProfileMediaService.uploadAvatarIfNeeded(
          profile: updated,
          bucket: RemoteDB.publicBucket,
        ),
      );
    }
  }

  static Future<void> updateAvatarImage(PlatformFile file) async {
    var updated = await ProfileMediaService.saveAvatarImage(
      profile: getCurrentProfile(),
      file: file,
    );
    if (updated == null) return;

    if (AuthService.isAuthenticatedRemote) {
      updated = await ProfileMediaService.uploadAvatarIfNeeded(
        profile: updated,
        bucket: RemoteDB.publicBucket,
      );
      await RemoteDB.profile.upsert(updated);
    }
  }
}
