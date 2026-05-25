import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class DeckDownloadsOnlineService {
  DeckDownloadsOnlineService({
    DecksRemoteDB? decksRemoteDB,
    CardTemplatesRemoteDB? cardTemplatesRemoteDB,
  }) : _decksRemoteDB = decksRemoteDB ?? DecksRemoteDB(),
       _cardTemplatesRemoteDB =
           cardTemplatesRemoteDB ?? CardTemplatesRemoteDB();

  final DecksRemoteDB _decksRemoteDB;
  final CardTemplatesRemoteDB _cardTemplatesRemoteDB;

  Future<Deck> downloadDeck(Deck sourceDeck) async {
    final existingDeck = _findExistingDownload(sourceDeck.id);
    if (existingDeck != null) return existingDeck;

    final remoteDeck =
        await _decksRemoteDB.selectById(sourceDeck.id) ?? sourceDeck;
    final currentProfile = LocalDB.profile.getOrCreate();
    final now = DateTime.now();
    final localDeckId = uuid.v7();
    final localDeck = remoteDeck.copyWith(
      id: localDeckId,
      userId: currentProfile.id,
      sourceDeckId: remoteDeck.id,
      visibilityState: VisibilityState.private,
      isPublished: false,
      isEditable: true,
      createdAt: now,
      updatedAt: now,
      userProfile: null,
      listing: null,
    );

    final remoteTemplates = await _cardTemplatesRemoteDB.selectMany(
      filters: {'deck_id': remoteDeck.id},
      orderBy: 'sort_order',
      ascending: true,
    );
    final templateIdMap = {
      for (final template in remoteTemplates) template.id: uuid.v7(),
    };
    final localTemplates = [
      for (final template in remoteTemplates)
        _copyTemplate(
          template,
          localDeckId: localDeckId,
          localTemplateId: templateIdMap[template.id]!,
          templateIdMap: templateIdMap,
          now: now,
        ),
    ];
    final reviewCards = _buildReviewCards(
      localDeckId: localDeckId,
      templates: localTemplates,
    );

    await LocalDB.deck.upsert(localDeck);
    await LocalDB.cardTemplate.upsertMany(localTemplates);
    await LocalDB.reviewCard.upsertMany(reviewCards);

    return localDeck;
  }

  Deck? _findExistingDownload(String sourceDeckId) {
    final matches = LocalDB.deck.selectMany(
      where: (deck) => deck.sourceDeckId == sourceDeckId,
      limit: 1,
    );
    return matches.isEmpty ? null : matches.first;
  }

  CardTemplate _copyTemplate(
    CardTemplate template, {
    required String localDeckId,
    required String localTemplateId,
    required Map<String, String> templateIdMap,
    required DateTime now,
  }) {
    return switch (template) {
      FlashcardTemplate t => FlashcardTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        frontText: t.frontText,
        backText: t.backText,
        frontImageUrl: t.frontImageUrl,
        backImageUrl: t.backImageUrl,
        frontAudioUrl: t.frontAudioUrl,
        backAudioUrl: t.backAudioUrl,
        cardType: t.cardType,
      ),
      IdentificationTemplate t => IdentificationTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        promptText: t.promptText,
        acceptedAnswers: t.acceptedAnswers,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      MultipleChoiceTemplate t => MultipleChoiceTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        questionPrompt: t.questionPrompt,
        options: [
          for (final option in t.options)
            MultipleChoiceOption(
              id: uuid.v7(),
              templateId: localTemplateId,
              optionText: option.optionText,
              isCorrect: option.isCorrect,
              displayOrder: option.displayOrder,
            ),
        ],
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        segments: [
          for (final segment in t.segments)
            FillInTheBlankSegment(
              id: uuid.v7(),
              cardId: localTemplateId,
              fullText: segment.fullText,
              blankStart: segment.blankStart,
              blankEnd: segment.blankEnd,
              correctAnswer: segment.correctAnswer,
            ),
        ],
      ),
      MatchMadnessTemplate t => MatchMadnessTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        pairs: [
          for (final pair in t.pairs)
            MatchMadnessPair(
              id: uuid.v7(),
              templateId: localTemplateId,
              sourceTemplateId: pair.sourceTemplateId == null
                  ? null
                  : templateIdMap[pair.sourceTemplateId] ??
                        pair.sourceTemplateId,
              term: pair.term,
              match: pair.match,
              isAutoPicked: pair.isAutoPicked,
              displayOrder: pair.displayOrder,
            ),
        ],
      ),
      WordScrambleTemplate t => WordScrambleTemplate(
        id: localTemplateId,
        deckId: localDeckId,
        sortOrder: t.sortOrder,
        createdAt: now,
        updatedAt: now,
        sourceTemplateId: t.id,
        tags: t.tags,
        sentenceToScramble: t.sentenceToScramble,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      _ => throw UnsupportedError(
        'Unsupported card template type: ${template.runtimeType}',
      ),
    };
  }

  List<ReviewCard> _buildReviewCards({
    required String localDeckId,
    required List<CardTemplate> templates,
  }) {
    final reviewCards = <ReviewCard>[];

    for (final template in templates) {
      if (template is FlashcardTemplate) {
        final needsNormal = template.cardType != CardType.reversed;
        final needsReversed = template.cardType != CardType.normal;

        if (needsNormal) {
          reviewCards.add(
            ReviewCard(
              id: uuid.v7(),
              deckId: localDeckId,
              templateId: template.id,
              isReversed: false,
            ),
          );
        }
        if (needsReversed) {
          reviewCards.add(
            ReviewCard(
              id: uuid.v7(),
              deckId: localDeckId,
              templateId: template.id,
              isReversed: true,
            ),
          );
        }
      } else {
        reviewCards.add(
          ReviewCard(
            id: uuid.v7(),
            deckId: localDeckId,
            templateId: template.id,
            isReversed: false,
          ),
        );
      }
    }

    return reviewCards;
  }
}
