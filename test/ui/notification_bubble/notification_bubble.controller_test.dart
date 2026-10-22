import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, NotificationIntent, NotificationIntentType;
import 'package:boo_mondai/ui/notification.bubble/notification.bubble.controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'boo_mondai_notification_bubble_controller_test_',
    );
    Hive.init(hiveDirectory.path);
    Hive.registerAdapters();
    await LocalDB.init();
  });

  setUp(() async {
    await LocalDB.clearAll();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('keeps an active bubble visible after it is marked shown', () async {
    final profile = LocalDB.currentProfile.getOrCreate();
    final notification = NotificationIntent.create(
      id: 9001,
      profileId: profile.id,
      type: NotificationIntentType.researcherStudySessionComplete,
      title: 'Research session complete',
      shortDescription: 'A research deck study session was completed.',
      body: 'A research deck study session was completed.',
      showAsBubble: true,
      showSystemNotification: false,
    );
    await LocalDB.notifications.upsert(notification);

    final controller = NotificationBubbleController();
    addTearDown(controller.dispose);

    expect(controller.activeNotifications.value, hasLength(1));

    await controller.markShown(notification);
    controller.refresh();

    expect(controller.activeNotifications.value, hasLength(1));
    expect(controller.activeNotifications.value.single.id, notification.id);

    await controller.dismiss(notification);

    expect(controller.activeNotifications.value, isEmpty);
  });
}
