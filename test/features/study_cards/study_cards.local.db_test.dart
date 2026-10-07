import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart' show FsrsCard, LocalDB, StudyCard;
import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'boo_mondai_study_cards_test_',
    );
    Hive.init(hiveDirectory.path);
    Hive.registerAdapters();
    await LocalDB.init();
  });

  setUp(() async {
    await LocalDB.studyCard.clear();
    await LocalDB.fsrsCard.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  group('StudyCardsLocalDB.getEligibleDrillCards', () {
    test(
      'excludes cards that already have FSRS state for the profile',
      () async {
        final now = DateTime.utc(2026);
        await LocalDB.studyCard.upsertMany([
          StudyCard(
            id: 'study-1',
            createdAt: now,
            updatedAt: now,
            templateId: 'template-1',
            deckId: 'deck-1',
          ),
          StudyCard(
            id: 'study-2',
            createdAt: now,
            updatedAt: now,
            templateId: 'template-2',
            deckId: 'deck-1',
          ),
        ]);
        await LocalDB.fsrsCard.upsert(
          FsrsCard(
            id: 'fsrs-1',
            createdAt: now,
            updatedAt: now,
            profileId: 'profile-1',
            studyCardId: 'study-1',
            state: fsrs.Card(cardId: 1),
          ),
        );
        await LocalDB.fsrsCard.upsert(
          FsrsCard(
            id: 'fsrs-2',
            createdAt: now,
            updatedAt: now,
            profileId: 'profile-2',
            studyCardId: 'study-2',
            state: fsrs.Card(cardId: 2),
          ),
        );

        final eligibleCards = LocalDB.studyCard.getEligibleDrillCards(
          'deck-1',
          'profile-1',
        );

        expect(eligibleCards.map((card) => card.id), ['study-2']);
        expect(LocalDB.fsrsCard.getEnrolledStudyCardIds('profile-1'), {
          'study-1',
        });
      },
    );
  });
}
