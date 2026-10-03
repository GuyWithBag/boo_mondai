import 'dart:async';

import 'package:boo_mondai/features/media_variants/app_media_pack.model.dart';
import 'package:boo_mondai/features/media_variants/media_asset.model.dart';
import 'package:boo_mondai/features/media_variants/media_pack.store.dart';
import 'package:boo_mondai/features/ui_sounds/ui_sound_source_cache.dart';
import 'package:boo_mondai/features/ui_sounds/ui_sounds_preloader.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class UiSoundsService {
  UiSoundsService();

  static final SoLoud soloud = SoLoud.instance;
  static final UiSoundSourceCache cache = UiSoundSourceCache(soloud: soloud);
  static final UiSoundsPreloader<AppMediaPack> preloader = UiSoundsPreloader(
    store: appMediaPackStore,
    cache: cache,
  );

  static Future<void> init() async {
    await soloud.init();
    preloader.start();
    unawaited(
      cache
          .preload(appMediaPackStore.audioAssets.value)
          .catchError((Object _, StackTrace _) {}),
    );
  }

  static Future<void> playIfEnabled(
    MediaAsset asset, {
    double volume = 1,
  }) async {
    if (asset.type != MediaType.audio || asset.isEmpty) return;
    if (!asset.isEnabled) return;

    final source = await cache.load(asset);

    soloud.play(source, volume: volume);
  }
}
