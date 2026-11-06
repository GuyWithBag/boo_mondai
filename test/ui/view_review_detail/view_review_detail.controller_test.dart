import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        LocalDB,
        ReviewDetailRangeMode,
        ReviewDetailTimeSpan,
        ViewReviewDetailController;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'boo_mondai_review_detail_controller_test_',
    );
    Hive.init(hiveDirectory.path);
    Hive.registerAdapters();
    await LocalDB.init();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('uses the calendar month for a fixed one-month range', () async {
    final controller = ViewReviewDetailController('missing-deck');
    await controller.load();
    controller.setRangeMode(ReviewDetailRangeMode.fixed);
    controller.selectTimeSpan(ReviewDetailTimeSpan.oneMonth);

    expect(controller.rangeStart(DateTime(2026, 11, 6)), DateTime(2026, 11));
    controller.dispose();
  });
}
