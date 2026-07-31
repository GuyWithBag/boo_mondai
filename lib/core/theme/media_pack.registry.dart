import 'package:boo_mondai/lib.barrel.dart' show AppMediaPack, defaultMediaPack;
import 'package:media_variants/media_variants.dart';

final appMediaPackRegistry = MediaPackRegistry<AppMediaPack>(
  packs: [defaultMediaPack],
);

MediaPackController<AppMediaPack> createAppMediaPackController() {
  return MediaPackController<AppMediaPack>(
    registry: appMediaPackRegistry,
    activePackId: defaultMediaPack.id,
  );
}
