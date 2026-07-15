import 'package:boo_mondai/lib.barrel.dart'
    show
        BucketSupabaseRemoteDB,
        LocalDB,
        MediaRemotePathHelper,
        Profile,
        StoredMediaPathHelper,
        StoredMediaService,
        SyncMediaReference,
        SyncMediaReferenceApplier;
import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class ProfileMediaService {
  /// Stores a picked avatar file locally and updates the local profile timestamp.
  static Future<Profile?> saveAvatarImage({
    required Profile profile,
    required PlatformFile file,
  }) async {
    final stored = await StoredMediaService.storeFile(
      path: StoredMediaPathHelper.profileAvatar(),
      file: file,
    );
    if (stored == null) return null;

    final updated = profile.copyWith(updatedAt: DateTime.now());
    await LocalDB.profile.upsert(updated);
    return updated;
  }

  /// Uploads a pending local avatar and rewrites `Profile.avatarUrl`.
  static Future<Profile> uploadAvatarIfNeeded({
    required Profile profile,
    required BucketSupabaseRemoteDB bucket,
  }) {
    return SyncMediaReferenceApplier.apply<Profile>(
      item: profile,
      persistItem: LocalDB.profile.upsert,
      references: [
        SyncMediaReference<Profile>(
          localPath: StoredMediaPathHelper.profileAvatar(),
          remotePath: MediaRemotePathHelper.profileAvatar(
            profileId: profile.id,
          ),
          bucket: bucket,
          readValue: (profile) => profile.avatarUrl,
          writeValue: (profile, uploadedValue) =>
              profile.copyWith(avatarUrl: uploadedValue),
        ),
      ],
    );
  }
}
