import 'package:boo_mondai/lib.barrel.dart'
    show
        StudyCardsLocalDB,
        FsrsCardsLocalDB,
        DecksLocalDB,
        DeckListingsLocalDB,
        CardTemplatesLocalDB,
        DrillSessionsLocalDB,
        ReviewSessionsLocalDB,
        DrillAnswersLocalDB,
        ReviewLogsLocalDB,
        StreakLocalDB,
        ProfileLocalDB,
        CachedProfileLocalDB,
        ImportExportBackupsLocalDB,
        UserSettingsLocalDB,
        ProgressCheckpointLocalDB,
        StoredMediasLocalDB,
        StudySessionFlowsLocalDB,
        StudySessionStepRecordsLocalDB;

class LocalDB {
  static late final DecksLocalDB deck;
  static late final DeckListingsLocalDB deckListing;
  static late final CardTemplatesLocalDB cardTemplate;
  static late final StudyCardsLocalDB studyCard;
  static late final FsrsCardsLocalDB fsrsCard;
  static late final DrillSessionsLocalDB drillSession;
  static late final ReviewSessionsLocalDB reviewSession;
  static late final DrillAnswersLocalDB drillAnswer;
  static late final ReviewLogsLocalDB reviewLog;
  // static late final StreakLocalDB streak;
  static late final StreakLocalDB streak;
  static late final ProfileLocalDB profile;
  static late final CachedProfileLocalDB cachedProfile;
  static late final ImportExportBackupsLocalDB importExportBackup;
  static late final UserSettingsLocalDB userSettings;
  static late final ProgressCheckpointLocalDB progressCheckpoint;
  static late final StoredMediasLocalDB storedMedia;
  static late final StudySessionFlowsLocalDB studySessionFlow;
  static late final StudySessionStepRecordsLocalDB studySessionStepRecord;

  static Future<void> init() async {
    profile = await ProfileLocalDB().init() as ProfileLocalDB;
    cachedProfile = await CachedProfileLocalDB().init() as CachedProfileLocalDB;
    deck = await DecksLocalDB().init() as DecksLocalDB;
    deckListing = await DeckListingsLocalDB().init() as DeckListingsLocalDB;
    cardTemplate = await CardTemplatesLocalDB().init() as CardTemplatesLocalDB;
    studyCard = await StudyCardsLocalDB().init() as StudyCardsLocalDB;
    fsrsCard = await FsrsCardsLocalDB().init() as FsrsCardsLocalDB;
    drillSession = await DrillSessionsLocalDB().init() as DrillSessionsLocalDB;
    reviewSession =
        await ReviewSessionsLocalDB().init() as ReviewSessionsLocalDB;
    reviewLog = await ReviewLogsLocalDB().init() as ReviewLogsLocalDB;
    drillAnswer = await DrillAnswersLocalDB().init() as DrillAnswersLocalDB;
    streak = await StreakLocalDB().init() as StreakLocalDB;
    importExportBackup =
        await ImportExportBackupsLocalDB().init() as ImportExportBackupsLocalDB;
    userSettings = await UserSettingsLocalDB().init() as UserSettingsLocalDB;
    progressCheckpoint =
        await ProgressCheckpointLocalDB().init() as ProgressCheckpointLocalDB;
    storedMedia = await StoredMediasLocalDB().init() as StoredMediasLocalDB;
    studySessionFlow =
        await StudySessionFlowsLocalDB().init() as StudySessionFlowsLocalDB;
    studySessionStepRecord =
        await StudySessionStepRecordsLocalDB().init()
            as StudySessionStepRecordsLocalDB;
  }

  static Future<void> clearAll() async {
    await deck.clear();
    await deckListing.clear();
    await cardTemplate.clear();
    await fsrsCard.clear();
    await drillSession.clear();
    await reviewSession.clear();
    await drillAnswer.clear();
    await reviewLog.clear();
    await streak.clear();
    await importExportBackup.clear();
    await userSettings.clear();
    await progressCheckpoint.clear();
    await storedMedia.clear();
    await studySessionFlow.clear();
    await studySessionStepRecord.clear();
    await cachedProfile.clear();
    await profile.clear();
    profile.getOrCreate();
  }
}
