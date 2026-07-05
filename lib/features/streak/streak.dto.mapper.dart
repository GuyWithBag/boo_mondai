// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'streak.dto.dart';

class StreakMapper extends ClassMapperBase<Streak> {
  StreakMapper._();

  static StreakMapper? _instance;
  static StreakMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StreakMapper._());
      MutableEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Streak';

  static String _$id(Streak v) => v.id;
  static const Field<Streak, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(Streak v) => v.createdAt;
  static const Field<Streak, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(Streak v) => v.updatedAt;
  static const Field<Streak, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static String _$userId(Streak v) => v.userId;
  static const Field<Streak, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static int _$currentStreak(Streak v) => v.currentStreak;
  static const Field<Streak, int> _f$currentStreak =
      Field('currentStreak', _$currentStreak, key: r'current_streak');
  static int _$longestStreak(Streak v) => v.longestStreak;
  static const Field<Streak, int> _f$longestStreak =
      Field('longestStreak', _$longestStreak, key: r'longest_streak');
  static DateTime? _$lastActivityDate(Streak v) => v.lastActivityDate;
  static const Field<Streak, DateTime> _f$lastActivityDate = Field(
      'lastActivityDate', _$lastActivityDate,
      key: r'last_activity_date', opt: true);

  @override
  final MappableFields<Streak> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #userId: _f$userId,
    #currentStreak: _f$currentStreak,
    #longestStreak: _f$longestStreak,
    #lastActivityDate: _f$lastActivityDate,
  };

  static Streak _instantiate(DecodingData data) {
    return Streak(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        userId: data.dec(_f$userId),
        currentStreak: data.dec(_f$currentStreak),
        longestStreak: data.dec(_f$longestStreak),
        lastActivityDate: data.dec(_f$lastActivityDate));
  }

  @override
  final Function instantiate = _instantiate;

  static Streak fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Streak>(map);
  }

  static Streak fromJson(String json) {
    return ensureInitialized().decodeJson<Streak>(json);
  }
}

mixin StreakMappable {
  String toJson() {
    return StreakMapper.ensureInitialized().encodeJson<Streak>(this as Streak);
  }

  Map<String, dynamic> toMap() {
    return StreakMapper.ensureInitialized().encodeMap<Streak>(this as Streak);
  }

  StreakCopyWith<Streak, Streak, Streak> get copyWith =>
      _StreakCopyWithImpl<Streak, Streak>(this as Streak, $identity, $identity);
  @override
  String toString() {
    return StreakMapper.ensureInitialized().stringifyValue(this as Streak);
  }

  @override
  bool operator ==(Object other) {
    return StreakMapper.ensureInitialized().equalsValue(this as Streak, other);
  }

  @override
  int get hashCode {
    return StreakMapper.ensureInitialized().hashValue(this as Streak);
  }
}

extension StreakValueCopy<$R, $Out> on ObjectCopyWith<$R, Streak, $Out> {
  StreakCopyWith<$R, Streak, $Out> get $asStreak =>
      $base.as((v, t, t2) => _StreakCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StreakCopyWith<$R, $In extends Streak, $Out>
    implements MutableEntityCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? userId,
      int? currentStreak,
      int? longestStreak,
      DateTime? lastActivityDate});
  StreakCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StreakCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Streak, $Out>
    implements StreakCopyWith<$R, Streak, $Out> {
  _StreakCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Streak> $mapper = StreakMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? userId,
          int? currentStreak,
          int? longestStreak,
          Object? lastActivityDate = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (userId != null) #userId: userId,
        if (currentStreak != null) #currentStreak: currentStreak,
        if (longestStreak != null) #longestStreak: longestStreak,
        if (lastActivityDate != $none) #lastActivityDate: lastActivityDate
      }));
  @override
  Streak $make(CopyWithData data) => Streak(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      userId: data.get(#userId, or: $value.userId),
      currentStreak: data.get(#currentStreak, or: $value.currentStreak),
      longestStreak: data.get(#longestStreak, or: $value.longestStreak),
      lastActivityDate:
          data.get(#lastActivityDate, or: $value.lastActivityDate));

  @override
  StreakCopyWith<$R2, Streak, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _StreakCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
