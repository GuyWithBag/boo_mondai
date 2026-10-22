typedef MediaAssetEnabled = bool Function();

enum MediaType { audio, image, video, empty }

enum MediaSource { asset, file, network }

bool mediaAssetEnabled() => true;

class MediaAsset {
  const MediaAsset({
    required this.type,
    required this.source,
    required this.enabled,
    this.path,
  });

  const MediaAsset.audio(
    String path, {
    MediaSource source = MediaSource.asset,
    MediaAssetEnabled enabled = mediaAssetEnabled,
  }) : this(
         type: MediaType.audio,
         source: source,
         path: path,
         enabled: enabled,
       );

  const MediaAsset.image(
    String path, {
    MediaSource source = MediaSource.asset,
    MediaAssetEnabled enabled = mediaAssetEnabled,
  }) : this(
         type: MediaType.image,
         source: source,
         path: path,
         enabled: enabled,
       );

  const MediaAsset.video(
    String path, {
    MediaSource source = MediaSource.asset,
    MediaAssetEnabled enabled = mediaAssetEnabled,
  }) : this(
         type: MediaType.video,
         source: source,
         path: path,
         enabled: enabled,
       );

  const MediaAsset.none()
    : this(
        type: MediaType.empty,
        source: MediaSource.asset,
        enabled: mediaAssetEnabled,
      );

  final MediaType type;
  final String? path;
  final MediaSource source;
  final MediaAssetEnabled enabled;

  bool get isEmpty => type == MediaType.empty;

  bool get isEnabled => enabled();

  String get requirePath {
    final value = path;
    if (value == null) {
      throw StateError('Empty media has no path');
    }
    return value;
  }
}
