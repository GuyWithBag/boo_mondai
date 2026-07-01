import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, LocalImageCacheEntry;

class LocalImagesLocalDB extends HiveLocalDB<LocalImageCacheEntry> {
  @override
  String get boxName => 'local_images';

  @override
  Map<String, Object?> primaryKeyFromItem(LocalImageCacheEntry item) => {
    'cache_key': item.cacheKey,
  };
}
