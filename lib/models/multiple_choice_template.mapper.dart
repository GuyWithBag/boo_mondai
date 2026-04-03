// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'multiple_choice_template.dart';

class MultipleChoiceTemplateMapper
    extends SubClassMapperBase<MultipleChoiceTemplate> {
  MultipleChoiceTemplateMapper._();

  static MultipleChoiceTemplateMapper? _instance;
  static MultipleChoiceTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MultipleChoiceTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
      MultipleChoiceOptionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MultipleChoiceTemplate';

  static String _$id(MultipleChoiceTemplate v) => v.id;
  static const Field<MultipleChoiceTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(MultipleChoiceTemplate v) => v.deckId;
  static const Field<MultipleChoiceTemplate, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$sortOrder(MultipleChoiceTemplate v) => v.sortOrder;
  static const Field<MultipleChoiceTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(MultipleChoiceTemplate v) => v.createdAt;
  static const Field<MultipleChoiceTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceTemplateId(MultipleChoiceTemplate v) =>
      v.sourceTemplateId;
  static const Field<MultipleChoiceTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);
  static String _$questionPrompt(MultipleChoiceTemplate v) => v.questionPrompt;
  static const Field<MultipleChoiceTemplate, String> _f$questionPrompt =
      Field('questionPrompt', _$questionPrompt);
  static List<MultipleChoiceOption> _$options(MultipleChoiceTemplate v) =>
      v.options;
  static const Field<MultipleChoiceTemplate, List<MultipleChoiceOption>>
      _f$options = Field('options', _$options);
  static String? _$imageUrl(MultipleChoiceTemplate v) => v.imageUrl;
  static const Field<MultipleChoiceTemplate, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, opt: true);
  static String? _$audioUrl(MultipleChoiceTemplate v) => v.audioUrl;
  static const Field<MultipleChoiceTemplate, String> _f$audioUrl =
      Field('audioUrl', _$audioUrl, opt: true);

  @override
  final MappableFields<MultipleChoiceTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceTemplateId: _f$sourceTemplateId,
    #questionPrompt: _f$questionPrompt,
    #options: _f$options,
    #imageUrl: _f$imageUrl,
    #audioUrl: _f$audioUrl,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'multiple_choice';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static MultipleChoiceTemplate _instantiate(DecodingData data) {
    return MultipleChoiceTemplate(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        sourceTemplateId: data.dec(_f$sourceTemplateId),
        questionPrompt: data.dec(_f$questionPrompt),
        options: data.dec(_f$options),
        imageUrl: data.dec(_f$imageUrl),
        audioUrl: data.dec(_f$audioUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static MultipleChoiceTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MultipleChoiceTemplate>(map);
  }

  static MultipleChoiceTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<MultipleChoiceTemplate>(json);
  }
}

mixin MultipleChoiceTemplateMappable {
  String toJson() {
    return MultipleChoiceTemplateMapper.ensureInitialized()
        .encodeJson<MultipleChoiceTemplate>(this as MultipleChoiceTemplate);
  }

  Map<String, dynamic> toMap() {
    return MultipleChoiceTemplateMapper.ensureInitialized()
        .encodeMap<MultipleChoiceTemplate>(this as MultipleChoiceTemplate);
  }

  MultipleChoiceTemplateCopyWith<MultipleChoiceTemplate, MultipleChoiceTemplate,
          MultipleChoiceTemplate>
      get copyWith => _MultipleChoiceTemplateCopyWithImpl<
              MultipleChoiceTemplate, MultipleChoiceTemplate>(
          this as MultipleChoiceTemplate, $identity, $identity);
  @override
  String toString() {
    return MultipleChoiceTemplateMapper.ensureInitialized()
        .stringifyValue(this as MultipleChoiceTemplate);
  }

  @override
  bool operator ==(Object other) {
    return MultipleChoiceTemplateMapper.ensureInitialized()
        .equalsValue(this as MultipleChoiceTemplate, other);
  }

  @override
  int get hashCode {
    return MultipleChoiceTemplateMapper.ensureInitialized()
        .hashValue(this as MultipleChoiceTemplate);
  }
}

extension MultipleChoiceTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MultipleChoiceTemplate, $Out> {
  MultipleChoiceTemplateCopyWith<$R, MultipleChoiceTemplate, $Out>
      get $asMultipleChoiceTemplate => $base.as((v, t, t2) =>
          _MultipleChoiceTemplateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MultipleChoiceTemplateCopyWith<
    $R,
    $In extends MultipleChoiceTemplate,
    $Out> implements CardTemplateCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      MultipleChoiceOption,
      MultipleChoiceOptionCopyWith<$R, MultipleChoiceOption,
          MultipleChoiceOption>> get options;
  @override
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceTemplateId,
      String? questionPrompt,
      List<MultipleChoiceOption>? options,
      String? imageUrl,
      String? audioUrl});
  MultipleChoiceTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MultipleChoiceTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MultipleChoiceTemplate, $Out>
    implements
        MultipleChoiceTemplateCopyWith<$R, MultipleChoiceTemplate, $Out> {
  _MultipleChoiceTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MultipleChoiceTemplate> $mapper =
      MultipleChoiceTemplateMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      MultipleChoiceOption,
      MultipleChoiceOptionCopyWith<$R, MultipleChoiceOption,
          MultipleChoiceOption>> get options => ListCopyWith(
      $value.options, (v, t) => v.copyWith.$chain(t), (v) => call(options: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          int? sortOrder,
          DateTime? createdAt,
          Object? sourceTemplateId = $none,
          String? questionPrompt,
          List<MultipleChoiceOption>? options,
          Object? imageUrl = $none,
          Object? audioUrl = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
        if (questionPrompt != null) #questionPrompt: questionPrompt,
        if (options != null) #options: options,
        if (imageUrl != $none) #imageUrl: imageUrl,
        if (audioUrl != $none) #audioUrl: audioUrl
      }));
  @override
  MultipleChoiceTemplate $make(CopyWithData data) => MultipleChoiceTemplate(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      sourceTemplateId:
          data.get(#sourceTemplateId, or: $value.sourceTemplateId),
      questionPrompt: data.get(#questionPrompt, or: $value.questionPrompt),
      options: data.get(#options, or: $value.options),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      audioUrl: data.get(#audioUrl, or: $value.audioUrl));

  @override
  MultipleChoiceTemplateCopyWith<$R2, MultipleChoiceTemplate, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MultipleChoiceTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
