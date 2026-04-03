// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'word_scramble_template.dart';

class WordScrambleTemplateMapper
    extends SubClassMapperBase<WordScrambleTemplate> {
  WordScrambleTemplateMapper._();

  static WordScrambleTemplateMapper? _instance;
  static WordScrambleTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WordScrambleTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'WordScrambleTemplate';

  static String _$id(WordScrambleTemplate v) => v.id;
  static const Field<WordScrambleTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(WordScrambleTemplate v) => v.deckId;
  static const Field<WordScrambleTemplate, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$sortOrder(WordScrambleTemplate v) => v.sortOrder;
  static const Field<WordScrambleTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(WordScrambleTemplate v) => v.createdAt;
  static const Field<WordScrambleTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceTemplateId(WordScrambleTemplate v) =>
      v.sourceTemplateId;
  static const Field<WordScrambleTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);
  static String _$sentenceToScramble(WordScrambleTemplate v) =>
      v.sentenceToScramble;
  static const Field<WordScrambleTemplate, String> _f$sentenceToScramble =
      Field('sentenceToScramble', _$sentenceToScramble);
  static String? _$imageUrl(WordScrambleTemplate v) => v.imageUrl;
  static const Field<WordScrambleTemplate, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, opt: true);
  static String? _$audioUrl(WordScrambleTemplate v) => v.audioUrl;
  static const Field<WordScrambleTemplate, String> _f$audioUrl =
      Field('audioUrl', _$audioUrl, opt: true);

  @override
  final MappableFields<WordScrambleTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceTemplateId: _f$sourceTemplateId,
    #sentenceToScramble: _f$sentenceToScramble,
    #imageUrl: _f$imageUrl,
    #audioUrl: _f$audioUrl,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'word_scramble';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static WordScrambleTemplate _instantiate(DecodingData data) {
    return WordScrambleTemplate(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        sentenceToScramble: data.dec(_f$sentenceToScramble),
        imageUrl: data.dec(_f$imageUrl),
        audioUrl: data.dec(_f$audioUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static WordScrambleTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WordScrambleTemplate>(map);
  }

  static WordScrambleTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<WordScrambleTemplate>(json);
  }
}

mixin WordScrambleTemplateMappable {
  String toJson() {
    return WordScrambleTemplateMapper.ensureInitialized()
        .encodeJson<WordScrambleTemplate>(this as WordScrambleTemplate);
  }

  Map<String, dynamic> toMap() {
    return WordScrambleTemplateMapper.ensureInitialized()
        .encodeMap<WordScrambleTemplate>(this as WordScrambleTemplate);
  }

  WordScrambleTemplateCopyWith<WordScrambleTemplate, WordScrambleTemplate,
      WordScrambleTemplate> get copyWith => _WordScrambleTemplateCopyWithImpl<
          WordScrambleTemplate, WordScrambleTemplate>(
      this as WordScrambleTemplate, $identity, $identity);
  @override
  String toString() {
    return WordScrambleTemplateMapper.ensureInitialized()
        .stringifyValue(this as WordScrambleTemplate);
  }

  @override
  bool operator ==(Object other) {
    return WordScrambleTemplateMapper.ensureInitialized()
        .equalsValue(this as WordScrambleTemplate, other);
  }

  @override
  int get hashCode {
    return WordScrambleTemplateMapper.ensureInitialized()
        .hashValue(this as WordScrambleTemplate);
  }
}

extension WordScrambleTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WordScrambleTemplate, $Out> {
  WordScrambleTemplateCopyWith<$R, WordScrambleTemplate, $Out>
      get $asWordScrambleTemplate => $base.as(
          (v, t, t2) => _WordScrambleTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WordScrambleTemplateCopyWith<
    $R,
    $In extends WordScrambleTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceTemplateId,
      String? sentenceToScramble,
      String? imageUrl,
      String? audioUrl});
  WordScrambleTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _WordScrambleTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WordScrambleTemplate, $Out>
    implements WordScrambleTemplateCopyWith<$R, WordScrambleTemplate, $Out> {
  _WordScrambleTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WordScrambleTemplate> $mapper =
      WordScrambleTemplateMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? deckId,
          int? sortOrder,
          DateTime? createdAt,
          Object? sourceTemplateId = $none,
          String? sentenceToScramble,
          Object? imageUrl = $none,
          Object? audioUrl = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (sentenceToScramble != null) #sentenceToScramble: sentenceToScramble,
        if (imageUrl != $none) #imageUrl: imageUrl,
        if (audioUrl != $none) #audioUrl: audioUrl
      }));
  @override
  WordScrambleTemplate $make(CopyWithData data) => WordScrambleTemplate(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      sentenceToScramble:
          data.get(#sentenceToScramble, or: $value.sentenceToScramble),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      audioUrl: data.get(#audioUrl, or: $value.audioUrl));

  @override
  WordScrambleTemplateCopyWith<$R2, WordScrambleTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _WordScrambleTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
