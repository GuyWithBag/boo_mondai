import 'dart:async';

import 'package:boo_mondai/features/media_variants/media_pack.store.dart';
import 'package:boo_mondai/features/ui_sounds/ui_sound_source_cache.dart';
import 'package:signals/signals_flutter.dart';

class UiSoundsPreloader<T> {
  UiSoundsPreloader({required this.store, required this.cache});

  final MediaPackStore<T> store;
  final UiSoundSourceCache cache;
  late final EffectCleanup preloadEffect;

  void start() {
    preloadEffect = effect(() {
      final assets = store.audioAssets.value;
      unawaited(cache.preload(assets));
    });
  }

  void dispose() {
    preloadEffect();
  }
}
