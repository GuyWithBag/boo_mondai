// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'leaderboard_entry.dart';

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
      Field('userId', _$userId);
  static String _$userName(LeaderboardEntry v) => v.userName;
  static const Field<LeaderboardEntry, String> _f$userName =
      Field('userName', _$userName);
  static String? _$targetLanguage(LeaderboardEntry v) => v.targetLanguage;
  static const Field<LeaderboardEntry, String> _f$targetLanguage =
      Field('targetLanguage', _$targetLanguage, opt: true);
  static int _$drillScore(LeaderboardEntry v) => v.drillScore;
  static const Field<LeaderboardEntry, int> _f$drillScore =
      Field('drillScore', _$drillScore);
  static int _$reviewCount(LeaderboardEntry v) => v.reviewCount;
  static const Field<LeaderboardEntry, int> _f$reviewCount =
      Field('reviewCount', _$reviewCount);
  static int _$currentStreak(LeaderboardEntry v) => v.currentStreak;
  static const Field<LeaderboardEntry, int> _f$currentStreak =
      Field('currentStreak', _$currentStreak);

  @override
  final MappableFields<LeaderboardEntry> fields = const {
    #userId: _f$userId,
    #userName: _f$userName,
    #targetLanguage: _f$targetLanguage,
    #drillScore: _f$drillScore,
    #reviewCount: _f$reviewCount,
    #currentStreak: _f$currentStreak,
  };

  static LeaderboardEntry _instantiate(DecodingData data) {
    return LeaderboardEntry(
        userId: data.dec(_f$userId),
        userName: data.dec(_f$userName),
        targetLanguage: data.dec(_f$targetLanguage),
        drillScore: data.dec(_f$drillScore),
        reviewCount: data.dec(_f$reviewCount),
        currentStreak: data.dec(_f$currentStreak));
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
  $R call(
      {String? userId,
      String? userName,
      String? targetLanguage,
      int? drillScore,
      int? reviewCount,
      int? currentStreak});
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
  $R call(
          {String? userId,
          String? userName,
          Object? targetLanguage = $none,
          int? drillScore,
          int? reviewCount,
          int? currentStreak}) =>
      $apply(FieldCopyWithData({
        if (userId != null) #userId: userId,
        if (userName != null) #userName: userName,
        if (targetLanguage != $none) #targetLanguage: targetLanguage,
        if (drillScore != null) #drillScore: drillScore,
        if (reviewCount != null) #reviewCount: reviewCount,
        if (currentStreak != null) #currentStreak: currentStreak
      }));
  @override
  LeaderboardEntry $make(CopyWithData data) => LeaderboardEntry(
      userId: data.get(#userId, or: $value.userId),
      userName: data.get(#userName, or: $value.userName),
      targetLanguage: data.get(#targetLanguage, or: $value.targetLanguage),
      drillScore: data.get(#drillScore, or: $value.drillScore),
      reviewCount: data.get(#reviewCount, or: $value.reviewCount),
      currentStreak: data.get(#currentStreak, or: $value.currentStreak));

  @override
  LeaderboardEntryCopyWith<$R2, LeaderboardEntry, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LeaderboardEntryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
