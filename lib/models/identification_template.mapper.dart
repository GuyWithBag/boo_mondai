// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'identification_template.dart';

class IdentificationTemplateMapper
    extends SubClassMapperBase<IdentificationTemplate> {
  IdentificationTemplateMapper._();

  static IdentificationTemplateMapper? _instance;
  static IdentificationTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = IdentificationTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'IdentificationTemplate';

  static String _$id(IdentificationTemplate v) => v.id;
  static const Field<IdentificationTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(IdentificationTemplate v) => v.deckId;
  static const Field<IdentificationTemplate, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$sortOrder(IdentificationTemplate v) => v.sortOrder;
  static const Field<IdentificationTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(IdentificationTemplate v) => v.createdAt;
  static const Field<IdentificationTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceTemplateId(IdentificationTemplate v) =>
      v.sourceTemplateId;
  static const Field<IdentificationTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);
  static String _$promptText(IdentificationTemplate v) => v.promptText;
  static const Field<IdentificationTemplate, String> _f$promptText =
      Field('promptText', _$promptText);
  static String _$acceptedAnswers(IdentificationTemplate v) =>
      v.acceptedAnswers;
  static const Field<IdentificationTemplate, String> _f$acceptedAnswers =
      Field('acceptedAnswers', _$acceptedAnswers);
  static String? _$imageUrl(IdentificationTemplate v) => v.imageUrl;
  static const Field<IdentificationTemplate, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, opt: true);
  static String? _$audioUrl(IdentificationTemplate v) => v.audioUrl;
  static const Field<IdentificationTemplate, String> _f$audioUrl =
      Field('audioUrl', _$audioUrl, opt: true);

  @override
  final MappableFields<IdentificationTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceTemplateId: _f$sourceTemplateId,
    #promptText: _f$promptText,
    #acceptedAnswers: _f$acceptedAnswers,
    #imageUrl: _f$imageUrl,
    #audioUrl: _f$audioUrl,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'identification';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static IdentificationTemplate _instantiate(DecodingData data) {
    return IdentificationTemplate(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        promptText: data.dec(_f$promptText),
        acceptedAnswers: data.dec(_f$acceptedAnswers),
        imageUrl: data.dec(_f$imageUrl),
        audioUrl: data.dec(_f$audioUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static IdentificationTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IdentificationTemplate>(map);
  }

  static IdentificationTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<IdentificationTemplate>(json);
  }
}

mixin IdentificationTemplateMappable {
  String toJson() {
    return IdentificationTemplateMapper.ensureInitialized()
        .encodeJson<IdentificationTemplate>(this as IdentificationTemplate);
  }

  Map<String, dynamic> toMap() {
    return IdentificationTemplateMapper.ensureInitialized()
        .encodeMap<IdentificationTemplate>(this as IdentificationTemplate);
  }

  IdentificationTemplateCopyWith<IdentificationTemplate, IdentificationTemplate,
          IdentificationTemplate>
      get copyWith => _IdentificationTemplateCopyWithImpl<
              IdentificationTemplate, IdentificationTemplate>(
          this as IdentificationTemplate, $identity, $identity);
  @override
  String toString() {
    return IdentificationTemplateMapper.ensureInitialized()
        .stringifyValue(this as IdentificationTemplate);
  }

  @override
  bool operator ==(Object other) {
    return IdentificationTemplateMapper.ensureInitialized()
        .equalsValue(this as IdentificationTemplate, other);
  }

  @override
  int get hashCode {
    return IdentificationTemplateMapper.ensureInitialized()
        .hashValue(this as IdentificationTemplate);
  }
}

extension IdentificationTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IdentificationTemplate, $Out> {
  IdentificationTemplateCopyWith<$R, IdentificationTemplate, $Out>
      get $asIdentificationTemplate => $base.as((v, t, t2) =>
          _IdentificationTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class IdentificationTemplateCopyWith<
    $R,
    $In extends IdentificationTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceTemplateId,
      String? promptText,
      String? acceptedAnswers,
      String? imageUrl,
      String? audioUrl});
  IdentificationTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _IdentificationTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IdentificationTemplate, $Out>
    implements
        IdentificationTemplateCopyWith<$R, IdentificationTemplate, $Out> {
  _IdentificationTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IdentificationTemplate> $mapper =
      IdentificationTemplateMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? deckId,
          int? sortOrder,
          DateTime? createdAt,
          Object? sourceTemplateId = $none,
          String? promptText,
          String? acceptedAnswers,
          Object? imageUrl = $none,
          Object? audioUrl = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (promptText != null) #promptText: promptText,
        if (acceptedAnswers != null) #acceptedAnswers: acceptedAnswers,
        if (imageUrl != $none) #imageUrl: imageUrl,
        if (audioUrl != $none) #audioUrl: audioUrl
      }));
  @override
  IdentificationTemplate $make(CopyWithData data) => IdentificationTemplate(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      promptText: data.get(#promptText, or: $value.promptText),
      acceptedAnswers: data.get(#acceptedAnswers, or: $value.acceptedAnswers),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      audioUrl: data.get(#audioUrl, or: $value.audioUrl));

  @override
  IdentificationTemplateCopyWith<$R2, IdentificationTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _IdentificationTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
