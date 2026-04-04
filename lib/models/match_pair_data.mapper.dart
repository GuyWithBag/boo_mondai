// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_pair_data.dart';

class MatchPairDataMapper extends ClassMapperBase<MatchPairData> {
  MatchPairDataMapper._();

  static MatchPairDataMapper? _instance;
  static MatchPairDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchPairDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchPairData';

  static String _$term(MatchPairData v) => v.term;
  static const Field<MatchPairData, String> _f$term = Field('term', _$term);
  static String _$match(MatchPairData v) => v.match;
  static const Field<MatchPairData, String> _f$match = Field('match', _$match);

  @override
  final MappableFields<MatchPairData> fields = const {
    #term: _f$term,
    #match: _f$match,
  };

  static MatchPairData _instantiate(DecodingData data) {
    return MatchPairData(term: data.dec(_f$term), match: data.dec(_f$match));
  }

  @override
  final Function instantiate = _instantiate;

  static MatchPairData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchPairData>(map);
  }

  static MatchPairData fromJson(String json) {
    return ensureInitialized().decodeJson<MatchPairData>(json);
  }
}

mixin MatchPairDataMappable {
  String toJson() {
    return MatchPairDataMapper.ensureInitialized()
        .encodeJson<MatchPairData>(this as MatchPairData);
  }

  Map<String, dynamic> toMap() {
    return MatchPairDataMapper.ensureInitialized()
        .encodeMap<MatchPairData>(this as MatchPairData);
  }

  MatchPairDataCopyWith<MatchPairData, MatchPairData, MatchPairData>
      get copyWith => _MatchPairDataCopyWithImpl<MatchPairData, MatchPairData>(
          this as MatchPairData, $identity, $identity);
  @override
  String toString() {
    return MatchPairDataMapper.ensureInitialized()
        .stringifyValue(this as MatchPairData);
  }

  @override
  bool operator ==(Object other) {
    return MatchPairDataMapper.ensureInitialized()
        .equalsValue(this as MatchPairData, other);
  }

  @override
  int get hashCode {
    return MatchPairDataMapper.ensureInitialized()
        .hashValue(this as MatchPairData);
  }
}

extension MatchPairDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchPairData, $Out> {
  MatchPairDataCopyWith<$R, MatchPairData, $Out> get $asMatchPairData =>
      $base.as((v, t, t2) => _MatchPairDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchPairDataCopyWith<$R, $In extends MatchPairData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? term, String? match});
  MatchPairDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MatchPairDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchPairData, $Out>
    implements MatchPairDataCopyWith<$R, MatchPairData, $Out> {
  _MatchPairDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchPairData> $mapper =
      MatchPairDataMapper.ensureInitialized();
  @override
  $R call({String? term, String? match}) => $apply(FieldCopyWithData(
      {if (term != null) #term: term, if (match != null) #match: match}));
  @override
  MatchPairData $make(CopyWithData data) => MatchPairData(
      term: data.get(#term, or: $value.term),
      match: data.get(#match, or: $value.match));

  @override
  MatchPairDataCopyWith<$R2, MatchPairData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MatchPairDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
