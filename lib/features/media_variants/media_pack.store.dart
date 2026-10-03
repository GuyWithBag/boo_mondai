import 'package:boo_mondai/features/media_variants/app_media_pack.model.dart';
import 'package:boo_mondai/features/media_variants/default.media_pack.dart';
import 'package:boo_mondai/features/media_variants/media_asset.model.dart';
import 'package:boo_mondai/features/media_variants/media_pack.model.dart';
import 'package:boo_mondai/features/media_variants/media_selector.dart';
import 'package:signals/signals_flutter.dart';

class MediaPackStore<T> {
  MediaPackStore({
    required List<MediaPack<T>> packs,
    required String activePackId,
    required this.getAudioAssets,
  }) : packs = signal(packs),
       activePackId = signal(activePackId) {
    activePack = computed(
      () => this.packs.value
          .where((pack) => pack.id == this.activePackId.value)
          .firstOrNull,
    );
    audioAssets = computed(() {
      final pack = activePack.value;
      if (pack == null) return const <MediaAsset>[];
      return getAudioAssets(pack.media)
          .where((asset) => asset.type == MediaType.audio && !asset.isEmpty)
          .toList();
    });
  }

  final Signal<List<MediaPack<T>>> packs;
  final Signal<String> activePackId;
  final List<MediaAsset> Function(T media) getAudioAssets;
  late final Computed<MediaPack<T>?> activePack;
  late final Computed<List<MediaAsset>> audioAssets;

  void setActivePack(String id) {
    if (activePackId.value == id) return;
    activePackId.value = id;
  }

  void addPack(MediaPack<T> pack) {
    packs.value = [...packs.value, pack];
  }

  void addPacks(List<MediaPack<T>> newPacks) {
    packs.value = [...packs.value, ...newPacks];
  }

  void removePack(String id) {
    packs.value = packs.value.where((pack) => pack.id != id).toList();
  }

  void replacePack(MediaPack<T> pack) {
    packs.value = [
      for (final existing in packs.value)
        if (existing.id == pack.id) pack else existing,
    ];
  }

  MediaPack<T>? getActivePack() => activePack.value;

  MediaAsset resolve(MediaSelector<T> selector) {
    final pack = activePack.value;
    if (pack == null) return const MediaAsset.none();
    return selector(pack.media);
  }
}

final appMediaPackStore = MediaPackStore<AppMediaPack>(
  packs: [defaultMediaPack],
  activePackId: defaultMediaPack.id,
  getAudioAssets: (media) => [
    media.buttonDownSound,
    media.buttonUpSound,
    media.studySessionRevealSound,
    media.studySessionCorrectSound,
    media.studySessionIncorrectSound,
    media.studySessionAgainSound,
    media.studySessionHardSound,
    media.studySessionGoodSound,
    media.studySessionEasySound,
    media.studySessionContinueSound,
    media.studySessionCompleteSound,
    media.studySessionSlowDownSound,
    media.studySessionProgressMilestoneSound,
  ],
);
