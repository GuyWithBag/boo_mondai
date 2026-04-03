// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_madness_template.dart';

class MatchMadnessTemplateMapper
    extends SubClassMapperBase<MatchMadnessTemplate> {
  MatchMadnessTemplateMapper._();

  static MatchMadnessTemplateMapper? _instance;
  static MatchMadnessTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchMadnessTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
      MatchMadnessPairMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MatchMadnessTemplate';

  static String _$id(MatchMadnessTemplate v) => v.id;
  static const Field<MatchMadnessTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(MatchMadnessTemplate v) => v.deckId;
  static const Field<MatchMadnessTemplate, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$sortOrder(MatchMadnessTemplate v) => v.sortOrder;
  static const Field<MatchMadnessTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(MatchMadnessTemplate v) => v.createdAt;
  static const Field<MatchMadnessTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceTemplateId(MatchMadnessTemplate v) =>
      v.sourceTemplateId;
  static const Field<MatchMadnessTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);
  static List<MatchMadnessPair> _$pairs(MatchMadnessTemplate v) => v.pairs;
  static const Field<MatchMadnessTemplate, List<MatchMadnessPair>> _f$pairs =
      Field('pairs', _$pairs);

  @override
  final MappableFields<MatchMadnessTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceTemplateId: _f$sourceTemplateId,
    #pairs: _f$pairs,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'match_madness';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static MatchMadnessTemplate _instantiate(DecodingData data) {
    return MatchMadnessTemplate(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        pairs: data.dec(_f$pairs));
  }

  @override
  final Function instantiate = _instantiate;

  static MatchMadnessTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchMadnessTemplate>(map);
  }

  static MatchMadnessTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<MatchMadnessTemplate>(json);
  }
}

mixin MatchMadnessTemplateMappable {
  String toJson() {
    return MatchMadnessTemplateMapper.ensureInitialized()
        .encodeJson<MatchMadnessTemplate>(this as MatchMadnessTemplate);
  }

  Map<String, dynamic> toMap() {
    return MatchMadnessTemplateMapper.ensureInitialized()
        .encodeMap<MatchMadnessTemplate>(this as MatchMadnessTemplate);
  }

  MatchMadnessTemplateCopyWith<MatchMadnessTemplate, MatchMadnessTemplate,
      MatchMadnessTemplate> get copyWith => _MatchMadnessTemplateCopyWithImpl<
          MatchMadnessTemplate, MatchMadnessTemplate>(
      this as MatchMadnessTemplate, $identity, $identity);
  @override
  String toString() {
    return MatchMadnessTemplateMapper.ensureInitialized()
        .stringifyValue(this as MatchMadnessTemplate);
  }

  @override
  bool operator ==(Object other) {
    return MatchMadnessTemplateMapper.ensureInitialized()
        .equalsValue(this as MatchMadnessTemplate, other);
  }

  @override
  int get hashCode {
    return MatchMadnessTemplateMapper.ensureInitialized()
        .hashValue(this as MatchMadnessTemplate);
  }
}

extension MatchMadnessTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchMadnessTemplate, $Out> {
  MatchMadnessTemplateCopyWith<$R, MatchMadnessTemplate, $Out>
      get $asMatchMadnessTemplate => $base.as(
          (v, t, t2) => _MatchMadnessTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchMadnessTemplateCopyWith<
    $R,
    $In extends MatchMadnessTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, MatchMadnessPair,
          MatchMadnessPairCopyWith<$R, MatchMadnessPair, MatchMadnessPair>>
      get pairs;
  @override
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceTemplateId,
      List<MatchMadnessPair>? pairs});
  MatchMadnessTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MatchMadnessTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchMadnessTemplate, $Out>
    implements MatchMadnessTemplateCopyWith<$R, MatchMadnessTemplate, $Out> {
  _MatchMadnessTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchMadnessTemplate> $mapper =
      MatchMadnessTemplateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, MatchMadnessPair,
          MatchMadnessPairCopyWith<$R, MatchMadnessPair, MatchMadnessPair>>
      get pairs => ListCopyWith(
          $value.pairs, (v, t) => v.copyWith.$chain(t), (v) => call(pairs: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          int? sortOrder,
          DateTime? createdAt,
          Object? sourceTemplateId = $none,
          List<MatchMadnessPair>? pairs}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (pairs != null) #pairs: pairs
      }));
  @override
  MatchMadnessTemplate $make(CopyWithData data) => MatchMadnessTemplate(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      pairs: data.get(#pairs, or: $value.pairs));

  @override
  MatchMadnessTemplateCopyWith<$R2, MatchMadnessTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MatchMadnessTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
