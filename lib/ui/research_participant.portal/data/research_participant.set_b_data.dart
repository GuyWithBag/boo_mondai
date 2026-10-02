import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, Deck, LocalDB, Profile, ResearchParticipantData;

class ResearchParticipantSetBData implements ResearchParticipantData {
  static const idPrefix = 'research_participant_set_b_';
  static const dataDeckId = '${idPrefix}data_deck';

  @override
  Future<void> initialize(Profile profile) async {
    final deck = Deck(
      id: dataDeckId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profileId: profile.id,
      title: 'Set B Deck',
      isPremade: true,
      isEditable: false,
    );

    final templates = <CardTemplate>[];

    await LocalDB.deck.upsert(deck);
    await LocalDB.cardTemplate.upsertMany(templates);
  }
}
