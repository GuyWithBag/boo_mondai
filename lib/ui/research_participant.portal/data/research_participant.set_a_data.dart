import 'package:boo_mondai/lib.barrel.dart'
    show Deck, Profile, CardTemplate, LocalDB, ResearchParticipantData;

class ResearchParticipantSetAData implements ResearchParticipantData {
  static const idPrefix = 'research_participant_set_a_';
  static const dataDeckId = '${idPrefix}data_deck';

  @override
  Future<void> initialize(Profile profile) async {
    final deck = Deck(
      id: dataDeckId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profileId: profile.id,
      title: 'Set A Deck',
      isPremade: true,
      isEditable: false,
    );

    final templates = <CardTemplate>[];

    await LocalDB.deck.upsert(deck);
    await LocalDB.cardTemplate.upsertMany(templates);
  }
}
