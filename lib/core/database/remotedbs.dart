import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplatesRemoteDB,
        DrillSessionsRemoteDB,
        ProfilesRemoteDB,
        DecksRemoteDB,
        DeckListingsRemoteDB,
        CommentsRemoteDB,
        CommentEditLogsRemoteDB,
        ReviewsRemoteDB,
        ReviewLogsRemoteDB,
        ReviewEditLogsRemoteDB,
        UserSettingsRemoteDB,
        ReviewSessionsRemoteDB,
        DrillAnswersRemoteDB,
        FsrsCardsRemoteDB,
        LeaderboardEntriesRemoteDB,
        PublicBucketRemoteDB,
        PrivateBucketRemoteDB,
        SyncClientsRemoteDB,
        StreaksRemoteDB,
        StudyCardsRemoteDB,
        TagsRemoteDB,
        DeckTagsRemoteDB,
        CardTemplateTagsRemoteDB,
        UserStudyCardTagsRemoteDB,
        SurveysRemoteDB,
        SurveyPagesRemoteDB,
        SurveyBlocksRemoteDB,
        SurveyBlockOptionsRemoteDB,
        SurveyAssignmentsRemoteDB,
        SurveyResponsesRemoteDB,
        VotesRemoteDB,
        DeckFavoritesRemoteDB,
        ContentsRemoteDB;

class RemoteDB {
  static late final ProfilesRemoteDB profile;
  static late final DecksRemoteDB deck;
  static late final DeckListingsRemoteDB deckListing;
  static late final VotesRemoteDB deckVotes;
  static late final DeckFavoritesRemoteDB deckFavorites;
  static late final CommentsRemoteDB comments;
  static late final CommentEditLogsRemoteDB commentEditLogs;
  static late final ReviewsRemoteDB deckVoteReview;
  static late final ReviewLogsRemoteDB deckVoteReviewEditLog;
  static late final ReviewsRemoteDB reviews;
  static late final ReviewEditLogsRemoteDB reviewEditLogs;
  static late final UserSettingsRemoteDB userSettings;
  static late final CardTemplatesRemoteDB card;
  static late final StudyCardsRemoteDB studyCard;
  static late final ReviewSessionsRemoteDB reviewSession;
  static late final ReviewLogsRemoteDB reviewLogs;
  static late final FsrsCardsRemoteDB fsrsSync;
  static late final LeaderboardEntriesRemoteDB leaderboard;
  static late final PublicBucketRemoteDB publicBucket;
  static late final PrivateBucketRemoteDB privateBucket;
  static late final SyncClientsRemoteDB syncClient;
  static late final StreaksRemoteDB streak;
  static late final TagsRemoteDB tag;
  static late final DeckTagsRemoteDB deckTag;
  static late final CardTemplateTagsRemoteDB cardTemplateTag;
  static late final UserStudyCardTagsRemoteDB userStudyCardTag;
  static late final SurveysRemoteDB survey;
  static late final SurveyPagesRemoteDB surveyPage;
  static late final SurveyBlocksRemoteDB surveyBlock;
  static late final SurveyBlockOptionsRemoteDB surveyBlockOption;
  static late final SurveyAssignmentsRemoteDB surveyAssignment;
  static late final SurveyResponsesRemoteDB surveyResponse;
  static late final ContentsRemoteDB contents;

  static Future<void> init() async {
    profile = ProfilesRemoteDB();
    deck = DecksRemoteDB();
    deckListing = DeckListingsRemoteDB();
    deckVotes = VotesRemoteDB();
    deckFavorites = DeckFavoritesRemoteDB();
    comments = CommentsRemoteDB();
    contents = ContentsRemoteDB();
    commentEditLogs = CommentEditLogsRemoteDB();
    deckVoteReview = ReviewsRemoteDB();
    deckVoteReviewEditLog = ReviewLogsRemoteDB();
    reviews = ReviewsRemoteDB();
    reviewEditLogs = ReviewEditLogsRemoteDB();
    userSettings = UserSettingsRemoteDB();
    card = CardTemplatesRemoteDB();
    studyCard = StudyCardsRemoteDB();
    reviewSession = ReviewSessionsRemoteDB();
    reviewLogs = ReviewLogsRemoteDB();
    fsrsSync = FsrsCardsRemoteDB();
    leaderboard = LeaderboardEntriesRemoteDB();
    publicBucket = PublicBucketRemoteDB();
    privateBucket = PrivateBucketRemoteDB();
    syncClient = SyncClientsRemoteDB();
    streak = StreaksRemoteDB();
    tag = TagsRemoteDB();
    deckTag = DeckTagsRemoteDB();
    cardTemplateTag = CardTemplateTagsRemoteDB();
    userStudyCardTag = UserStudyCardTagsRemoteDB();
    survey = SurveysRemoteDB();
    surveyPage = SurveyPagesRemoteDB();
    surveyBlock = SurveyBlocksRemoteDB();
    surveyBlockOption = SurveyBlockOptionsRemoteDB();
    surveyAssignment = SurveyAssignmentsRemoteDB();
    surveyResponse = SurveyResponsesRemoteDB();
  }
}
