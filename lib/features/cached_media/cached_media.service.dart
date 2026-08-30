import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, ProfileService, MediaHelper, CachedMedia;
import 'package:flutter/material.dart';

abstract class CachedMediaService {
  static Future<void> getLocalFirstMedia({
    required Function(ImageProvider? image) response,
    required String path,
  }) async {
    final currentProfile = ProfileService.currentProfile;
    final cachedMedia = LocalDB.cachedMedias.selectByPk({
      'profile_id': currentProfile.value.id,
      'path': path,
    });

    if (cachedMedia != null) {
      final image = MemoryImage(cachedMedia.bytes);
      response(image);
      return;
    }

    final avatarUrl = currentProfile.value.avatarUrl;
    final bytes = await MediaHelper.getBytesFromUrl(avatarUrl);

    // ToDo: Add Error handling for null bytes.
    final image = MemoryImage(bytes!);
    response(image);

    final newCachedMedia = CachedMedia(
      bytes: bytes,
      path: ProfileService.bucketPathProfileAvatar,
      profileId: currentProfile.value.id,
    );

    LocalDB.cachedMedias.upsert(newCachedMedia);
  }
}
