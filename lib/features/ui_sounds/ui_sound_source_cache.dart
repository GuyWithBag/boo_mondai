import 'package:boo_mondai/features/media_variants/media_asset.model.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class UiSoundSourceCache {
  UiSoundSourceCache({required this.soloud});

  final SoLoud soloud;
  final Map<String, Future<AudioSource>> sources = {};

  Future<AudioSource> load(MediaAsset asset) {
    final key = '${asset.source.name}:${asset.requirePath}';
    return sources.putIfAbsent(key, () async {
      try {
        return switch (asset.source) {
          MediaSource.asset => soloud.loadAsset(asset.requirePath),
          MediaSource.file => soloud.loadFile(asset.requirePath),
          MediaSource.network => soloud.loadUrl(asset.requirePath),
        };
      } catch (_) {
        sources.remove(key);
        rethrow;
      }
    });
  }

  Future<void> preload(Iterable<MediaAsset> assets) async {
    await Future.wait(assets.map(load));
  }
}
