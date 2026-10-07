import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, Deck, LocalDB, Profile, ResearchParticipantData;

class ResearchParticipantJapaneseSetBData extends ResearchParticipantData {
  static const idPrefix = 'research_participant_japanese_set_b_';
  static const dataDeckId = '${idPrefix}data_deck';
  static const attachmentAssetDirectory =
      'assets/temporary/japanese_set_b_attachments/';

  @override
  String get participantDeckId => dataDeckId;

  @override
  Future<void> initialize(Profile profile) async {
    final deck = Deck(
      id: dataDeckId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profileId: profile.id,
      title: 'Japanese Set B',
      isPremade: true,
      isEditable: false,
    );

    final templates = <CardTemplate>[];

    await LocalDB.deck.upsert(deck);
    await LocalDB.cardTemplate.upsertMany(templates);
    await copyAttachmentAssets(
      assetDirectory: attachmentAssetDirectory,
      deckTitle: deck.title,
    );
  }
}
