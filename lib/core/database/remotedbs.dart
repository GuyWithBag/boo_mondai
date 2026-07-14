import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplatesRemoteDB,
        DrillSessionsRemoteDB,
        ProfilesRemoteDB,
        DecksRemoteDB,
        DeckListingsRemoteDB,
        DeckInteractionsRemoteDB,
        DeckCommentsRemoteDB,
        DeckCommentEditLogsRemoteDB,
        DeckVoteReviewsRemoteDB,
        DeckVoteReviewEditLogsRemoteDB,
        DeckVoteReviewCommentsRemoteDB,
        DeckVoteReviewCommentEditLogsRemoteDB,
        UserSettingsRemoteDB,
        ReviewSessionsRemoteDB,
        DrillAnswersRemoteDB,
        FsrsCardsRemoteDB,
        LeaderboardEntriesRemoteDB,
        ResearchRemoteDB,
        PublicBucketRemoteDB,
        PrivateBucketRemoteDB,
        StreaksRemoteDB,
        StudyCardsRemoteDB,
        TagsRemoteDB,
        DeckTagsRemoteDB,
        CardTemplateTagsRemoteDB,
        UserStudyCardTagsRemoteDB,
        ReviewLogsRemoteDB;

class RemoteDB {
  // ── Remote Data Sources ──────────────────────────
  static late final ProfilesRemoteDB profile;
  static late final DecksRemoteDB deck;
  static late final DeckListingsRemoteDB deckListing;
  static late final DeckInteractionsRemoteDB deckInteractions;
  static late final DeckCommentsRemoteDB deckComment;
  static late final DeckCommentEditLogsRemoteDB deckCommentEditLog;
  static late final DeckVoteReviewsRemoteDB deckVoteReview;
  static late final DeckVoteReviewEditLogsRemoteDB deckVoteReviewEditLog;
  static late final DeckVoteReviewCommentsRemoteDB deckVoteReviewComment;
  static late final DeckVoteReviewCommentEditLogsRemoteDB
  deckVoteReviewCommentEditLog;
  static late final UserSettingsRemoteDB userSettings;
  static late final CardTemplatesRemoteDB card;
  static late final StudyCardsRemoteDB studyCard;
  static late final DrillSessionsRemoteDB drill;
  static late final ReviewSessionsRemoteDB reviewSession;
  static late final ReviewLogsRemoteDB reviewLog;
  static late final DrillAnswersRemoteDB drillAnswer;
  static late final FsrsCardsRemoteDB fsrsSync;
  static late final LeaderboardEntriesRemoteDB leaderboard;
  static late final ResearchRemoteDB research;
  static late final PublicBucketRemoteDB publicBucket;
  static late final PrivateBucketRemoteDB privateBucket;
  static late final StreaksRemoteDB streak;
  static late final TagsRemoteDB tag;
  static late final DeckTagsRemoteDB deckTag;
  static late final CardTemplateTagsRemoteDB cardTemplateTag;
  static late final UserStudyCardTagsRemoteDB userStudyCardTag;

  static Future<void> init() async {
    profile = ProfilesRemoteDB();
    deck = DecksRemoteDB();
    deckListing = DeckListingsRemoteDB();
    deckInteractions = DeckInteractionsRemoteDB();
    deckComment = DeckCommentsRemoteDB();
    deckCommentEditLog = DeckCommentEditLogsRemoteDB();
    deckVoteReview = DeckVoteReviewsRemoteDB();
    deckVoteReviewEditLog = DeckVoteReviewEditLogsRemoteDB();
    deckVoteReviewComment = DeckVoteReviewCommentsRemoteDB();
    deckVoteReviewCommentEditLog = DeckVoteReviewCommentEditLogsRemoteDB();
    userSettings = UserSettingsRemoteDB();
    card = CardTemplatesRemoteDB();
    studyCard = StudyCardsRemoteDB();
    drill = DrillSessionsRemoteDB();
    reviewSession = ReviewSessionsRemoteDB();
    reviewLog = ReviewLogsRemoteDB();
    drillAnswer = DrillAnswersRemoteDB();
    fsrsSync = FsrsCardsRemoteDB();
    leaderboard = LeaderboardEntriesRemoteDB();
    research = ResearchRemoteDB();
    publicBucket = PublicBucketRemoteDB();
    privateBucket = PrivateBucketRemoteDB();
    streak = StreaksRemoteDB();
    tag = TagsRemoteDB();
    deckTag = DeckTagsRemoteDB();
    cardTemplateTag = CardTemplateTagsRemoteDB();
    userStudyCardTag = UserStudyCardTagsRemoteDB();
  }
}
