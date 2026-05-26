// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'study_session.dto.dart';

class StudySessionMapper extends ClassMapperBase<StudySession> {
  StudySessionMapper._();

  static StudySessionMapper? _instance;
  static StudySessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudySessionMapper._());
      CachedProfileMapper.ensureInitialized();
      DeckMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StudySession';

  static String _$id(StudySession v) => v.id;
  static const Field<StudySession, String> _f$id = Field('id', _$id);
  static String _$userId(StudySession v) => v.userId;
  static const Field<StudySession, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String? _$deckId(StudySession v) => v.deckId;
  static const Field<StudySession, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id', opt: true);
  static DateTime _$startedAt(StudySession v) => v.startedAt;
  static const Field<StudySession, DateTime> _f$startedAt =
      Field('startedAt', _$startedAt, key: r'started_at');
  static DateTime? _$completedAt(StudySession v) => v.completedAt;
  static const Field<StudySession, DateTime> _f$completedAt =
      Field('completedAt', _$completedAt, key: r'completed_at', opt: true);
  static CachedProfile? _$userProfile(StudySession v) => v.userProfile;
  static const Field<StudySession, CachedProfile> _f$userProfile =
      Field('userProfile', _$userProfile, key: r'user_profile', opt: true);
  static Deck? _$deck(StudySession v) => v.deck;
  static const Field<StudySession, Deck> _f$deck =
      Field('deck', _$deck, opt: true);

  @override
  final MappableFields<StudySession> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #deckId: _f$deckId,
    #startedAt: _f$startedAt,
    #completedAt: _f$completedAt,
    #userProfile: _f$userProfile,
    #deck: _f$deck,
  };

  static StudySession _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('StudySession');
  }

  @override
  final Function instantiate = _instantiate;

  static StudySession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudySession>(map);
  }

  static StudySession fromJson(String json) {
    return ensureInitialized().decodeJson<StudySession>(json);
  }
}

mixin StudySessionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  StudySessionCopyWith<StudySession, StudySession, StudySession> get copyWith;
}

abstract class StudySessionCopyWith<$R, $In extends StudySession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile;
  DeckCopyWith<$R, Deck, Deck>? get deck;
  $R call(
      {String? id,
      String? userId,
      String? deckId,
      DateTime? startedAt,
      DateTime? completedAt,
      CachedProfile? userProfile,
      Deck? deck});
  StudySessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}
