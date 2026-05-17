// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card_template_tag.dto.dart';

class CardTemplateTagMapper extends ClassMapperBase<CardTemplateTag> {
  CardTemplateTagMapper._();

  static CardTemplateTagMapper? _instance;
  static CardTemplateTagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardTemplateTagMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CardTemplateTag';

  static String _$templateId(CardTemplateTag v) => v.templateId;
  static const Field<CardTemplateTag, String> _f$templateId = Field(
    'templateId',
    _$templateId,
    key: r'template_id',
  );
  static String _$tagId(CardTemplateTag v) => v.tagId;
  static const Field<CardTemplateTag, String> _f$tagId = Field(
    'tagId',
    _$tagId,
    key: r'tag_id',
  );

  @override
  final MappableFields<CardTemplateTag> fields = const {
    #templateId: _f$templateId,
    #tagId: _f$tagId,
  };

  static CardTemplateTag _instantiate(DecodingData data) {
    return CardTemplateTag(
      templateId: data.dec(_f$templateId),
      tagId: data.dec(_f$tagId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CardTemplateTag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardTemplateTag>(map);
  }

  static CardTemplateTag fromJson(String json) {
    return ensureInitialized().decodeJson<CardTemplateTag>(json);
  }
}

mixin CardTemplateTagMappable {
  String toJson() {
    return CardTemplateTagMapper.ensureInitialized()
        .encodeJson<CardTemplateTag>(this as CardTemplateTag);
  }

  Map<String, dynamic> toMap() {
    return CardTemplateTagMapper.ensureInitialized().encodeMap<CardTemplateTag>(
      this as CardTemplateTag,
    );
  }

  CardTemplateTagCopyWith<CardTemplateTag, CardTemplateTag, CardTemplateTag>
  get copyWith =>
      _CardTemplateTagCopyWithImpl<CardTemplateTag, CardTemplateTag>(
        this as CardTemplateTag,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CardTemplateTagMapper.ensureInitialized().stringifyValue(
      this as CardTemplateTag,
    );
  }

  @override
  bool operator ==(Object other) {
    return CardTemplateTagMapper.ensureInitialized().equalsValue(
      this as CardTemplateTag,
      other,
    );
  }

  @override
  int get hashCode {
    return CardTemplateTagMapper.ensureInitialized().hashValue(
      this as CardTemplateTag,
    );
  }
}

extension CardTemplateTagValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CardTemplateTag, $Out> {
  CardTemplateTagCopyWith<$R, CardTemplateTag, $Out> get $asCardTemplateTag =>
      $base.as((v, t, t2) => _CardTemplateTagCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CardTemplateTagCopyWith<$R, $In extends CardTemplateTag, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? templateId, String? tagId});
  CardTemplateTagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CardTemplateTagCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardTemplateTag, $Out>
    implements CardTemplateTagCopyWith<$R, CardTemplateTag, $Out> {
  _CardTemplateTagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardTemplateTag> $mapper =
      CardTemplateTagMapper.ensureInitialized();
  @override
  $R call({String? templateId, String? tagId}) => $apply(
    FieldCopyWithData({
      if (templateId != null) #templateId: templateId,
      if (tagId != null) #tagId: tagId,
    }),
  );
  @override
  CardTemplateTag $make(CopyWithData data) => CardTemplateTag(
    templateId: data.get(#templateId, or: $value.templateId),
    tagId: data.get(#tagId, or: $value.tagId),
  );

  @override
  CardTemplateTagCopyWith<$R2, CardTemplateTag, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CardTemplateTagCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
