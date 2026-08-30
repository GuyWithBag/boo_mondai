import 'package:boo_mondai/lib.barrel.dart' show Profile, ProfileService;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ViewProfileController {
  Signal<Profile> get profile => ProfileService.currentProfile;

  final Signal<ImageProvider?> pickedAvatarImage = signal(null);

  Future<void> onImagePicked(PlatformFile file) async {
    await upsertAvatar(file);
  }

  Future<void> getAvatar() async {
    ProfileService.getAvatar((image) => pickedAvatarImage.value = image);
  }

  Future<void> upsertDisplayName(String displayName) async {
    ProfileService.upsertDisplayName(displayName);
  }

  Future<void> upsertAvatar(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes == null) return;
    pickedAvatarImage.value = MemoryImage(bytes);
    ProfileService.upsertAvatar(bytes);
  }
}
