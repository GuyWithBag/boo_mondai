import 'dart:io';

import 'package:boo_mondai/core/hive/hive_registrar.g.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        LocalDB,
        SessionMode,
        StudyCard,
        StudySessionCompletedResults,
        ViewStudySessionResultController;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'boo_mondai_view_study_session_result_test_',
    );
    Hive.init(hiveDirectory.path);
    Hive.registerAdapters();
    await LocalDB.init();
  });

  setUp(() async {
    await LocalDB.clearAll();
    await LocalDB.studyCard.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('labels drill action with remaining next-batch cards', () async {
    final profile = LocalDB.currentProfile.getOrCreate();
    final now = DateTime.utc(2026);
    await LocalDB.studyCard.upsertMany([
      for (var index = 0; index < 20; index += 1)
        StudyCard(
          id: 'study-$index',
          createdAt: now,
          updatedAt: now,
          templateId: 'template-$index',
          deckId: 'deck-1',
        ),
    ]);
    await LocalDB.studySessionCompletedResults.upsert(
      StudySessionCompletedResults(
        profileId: profile.id,
        sessionId: 'session-1',
        deckId: 'deck-1',
        mode: SessionMode.drill,
        startedAt: now,
        snapshots: const [],
        fsrsCards: const [],
        fsrsLogs: const [],
        correctCount: 0,
        cardCount: 10,
      ),
    );

    final controller = ViewStudySessionResultController(sessionId: 'session-1');
    addTearDown(controller.dispose);

    expect(controller.remainingDrillCardCount.value, 20);
    expect(controller.canContinueNextBatch.value, isTrue);
    expect(controller.hasPrimaryAction.value, isTrue);
    expect(controller.primaryActionLabel.value, 'Continue Next Batch (20)');
  });
}
