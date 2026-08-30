// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vote.dto.dart';

class VoteMapper extends ClassMapperBase<Vote> {
  VoteMapper._();

  static VoteMapper? _instance;
  static VoteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VoteMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Vote';

  static String _$contentId(Vote v) => v.contentId;
  static const Field<Vote, String> _f$contentId =
      Field('contentId', _$contentId, key: r'content_id');
  static String _$profileId(Vote v) => v.profileId;
  static const Field<Vote, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');
  static DateTime _$createdAt(Vote v) => v.createdAt;
  static const Field<Vote, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static bool _$isPositive(Vote v) => v.isPositive;
  static const Field<Vote, bool> _f$isPositive =
      Field('isPositive', _$isPositive, key: r'is_positive');

  @override
  final MappableFields<Vote> fields = const {
    #contentId: _f$contentId,
    #profileId: _f$profileId,
    #createdAt: _f$createdAt,
    #isPositive: _f$isPositive,
  };

  static Vote _instantiate(DecodingData data) {
    return Vote(
        contentId: data.dec(_f$contentId),
        profileId: data.dec(_f$profileId),
        createdAt: data.dec(_f$createdAt),
        isPositive: data.dec(_f$isPositive));
  }

  @override
  final Function instantiate = _instantiate;

  static Vote fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Vote>(map);
  }

  static Vote fromJson(String json) {
    return ensureInitialized().decodeJson<Vote>(json);
  }
}

mixin VoteMappable {
  String toJson() {
    return VoteMapper.ensureInitialized().encodeJson<Vote>(this as Vote);
  }

  Map<String, dynamic> toMap() {
    return VoteMapper.ensureInitialized().encodeMap<Vote>(this as Vote);
  }

  VoteCopyWith<Vote, Vote, Vote> get copyWith =>
      _VoteCopyWithImpl<Vote, Vote>(this as Vote, $identity, $identity);
  @override
  String toString() {
    return VoteMapper.ensureInitialized().stringifyValue(this as Vote);
  }

  @override
  bool operator ==(Object other) {
    return VoteMapper.ensureInitialized().equalsValue(this as Vote, other);
  }

  @override
  int get hashCode {
    return VoteMapper.ensureInitialized().hashValue(this as Vote);
  }
}

extension VoteValueCopy<$R, $Out> on ObjectCopyWith<$R, Vote, $Out> {
  VoteCopyWith<$R, Vote, $Out> get $asVote =>
      $base.as((v, t, t2) => _VoteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VoteCopyWith<$R, $In extends Vote, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? contentId,
      String? profileId,
      DateTime? createdAt,
      bool? isPositive});
  VoteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VoteCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Vote, $Out>
    implements VoteCopyWith<$R, Vote, $Out> {
  _VoteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Vote> $mapper = VoteMapper.ensureInitialized();
  @override
  $R call(
          {String? contentId,
          String? profileId,
          DateTime? createdAt,
          bool? isPositive}) =>
      $apply(FieldCopyWithData({
        if (contentId != null) #contentId: contentId,
        if (profileId != null) #profileId: profileId,
        if (createdAt != null) #createdAt: createdAt,
        if (isPositive != null) #isPositive: isPositive
      }));
  @override
  Vote $make(CopyWithData data) => Vote(
      contentId: data.get(#contentId, or: $value.contentId),
      profileId: data.get(#profileId, or: $value.profileId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      isPositive: data.get(#isPositive, or: $value.isPositive));

  @override
  VoteCopyWith<$R2, Vote, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _VoteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
