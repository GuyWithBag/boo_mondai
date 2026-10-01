import 'package:boo_mondai/lib.barrel.dart'
    show
        StudyCardsLocalDB,
        FsrsCardsLocalDB,
        DecksLocalDB,
        DeckListingsLocalDB,
        CardTemplatesLocalDB,
        ReviewSessionsLocalDB,
        ReviewLogsLocalDB,
        StreakLocalDB,
        CurrentProfileLocalDB,
        UserSettingsLocalDB,
        ProgressCheckpointLocalDB,
        SyncClientLocalDB,
        SyncDeletionLocalDB,
        TagLocalDB,
        DeckTagsLocalDB,
        CardTemplateTagsLocalDB,
        UserStudyCardTagsLocalDB,
        StudySessionSnapshotsLocalDB,
        SurveyResponsesLocalDB,
        CachedMediaLocalDB,
        NotificationsLocalDB,
        ProfilesLocalDB,
        ContentsLocalDB;

class LocalDB {
  static late final DecksLocalDB deck;
  static late final DeckListingsLocalDB deckListing;
  static late final CardTemplatesLocalDB cardTemplate;
  static late final StudyCardsLocalDB studyCard;
  static late final FsrsCardsLocalDB fsrsCard;
  static late final ReviewSessionsLocalDB reviewSession;
  static late final ReviewLogsLocalDB reviewLogs;
  // static late final StreakLocalDB streak;
  static late final StreakLocalDB streak;
  static late final CurrentProfileLocalDB currentProfile;
  static late final ProfilesLocalDB profiles;
  static late final UserSettingsLocalDB userSettings;
  static late final ProgressCheckpointLocalDB progressCheckpoint;
  static late final SyncClientLocalDB syncClient;
  static late final SyncDeletionLocalDB syncDeletion;
  static late final TagLocalDB tag;
  static late final DeckTagsLocalDB deckTag;
  static late final CardTemplateTagsLocalDB cardTemplateTag;
  static late final UserStudyCardTagsLocalDB userStudyCardTag;
  static late final StudySessionSnapshotsLocalDB studySessionSnapshot;
  static late final SurveyResponsesLocalDB surveyResponse;
  static late final CachedMediaLocalDB cachedMedias;
  static late final NotificationsLocalDB notifications;
  static late final ContentsLocalDB contents;

  static Future<void> init() async {
    currentProfile =
        await CurrentProfileLocalDB().init() as CurrentProfileLocalDB;
    profiles = await ProfilesLocalDB().init() as ProfilesLocalDB;
    deck = await DecksLocalDB().init() as DecksLocalDB;
    deckListing = await DeckListingsLocalDB().init() as DeckListingsLocalDB;
    cardTemplate = await CardTemplatesLocalDB().init() as CardTemplatesLocalDB;
    studyCard = await StudyCardsLocalDB().init() as StudyCardsLocalDB;
    fsrsCard = await FsrsCardsLocalDB().init() as FsrsCardsLocalDB;
    reviewSession =
        await ReviewSessionsLocalDB().init() as ReviewSessionsLocalDB;
    reviewLogs = await ReviewLogsLocalDB().init() as ReviewLogsLocalDB;
    streak = await StreakLocalDB().init() as StreakLocalDB;

    userSettings = await UserSettingsLocalDB().init() as UserSettingsLocalDB;
    progressCheckpoint =
        await ProgressCheckpointLocalDB().init() as ProgressCheckpointLocalDB;
    syncClient = await SyncClientLocalDB().init() as SyncClientLocalDB;
    syncDeletion = await SyncDeletionLocalDB().init() as SyncDeletionLocalDB;
    tag = await TagLocalDB().init() as TagLocalDB;
    deckTag = await DeckTagsLocalDB().init() as DeckTagsLocalDB;
    cardTemplateTag =
        await CardTemplateTagsLocalDB().init() as CardTemplateTagsLocalDB;
    userStudyCardTag =
        await UserStudyCardTagsLocalDB().init() as UserStudyCardTagsLocalDB;
    studySessionSnapshot =
        await StudySessionSnapshotsLocalDB().init()
            as StudySessionSnapshotsLocalDB;
    surveyResponse = await SurveyResponsesLocalDB().init();
    cachedMedias = await CachedMediaLocalDB().init() as CachedMediaLocalDB;
    notifications = await NotificationsLocalDB().init() as NotificationsLocalDB;
    contents = await ContentsLocalDB().init() as ContentsLocalDB;
  }

  static Future<void> clearAll() async {
    await deck.clear();
    await deckListing.clear();
    await cardTemplate.clear();
    await fsrsCard.clear();
    await reviewSession.clear();
    await reviewLogs.clear();
    await streak.clear();
    await userSettings.clear();
    await progressCheckpoint.clear();
    await syncClient.clear();
    await syncDeletion.clear();
    await tag.clear();
    await deckTag.clear();
    await cardTemplateTag.clear();
    await userStudyCardTag.clear();
    await studySessionSnapshot.clear();
    await surveyResponse.clear();
    await profiles.clear();
    await currentProfile.clear();
    await cachedMedias.clear();
    await notifications.clear();
    await contents.clear();
    currentProfile.getOrCreate();
  }
}
