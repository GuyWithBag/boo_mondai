// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'leaderboard_entry.dto.dart';

class LeaderboardEntryMapper extends ClassMapperBase<LeaderboardEntry> {
  LeaderboardEntryMapper._();

  static LeaderboardEntryMapper? _instance;
  static LeaderboardEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LeaderboardEntryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LeaderboardEntry';

  static String _$userId(LeaderboardEntry v) => v.userId;
  static const Field<LeaderboardEntry, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static int _$drillScore(LeaderboardEntry v) => v.drillScore;
  static const Field<LeaderboardEntry, int> _f$drillScore =
      Field('drillScore', _$drillScore, key: r'drill_score');
  static int _$reviewCount(LeaderboardEntry v) => v.reviewCount;
  static const Field<LeaderboardEntry, int> _f$reviewCount =
      Field('reviewCount', _$reviewCount, key: r'review_count');

  @override
  final MappableFields<LeaderboardEntry> fields = const {
    #userId: _f$userId,
    #drillScore: _f$drillScore,
    #reviewCount: _f$reviewCount,
  };

  static LeaderboardEntry _instantiate(DecodingData data) {
    return LeaderboardEntry(
        userId: data.dec(_f$userId),
        drillScore: data.dec(_f$drillScore),
        reviewCount: data.dec(_f$reviewCount));
  }

  @override
  final Function instantiate = _instantiate;

  static LeaderboardEntry fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LeaderboardEntry>(map);
  }

  static LeaderboardEntry fromJson(String json) {
    return ensureInitialized().decodeJson<LeaderboardEntry>(json);
  }
}

mixin LeaderboardEntryMappable {
  String toJson() {
    return LeaderboardEntryMapper.ensureInitialized()
        .encodeJson<LeaderboardEntry>(this as LeaderboardEntry);
  }

  Map<String, dynamic> toMap() {
    return LeaderboardEntryMapper.ensureInitialized()
        .encodeMap<LeaderboardEntry>(this as LeaderboardEntry);
  }

  LeaderboardEntryCopyWith<LeaderboardEntry, LeaderboardEntry, LeaderboardEntry>
      get copyWith =>
          _LeaderboardEntryCopyWithImpl<LeaderboardEntry, LeaderboardEntry>(
              this as LeaderboardEntry, $identity, $identity);
  @override
  String toString() {
    return LeaderboardEntryMapper.ensureInitialized()
        .stringifyValue(this as LeaderboardEntry);
  }

  @override
  bool operator ==(Object other) {
    return LeaderboardEntryMapper.ensureInitialized()
        .equalsValue(this as LeaderboardEntry, other);
  }

  @override
  int get hashCode {
    return LeaderboardEntryMapper.ensureInitialized()
        .hashValue(this as LeaderboardEntry);
  }
}

extension LeaderboardEntryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LeaderboardEntry, $Out> {
  LeaderboardEntryCopyWith<$R, LeaderboardEntry, $Out>
      get $asLeaderboardEntry => $base
          .as((v, t, t2) => _LeaderboardEntryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LeaderboardEntryCopyWith<$R, $In extends LeaderboardEntry, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, int? drillScore, int? reviewCount});
  LeaderboardEntryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _LeaderboardEntryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LeaderboardEntry, $Out>
    implements LeaderboardEntryCopyWith<$R, LeaderboardEntry, $Out> {
  _LeaderboardEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LeaderboardEntry> $mapper =
      LeaderboardEntryMapper.ensureInitialized();
  @override
  $R call({String? userId, int? drillScore, int? reviewCount}) =>
      $apply(FieldCopyWithData({
        if (userId != null) #userId: userId,
        if (drillScore != null) #drillScore: drillScore,
        if (reviewCount != null) #reviewCount: reviewCount
      }));
  @override
  LeaderboardEntry $make(CopyWithData data) => LeaderboardEntry(
      userId: data.get(#userId, or: $value.userId),
      drillScore: data.get(#drillScore, or: $value.drillScore),
      reviewCount: data.get(#reviewCount, or: $value.reviewCount));

  @override
  LeaderboardEntryCopyWith<$R2, LeaderboardEntry, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LeaderboardEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
