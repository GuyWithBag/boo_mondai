// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_vote.dto.dart';

class DeckVoteMapper extends ClassMapperBase<DeckVote> {
  DeckVoteMapper._();

  static DeckVoteMapper? _instance;
  static DeckVoteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckVoteMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeckVote';

  static String _$deckId(DeckVote v) => v.deckId;
  static const Field<DeckVote, String> _f$deckId = Field(
    'deckId',
    _$deckId,
    key: r'deck_id',
  );
  static String _$userId(DeckVote v) => v.userId;
  static const Field<DeckVote, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static int _$voteValue(DeckVote v) => v.voteValue;
  static const Field<DeckVote, int> _f$voteValue = Field(
    'voteValue',
    _$voteValue,
    key: r'vote_value',
  );
  static DateTime _$createdAt(DeckVote v) => v.createdAt;
  static const Field<DeckVote, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(DeckVote v) => v.updatedAt;
  static const Field<DeckVote, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<DeckVote> fields = const {
    #deckId: _f$deckId,
    #userId: _f$userId,
    #voteValue: _f$voteValue,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static DeckVote _instantiate(DecodingData data) {
    return DeckVote(
      deckId: data.dec(_f$deckId),
      userId: data.dec(_f$userId),
      voteValue: data.dec(_f$voteValue),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeckVote fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckVote>(map);
  }

  static DeckVote fromJson(String json) {
    return ensureInitialized().decodeJson<DeckVote>(json);
  }
}

mixin DeckVoteMappable {
  String toJson() {
    return DeckVoteMapper.ensureInitialized().encodeJson<DeckVote>(
      this as DeckVote,
    );
  }

  Map<String, dynamic> toMap() {
    return DeckVoteMapper.ensureInitialized().encodeMap<DeckVote>(
      this as DeckVote,
    );
  }

  DeckVoteCopyWith<DeckVote, DeckVote, DeckVote> get copyWith =>
      _DeckVoteCopyWithImpl<DeckVote, DeckVote>(
        this as DeckVote,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DeckVoteMapper.ensureInitialized().stringifyValue(this as DeckVote);
  }

  @override
  bool operator ==(Object other) {
    return DeckVoteMapper.ensureInitialized().equalsValue(
      this as DeckVote,
      other,
    );
  }

  @override
  int get hashCode {
    return DeckVoteMapper.ensureInitialized().hashValue(this as DeckVote);
  }
}

extension DeckVoteValueCopy<$R, $Out> on ObjectCopyWith<$R, DeckVote, $Out> {
  DeckVoteCopyWith<$R, DeckVote, $Out> get $asDeckVote =>
      $base.as((v, t, t2) => _DeckVoteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckVoteCopyWith<$R, $In extends DeckVote, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? deckId,
    String? userId,
    int? voteValue,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  DeckVoteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckVoteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckVote, $Out>
    implements DeckVoteCopyWith<$R, DeckVote, $Out> {
  _DeckVoteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckVote> $mapper =
      DeckVoteMapper.ensureInitialized();
  @override
  $R call({
    String? deckId,
    String? userId,
    int? voteValue,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (deckId != null) #deckId: deckId,
      if (userId != null) #userId: userId,
      if (voteValue != null) #voteValue: voteValue,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  DeckVote $make(CopyWithData data) => DeckVote(
    deckId: data.get(#deckId, or: $value.deckId),
    userId: data.get(#userId, or: $value.userId),
    voteValue: data.get(#voteValue, or: $value.voteValue),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  DeckVoteCopyWith<$R2, DeckVote, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DeckVoteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
