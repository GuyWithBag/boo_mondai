import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show Deck, LocalDB, ViewStudyDecksController;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'boo_mondai_review_controller_test_',
    );
    Hive.init(hiveDirectory.path);
    Hive.registerAdapters();
    await LocalDB.init();
  });

  setUp(() async {
    await LocalDB.deck.clear();
    await LocalDB.studyCard.clear();
    await LocalDB.fsrsCard.clear();
    await LocalDB.reviewLogs.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('includes decks with no cards currently due', () async {
    final profile = LocalDB.currentProfile.getOrCreate();
    await LocalDB.deck.upsert(
      Deck.createDummy(
        id: 'deck-without-due-cards',
        profileId: profile.id,
        title: 'No Due Cards',
      ),
    );

    final controller = ViewStudyDecksController();
    await controller.load();

    expect(
      controller.deckEntries.value.map((entry) => entry.deck.id),
      contains('deck-without-due-cards'),
    );
    expect(controller.deckEntries.value.single.totalDue, 0);
    controller.dispose();
  });
}
