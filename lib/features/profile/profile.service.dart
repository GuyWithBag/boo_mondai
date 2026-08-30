import 'dart:typed_data';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        LocalDB,
        RemoteDB,
        CachedMedia,
        MediaHelper,
        CachedMediaService;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

abstract final class ProfileService {
  static final bucketPathProfileAvatar = 'profileAvatar';

  static final currentProfile = signal(LocalDB.profile.getOrCreate());
  static final profileEffect = Effect(() {
    LocalDB.profile.upsert(currentProfile.value);

    if (!AuthService.isAuthenticatedRemote) return;
    // if (RemoteDB.profile.selectByUserId())
    RemoteDB.profile.upsert(currentProfile.value);
  });

  static Future<void> upsertDisplayName(String displayName) async {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return;

    currentProfile.value = currentProfile.value.copyWith(
      displayName: displayName,
      updatedAt: DateTime.now(),
    );
  }

  static Future<void> getAvatar(Function(ImageProvider? image) response) async {
    await CachedMediaService.getLocalFirstMedia(
      response: response,
      path: bucketPathProfileAvatar,
    );
  }

  static Future<void> upsertAvatar(Uint8List bytes) async {
    final cachedMedia = CachedMedia(
      bytes: bytes,
      path: ProfileService.bucketPathProfileAvatar,
      profileId: currentProfile.value.id,
    );

    LocalDB.cachedMedias.upsert(cachedMedia);
    final remoteUrl = await RemoteDB.publicBucket.uploadBytes(
      ProfileService.bucketPathProfileAvatar,
      bytes,
    );
    final updatedProfile = currentProfile.value.copyWith(
      updatedAt: DateTime.now(),
      avatarUrl: remoteUrl,
    );

    currentProfile.value = updatedProfile;
  }
}
