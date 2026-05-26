import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplatesRemoteDB,
        DrillSessionsRemoteDB,
        ProfilesRemoteDB,
        DecksRemoteDB,
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
        StorageRemoteDB,
        StreaksRemoteDB;

class RemoteDB {
  // ── Remote Data Sources ──────────────────────────
  static late final ProfilesRemoteDB profile;
  static late final DecksRemoteDB deck;
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
  static late final DrillSessionsRemoteDB drill;
  static late final ReviewSessionsRemoteDB reviewSession;
  static late final DrillAnswersRemoteDB drillAnswer;
  static late final FsrsCardsRemoteDB fsrsSync;
  static late final LeaderboardEntriesRemoteDB leaderboard;
  static late final ResearchRemoteDB research;
  static late final StorageRemoteDB storage;
  static late final StreaksRemoteDB streak;

  static Future<void> init() async {
    profile = ProfilesRemoteDB();
    deck = DecksRemoteDB();
    deckInteractions = DeckInteractionsRemoteDB();
    deckComment = DeckCommentsRemoteDB();
    deckCommentEditLog = DeckCommentEditLogsRemoteDB();
    deckVoteReview = DeckVoteReviewsRemoteDB();
    deckVoteReviewEditLog = DeckVoteReviewEditLogsRemoteDB();
    deckVoteReviewComment = DeckVoteReviewCommentsRemoteDB();
    deckVoteReviewCommentEditLog = DeckVoteReviewCommentEditLogsRemoteDB();
    userSettings = UserSettingsRemoteDB();
    card = CardTemplatesRemoteDB();
    drill = DrillSessionsRemoteDB();
    reviewSession = ReviewSessionsRemoteDB();
    drillAnswer = DrillAnswersRemoteDB();
    fsrsSync = FsrsCardsRemoteDB();
    leaderboard = LeaderboardEntriesRemoteDB();
    research = ResearchRemoteDB();
    storage = StorageRemoteDB();
    streak = StreaksRemoteDB();
  }
}
