import 'package:boo_mondai/lib.barrel.dart' show uuid;
import 'package:dart_mappable/dart_mappable.dart';

part 'sync_client.mapper.dart';

@MappableClass()
class SyncClient with SyncClientMappable {
  const SyncClient({
    required this.id,
    required this.profileId,
    required this.createdAt,
    required this.lastSeenAt,
    this.lastSyncedAt,
    this.deviceName,
  });

  final String id;
  final String profileId;
  final String? deviceName;
  final DateTime createdAt;
  final DateTime lastSeenAt;
  final DateTime? lastSyncedAt;

  factory SyncClient.create({required String profileId, String? deviceName}) {
    final now = DateTime.now();
    return SyncClient(
      id: uuid.v7(),
      profileId: profileId,
      deviceName: deviceName,
      createdAt: now,
      lastSeenAt: now,
    );
  }
}
