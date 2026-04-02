// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck.dart';

class DeckMapper extends ClassMapperBase<Deck> {
  DeckMapper._();

  static DeckMapper? _instance;
  static DeckMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Deck';

  static String _$id(Deck v) => v.id;
  static const Field<Deck, String> _f$id = Field('id', _$id);
  static String _$authorId(Deck v) => v.authorId;
  static const Field<Deck, String> _f$authorId = Field('authorId', _$authorId);
  static String _$title(Deck v) => v.title;
  static const Field<Deck, String> _f$title = Field('title', _$title);
  static String _$shortDescription(Deck v) => v.shortDescription;
  static const Field<Deck, String> _f$shortDescription =
      Field('shortDescription', _$shortDescription, opt: true, def: '');
  static String _$longDescription(Deck v) => v.longDescription;
  static const Field<Deck, String> _f$longDescription =
      Field('longDescription', _$longDescription, opt: true, def: '');
  static String _$targetLanguage(Deck v) => v.targetLanguage;
  static const Field<Deck, String> _f$targetLanguage =
      Field('targetLanguage', _$targetLanguage);
  static List<String> _$tags(Deck v) => v.tags;
  static const Field<Deck, List<String>> _f$tags =
      Field('tags', _$tags, opt: true, def: const []);
  static bool _$isPremade(Deck v) => v.isPremade;
  static const Field<Deck, bool> _f$isPremade =
      Field('isPremade', _$isPremade, opt: true, def: false);
  static bool _$isPublic(Deck v) => v.isPublic;
  static const Field<Deck, bool> _f$isPublic = Field('isPublic', _$isPublic);
  static bool _$isEditable(Deck v) => v.isEditable;
  static const Field<Deck, bool> _f$isEditable =
      Field('isEditable', _$isEditable, opt: true, def: true);
  static int _$cardCount(Deck v) => v.cardCount;
  static const Field<Deck, int> _f$cardCount = Field('cardCount', _$cardCount);
  static String _$version(Deck v) => v.version;
  static const Field<Deck, String> _f$version =
      Field('version', _$version, opt: true, def: '1.0.0');
  static int _$buildNumber(Deck v) => v.buildNumber;
  static const Field<Deck, int> _f$buildNumber =
      Field('buildNumber', _$buildNumber, opt: true, def: 1);
  static DateTime _$createdAt(Deck v) => v.createdAt;
  static const Field<Deck, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$updatedAt(Deck v) => v.updatedAt;
  static const Field<Deck, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt);
  static String? _$sourceDeckId(Deck v) => v.sourceDeckId;
  static const Field<Deck, String> _f$sourceDeckId =
      Field('sourceDeckId', _$sourceDeckId, opt: true);
  static String? _$sourceAuthorId(Deck v) => v.sourceAuthorId;
  static const Field<Deck, String> _f$sourceAuthorId =
      Field('sourceAuthorId', _$sourceAuthorId, opt: true);
  static bool _$isPublished(Deck v) => v.isPublished;
  static const Field<Deck, bool> _f$isPublished =
      Field('isPublished', _$isPublished);

  @override
  final MappableFields<Deck> fields = const {
    #id: _f$id,
    #authorId: _f$authorId,
    #title: _f$title,
    #shortDescription: _f$shortDescription,
    #longDescription: _f$longDescription,
    #targetLanguage: _f$targetLanguage,
    #tags: _f$tags,
    #isPremade: _f$isPremade,
    #isPublic: _f$isPublic,
    #isEditable: _f$isEditable,
    #cardCount: _f$cardCount,
    #version: _f$version,
    #buildNumber: _f$buildNumber,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #sourceDeckId: _f$sourceDeckId,
    #sourceAuthorId: _f$sourceAuthorId,
    #isPublished: _f$isPublished,
  };

  static Deck _instantiate(DecodingData data) {
    return Deck(
        id: data.dec(_f$id),
        authorId: data.dec(_f$authorId),
        title: data.dec(_f$title),
        shortDescription: data.dec(_f$shortDescription),
        longDescription: data.dec(_f$longDescription),
        targetLanguage: data.dec(_f$targetLanguage),
        tags: data.dec(_f$tags),
        isPremade: data.dec(_f$isPremade),
        isPublic: data.dec(_f$isPublic),
        isEditable: data.dec(_f$isEditable),
        cardCount: data.dec(_f$cardCount),
        version: data.dec(_f$version),
        buildNumber: data.dec(_f$buildNumber),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        sourceDeckId: data.dec(_f$sourceDeckId),
        sourceAuthorId: data.dec(_f$sourceAuthorId),
        isPublished: data.dec(_f$isPublished));
  }

  @override
  final Function instantiate = _instantiate;

  static Deck fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Deck>(map);
  }

  static Deck fromJson(String json) {
    return ensureInitialized().decodeJson<Deck>(json);
  }
}

