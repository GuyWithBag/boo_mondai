// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card_media_attachment.dto.dart';

class CardMediaKindMapper extends EnumMapper<CardMediaKind> {
  CardMediaKindMapper._();

  static CardMediaKindMapper? _instance;
  static CardMediaKindMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardMediaKindMapper._());
    }
    return _instance!;
  }

  static CardMediaKind fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CardMediaKind decode(dynamic value) {
    switch (value) {
      case r'image':
        return CardMediaKind.image;
      case r'audio':
        return CardMediaKind.audio;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CardMediaKind self) {
    switch (self) {
      case CardMediaKind.image:
        return r'image';
      case CardMediaKind.audio:
        return r'audio';
    }
  }
}

extension CardMediaKindMapperExtension on CardMediaKind {
  String toValue() {
    CardMediaKindMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CardMediaKind>(this) as String;
  }
}

class CardMediaAttachmentMapper extends ClassMapperBase<CardMediaAttachment> {
  CardMediaAttachmentMapper._();

  static CardMediaAttachmentMapper? _instance;
  static CardMediaAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardMediaAttachmentMapper._());
      CardMediaKindMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CardMediaAttachment';

  static String _$id(CardMediaAttachment v) => v.id;
  static const Field<CardMediaAttachment, String> _f$id = Field('id', _$id);
  static String _$templateId(CardMediaAttachment v) => v.templateId;
  static const Field<CardMediaAttachment, String> _f$templateId =
      Field('templateId', _$templateId, key: r'template_id');
  static CardMediaKind _$kind(CardMediaAttachment v) => v.kind;
  static const Field<CardMediaAttachment, CardMediaKind> _f$kind =
      Field('kind', _$kind);
  static String _$storagePath(CardMediaAttachment v) => v.storagePath;
  static const Field<CardMediaAttachment, String> _f$storagePath =
      Field('storagePath', _$storagePath, key: r'storage_path');
  static String? _$publicUrl(CardMediaAttachment v) => v.publicUrl;
  static const Field<CardMediaAttachment, String> _f$publicUrl =
      Field('publicUrl', _$publicUrl, key: r'public_url', opt: true);
  static String? _$mimeType(CardMediaAttachment v) => v.mimeType;
  static const Field<CardMediaAttachment, String> _f$mimeType =
      Field('mimeType', _$mimeType, key: r'mime_type', opt: true);
  static String? _$altText(CardMediaAttachment v) => v.altText;
  static const Field<CardMediaAttachment, String> _f$altText =
      Field('altText', _$altText, key: r'alt_text', opt: true);
  static DateTime _$createdAt(CardMediaAttachment v) => v.createdAt;
  static const Field<CardMediaAttachment, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<CardMediaAttachment> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #kind: _f$kind,
    #storagePath: _f$storagePath,
    #publicUrl: _f$publicUrl,
    #mimeType: _f$mimeType,
    #altText: _f$altText,
    #createdAt: _f$createdAt,
  };

  static CardMediaAttachment _instantiate(DecodingData data) {
    return CardMediaAttachment(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        kind: data.dec(_f$kind),
        storagePath: data.dec(_f$storagePath),
        publicUrl: data.dec(_f$publicUrl),
        mimeType: data.dec(_f$mimeType),
        altText: data.dec(_f$altText),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static CardMediaAttachment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardMediaAttachment>(map);
  }

  static CardMediaAttachment fromJson(String json) {
    return ensureInitialized().decodeJson<CardMediaAttachment>(json);
  }
}

mixin CardMediaAttachmentMappable {
  String toJson() {
    return CardMediaAttachmentMapper.ensureInitialized()
        .encodeJson<CardMediaAttachment>(this as CardMediaAttachment);
  }

  Map<String, dynamic> toMap() {
    return CardMediaAttachmentMapper.ensureInitialized()
        .encodeMap<CardMediaAttachment>(this as CardMediaAttachment);
  }

  CardMediaAttachmentCopyWith<CardMediaAttachment, CardMediaAttachment,
      CardMediaAttachment> get copyWith => _CardMediaAttachmentCopyWithImpl<
          CardMediaAttachment, CardMediaAttachment>(
      this as CardMediaAttachment, $identity, $identity);
  @override
  String toString() {
    return CardMediaAttachmentMapper.ensureInitialized()
        .stringifyValue(this as CardMediaAttachment);
  }

  @override
  bool operator ==(Object other) {
    return CardMediaAttachmentMapper.ensureInitialized()
        .equalsValue(this as CardMediaAttachment, other);
  }

  @override
  int get hashCode {
    return CardMediaAttachmentMapper.ensureInitialized()
        .hashValue(this as CardMediaAttachment);
  }
}

extension CardMediaAttachmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CardMediaAttachment, $Out> {
  CardMediaAttachmentCopyWith<$R, CardMediaAttachment, $Out>
      get $asCardMediaAttachment => $base.as(
          (v, t, t2) => _CardMediaAttachmentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CardMediaAttachmentCopyWith<$R, $In extends CardMediaAttachment,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? templateId,
      CardMediaKind? kind,
      String? storagePath,
      String? publicUrl,
      String? mimeType,
      String? altText,
      DateTime? createdAt});
  CardMediaAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _CardMediaAttachmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardMediaAttachment, $Out>
    implements CardMediaAttachmentCopyWith<$R, CardMediaAttachment, $Out> {
  _CardMediaAttachmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardMediaAttachment> $mapper =
      CardMediaAttachmentMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? templateId,
          CardMediaKind? kind,
          String? storagePath,
          Object? publicUrl = $none,
          Object? mimeType = $none,
          Object? altText = $none,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (kind != null) #kind: kind,
        if (storagePath != null) #storagePath: storagePath,
        if (publicUrl != $none) #publicUrl: publicUrl,
        if (mimeType != $none) #mimeType: mimeType,
        if (altText != $none) #altText: altText,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  CardMediaAttachment $make(CopyWithData data) => CardMediaAttachment(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      kind: data.get(#kind, or: $value.kind),
      storagePath: data.get(#storagePath, or: $value.storagePath),
      publicUrl: data.get(#publicUrl, or: $value.publicUrl),
      mimeType: data.get(#mimeType, or: $value.mimeType),
      altText: data.get(#altText, or: $value.altText),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  CardMediaAttachmentCopyWith<$R2, CardMediaAttachment, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _CardMediaAttachmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
