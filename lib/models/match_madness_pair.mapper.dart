// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_madness_pair.dart';

class MatchMadnessPairMapper extends ClassMapperBase<MatchMadnessPair> {
  MatchMadnessPairMapper._();

  static MatchMadnessPairMapper? _instance;
  static MatchMadnessPairMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchMadnessPairMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchMadnessPair';

  static String _$id(MatchMadnessPair v) => v.id;
  static const Field<MatchMadnessPair, String> _f$id = Field('id', _$id);
  static String _$templateId(MatchMadnessPair v) => v.templateId;
  static const Field<MatchMadnessPair, String> _f$templateId =
      Field('templateId', _$templateId);
  static String? _$sourceTemplateId(MatchMadnessPair v) => v.sourceTemplateId;
  static const Field<MatchMadnessPair, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);
  static String _$term(MatchMadnessPair v) => v.term;
  static const Field<MatchMadnessPair, String> _f$term = Field('term', _$term);
  static String _$match(MatchMadnessPair v) => v.match;
  static const Field<MatchMadnessPair, String> _f$match =
      Field('match', _$match);
  static bool _$isAutoPicked(MatchMadnessPair v) => v.isAutoPicked;
  static const Field<MatchMadnessPair, bool> _f$isAutoPicked =
      Field('isAutoPicked', _$isAutoPicked, opt: true, def: false);
  static int _$displayOrder(MatchMadnessPair v) => v.displayOrder;
  static const Field<MatchMadnessPair, int> _f$displayOrder =
      Field('displayOrder', _$displayOrder, opt: true, def: 0);

  @override
  final MappableFields<MatchMadnessPair> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #sourceTemplateId: _f$sourceTemplateId,
    #term: _f$term,
    #match: _f$match,
    #isAutoPicked: _f$isAutoPicked,
    #displayOrder: _f$displayOrder,
  };

  static MatchMadnessPair _instantiate(DecodingData data) {
    return MatchMadnessPair(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        term: data.dec(_f$term),
        match: data.dec(_f$match),
        isAutoPicked: data.dec(_f$isAutoPicked),
        displayOrder: data.dec(_f$displayOrder));
  }

  @override
  final Function instantiate = _instantiate;

  static MatchMadnessPair fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchMadnessPair>(map);
  }

  static MatchMadnessPair fromJson(String json) {
    return ensureInitialized().decodeJson<MatchMadnessPair>(json);
  }
}

mixin MatchMadnessPairMappable {
  String toJson() {
    return MatchMadnessPairMapper.ensureInitialized()
        .encodeJson<MatchMadnessPair>(this as MatchMadnessPair);
  }

  Map<String, dynamic> toMap() {
    return MatchMadnessPairMapper.ensureInitialized()
        .encodeMap<MatchMadnessPair>(this as MatchMadnessPair);
  }

  MatchMadnessPairCopyWith<MatchMadnessPair, MatchMadnessPair, MatchMadnessPair>
      get copyWith =>
          _MatchMadnessPairCopyWithImpl<MatchMadnessPair, MatchMadnessPair>(
              this as MatchMadnessPair, $identity, $identity);
  @override
  String toString() {
    return MatchMadnessPairMapper.ensureInitialized()
        .stringifyValue(this as MatchMadnessPair);
  }

  @override
  bool operator ==(Object other) {
    return MatchMadnessPairMapper.ensureInitialized()
        .equalsValue(this as MatchMadnessPair, other);
  }

  @override
  int get hashCode {
    return MatchMadnessPairMapper.ensureInitialized()
        .hashValue(this as MatchMadnessPair);
  }
}

extension MatchMadnessPairValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchMadnessPair, $Out> {
  MatchMadnessPairCopyWith<$R, MatchMadnessPair, $Out>
      get $asMatchMadnessPair => $base
          .as((v, t, t2) => _MatchMadnessPairCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchMadnessPairCopyWith<$R, $In extends MatchMadnessPair, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? templateId,
      String? sourceTemplateId,
      String? term,
      String? match,
      bool? isAutoPicked,
      int? displayOrder});
  MatchMadnessPairCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MatchMadnessPairCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchMadnessPair, $Out>
    implements MatchMadnessPairCopyWith<$R, MatchMadnessPair, $Out> {
  _MatchMadnessPairCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchMadnessPair> $mapper =
      MatchMadnessPairMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? templateId,
          Object? sourceTemplateId = $none,
          String? term,
          String? match,
          bool? isAutoPicked,
          int? displayOrder}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (term != null) #term: term,
        if (match != null) #match: match,
        if (isAutoPicked != null) #isAutoPicked: isAutoPicked,
        if (displayOrder != null) #displayOrder: displayOrder
      }));
  @override
  MatchMadnessPair $make(CopyWithData data) => MatchMadnessPair(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      term: data.get(#term, or: $value.term),
      match: data.get(#match, or: $value.match),
      isAutoPicked: data.get(#isAutoPicked, or: $value.isAutoPicked),
      displayOrder: data.get(#displayOrder, or: $value.displayOrder));

  @override
  MatchMadnessPairCopyWith<$R2, MatchMadnessPair, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MatchMadnessPairCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
