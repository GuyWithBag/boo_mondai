import 'package:boo_mondai/lib.barrel.dart'
    show CachedMedia, HiveLocalDB, LocalDB;

class CachedMediasLocalDB extends HiveLocalDB<CachedMedia> {
  @override
  String get boxName => 'cached_medias';

  @override
  Map<String, Object?> primaryKeyFromItem(CachedMedia item) => {
    'profile_id': item.profileId,
    'path': item.path,
  };

  @override
  DateTime? getDeletedAt(CachedMedia item) => throw UnimplementedError;

  List<CachedMedia> getByCurrentProfile() => guardSync(
    () => selectMany()
        .where((d) => d.profileId == LocalDB.profile.getOrCreate().id)
        .toList(),
    action: 'getByCurrentProfile',
  );

  List<CachedMedia> getByProfileId(String profileId) => guardSync(
    () => selectMany(where: (item) => item.profileId == profileId),
    action: 'getByProfileId($profileId)',
  );
}
