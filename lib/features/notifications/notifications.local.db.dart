import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, NotificationIntent;

class NotificationsLocalDB extends HiveLocalDB<NotificationIntent> {
  @override
  String get boxName => 'notifications';

  @override
  Map<String, Object?> primaryKeyFromItem(NotificationIntent item) {
    return {'id': item.id};
  }

  @override
  DateTime? getDeletedAt(NotificationIntent item) => item.deletedAt;

  List<NotificationIntent> selectAllNotifications(String profileId) {
    final now = DateTime.now();
    return sortNewestFirst(
      selectMany(
        includeDeleted: true,
        where: (notification) =>
            notification.profileId == profileId &&
            notification.deletedAt == null &&
            notification.purgeAt.isAfter(now),
      ),
    );
  }

  List<NotificationIntent> selectUnreadNotifications(String profileId) {
    final now = DateTime.now();
    return sortNewestFirst(
      selectMany(
        where: (notification) =>
            notification.profileId == profileId &&
            notification.readAt == null &&
            notification.purgeAt.isAfter(now),
      ),
    );
  }

  List<NotificationIntent> selectReadNotifications(String profileId) {
    final now = DateTime.now();
    return sortNewestFirst(
      selectMany(
        includeDeleted: true,
        where: (notification) =>
            notification.profileId == profileId &&
            notification.deletedAt == null &&
            notification.readAt != null &&
            notification.purgeAt.isAfter(now),
      ),
    );
  }

  List<NotificationIntent> selectDeletedNotifications(String profileId) {
    final now = DateTime.now();
    return sortNewestFirst(
      selectMany(
        includeDeleted: true,
        where: (notification) =>
            notification.profileId == profileId &&
            notification.deletedAt != null &&
            notification.purgeAt.isAfter(now),
      ),
    );
  }

  List<NotificationIntent> sortNewestFirst(
    List<NotificationIntent> notifications,
  ) {
    return notifications..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