mixin DeckMappable {
  String toJson() {
    return DeckMapper.ensureInitialized().encodeJson<Deck>(this as Deck);
  }

  Map<String, dynamic> toMap() {
    return DeckMapper.ensureInitialized().encodeMap<Deck>(this as Deck);
  }

  DeckCopyWith<Deck, Deck, Deck> get copyWith =>
      _DeckCopyWithImpl<Deck, Deck>(this as Deck, $identity, $identity);
  @override
  String toString() {
    return DeckMapper.ensureInitialized().stringifyValue(this as Deck);
  }

  @override
  bool operator ==(Object other) {
    return DeckMapper.ensureInitialized().equalsValue(this as Deck, other);
  }

  @override
  int get hashCode {
    return DeckMapper.ensureInitialized().hashValue(this as Deck);
  }
}

extension DeckValueCopy<$R, $Out> on ObjectCopyWith<$R, Deck, $Out> {
  DeckCopyWith<$R, Deck, $Out> get $asDeck =>
      $base.as((v, t, t2) => _DeckCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckCopyWith<$R, $In extends Deck, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get tags;
  $R call(
      {String? id,
      String? authorId,
      String? title,
      String? shortDescription,
      String? longDescription,
      String? targetLanguage,
      List<String>? tags,
      bool? isPremade,
      bool? isPublic,
      bool? isEditable,
      int? cardCount,
      String? version,
      int? buildNumber,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? sourceDeckId,
      String? sourceAuthorId,
      bool? isPublished});
  DeckCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Deck, $Out>
    implements DeckCopyWith<$R, Deck, $Out> {
  _DeckCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Deck> $mapper = DeckMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get tags =>
      ListCopyWith($value.tags, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(tags: v));
  @override
  $R call(
          {String? id,
          String? authorId,
          String? title,
          String? shortDescription,
          String? longDescription,
          String? targetLanguage,
          List<String>? tags,
          bool? isPremade,
          bool? isPublic,
          bool? isEditable,
          int? cardCount,
          String? version,
          int? buildNumber,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? sourceDeckId = $none,
          Object? sourceAuthorId = $none,
          bool? isPublished}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (authorId != null) #authorId: authorId,
        if (title != null) #title: title,
        if (shortDescription != null) #shortDescription: shortDescription,
        if (longDescription != null) #longDescription: longDescription,
        if (targetLanguage != null) #targetLanguage: targetLanguage,
        if (tags != null) #tags: tags,
        if (isPremade != null) #isPremade: isPremade,
        if (isPublic != null) #isPublic: isPublic,
        if (isEditable != null) #isEditable: isEditable,
        if (cardCount != null) #cardCount: cardCount,
        if (version != null) #version: version,
        if (buildNumber != null) #buildNumber: buildNumber,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (sourceDeckId != $none) #sourceDeckId: sourceDeckId,
        if (sourceAuthorId != $none) #sourceAuthorId: sourceAuthorId,
        if (isPublished != null) #isPublished: isPublished
      }));
  @override
  Deck $make(CopyWithData data) => Deck(
      id: data.get(#id, or: $value.id),
      authorId: data.get(#authorId, or: $value.authorId),
      title: data.get(#title, or: $value.title),
      shortDescription:
          data.get(#shortDescription, or: $value.shortDescription),
      longDescription: data.get(#longDescription, or: $value.longDescription),
      targetLanguage: data.get(#targetLanguage, or: $value.targetLanguage),
      tags: data.get(#tags, or: $value.tags),
      isPremade: data.get(#isPremade, or: $value.isPremade),
      isPublic: data.get(#isPublic, or: $value.isPublic),
      isEditable: data.get(#isEditable, or: $value.isEditable),
      cardCount: data.get(#cardCount, or: $value.cardCount),
      version: data.get(#version, or: $value.version),
      buildNumber: data.get(#buildNumber, or: $value.buildNumber),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      sourceDeckId: data.get(#sourceDeckId, or: $value.sourceDeckId),
      sourceAuthorId: data.get(#sourceAuthorId, or: $value.sourceAuthorId),
      isPublished: data.get(#isPublished, or: $value.isPublished));

  @override
  DeckCopyWith<$R2, Deck, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeckCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
