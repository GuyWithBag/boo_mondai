// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card_media_attachment.dto.dart';

class AttachmentTypeMapper extends EnumMapper<AttachmentType> {
  AttachmentTypeMapper._();

  static AttachmentTypeMapper? _instance;
  static AttachmentTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AttachmentTypeMapper._());
    }
    return _instance!;
  }

  static AttachmentType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AttachmentType decode(dynamic value) {
    switch (value) {
      case r'image':
        return AttachmentType.image;
      case r'audio':
        return AttachmentType.audio;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AttachmentType self) {
    switch (self) {
      case AttachmentType.image:
        return r'image';
      case AttachmentType.audio:
        return r'audio';
    }
  }
}

extension AttachmentTypeMapperExtension on AttachmentType {
  String toValue() {
    AttachmentTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AttachmentType>(this) as String;
  }
}

class CardMediaAttachmentMapper
    extends SubClassMapperBase<CardMediaAttachment> {
  CardMediaAttachmentMapper._();

  static CardMediaAttachmentMapper? _instance;
  static CardMediaAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardMediaAttachmentMapper._());
      CardAttachmentMapper.ensureInitialized().addSubMapper(_instance!);
      AttachmentTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CardMediaAttachment';

  static String _$id(CardMediaAttachment v) => v.id;
  static const Field<CardMediaAttachment, String> _f$id = Field('id', _$id);
  static String _$templateId(CardMediaAttachment v) => v.templateId;
  static const Field<CardMediaAttachment, String> _f$templateId = Field(
    'templateId',
    _$templateId,
    key: r'template_id',
  );
  static AttachmentType _$type(CardMediaAttachment v) => v.type;
  static const Field<CardMediaAttachment, AttachmentType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$label(CardMediaAttachment v) => v.label;
  static const Field<CardMediaAttachment, String> _f$label = Field(
    'label',
    _$label,
  );
  static String _$storagePath(CardMediaAttachment v) => v.storagePath;
  static const Field<CardMediaAttachment, String> _f$storagePath = Field(
    'storagePath',
    _$storagePath,
    key: r'storage_path',
  );
  static String? _$publicUrl(CardMediaAttachment v) => v.publicUrl;
  static const Field<CardMediaAttachment, String> _f$publicUrl = Field(
    'publicUrl',
    _$publicUrl,
    key: r'public_url',
    opt: true,
  );
  static String? _$localPath(CardMediaAttachment v) => v.localPath;
  static const Field<CardMediaAttachment, String> _f$localPath = Field(
    'localPath',
    _$localPath,
    key: r'local_path',
    opt: true,
  );
  static String _$mimeType(CardMediaAttachment v) => v.mimeType;
  static const Field<CardMediaAttachment, String> _f$mimeType = Field(
    'mimeType',
    _$mimeType,
    key: r'mime_type',
  );
  static String? _$altText(CardMediaAttachment v) => v.altText;
  static const Field<CardMediaAttachment, String> _f$altText = Field(
    'altText',
    _$altText,
    key: r'alt_text',
    opt: true,
  );
  static DateTime _$createdAt(CardMediaAttachment v) => v.createdAt;
  static const Field<CardMediaAttachment, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );

  @override
  final MappableFields<CardMediaAttachment> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #type: _f$type,
    #label: _f$label,
    #storagePath: _f$storagePath,
    #publicUrl: _f$publicUrl,
    #localPath: _f$localPath,
    #mimeType: _f$mimeType,
    #altText: _f$altText,
    #createdAt: _f$createdAt,
  };

  @override
  final String discriminatorKey = 'attachment_source';
  @override
  final dynamic discriminatorValue = 'media';
  @override
  late final ClassMapperBase superMapper =
      CardAttachmentMapper.ensureInitialized();

  static CardMediaAttachment _instantiate(DecodingData data) {
    return CardMediaAttachment(
      id: data.dec(_f$id),
      templateId: data.dec(_f$templateId),
      type: data.dec(_f$type),
      label: data.dec(_f$label),
      storagePath: data.dec(_f$storagePath),
      publicUrl: data.dec(_f$publicUrl),
      localPath: data.dec(_f$localPath),
      mimeType: data.dec(_f$mimeType),
      altText: data.dec(_f$altText),
      createdAt: data.dec(_f$createdAt),
    );
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

  CardMediaAttachmentCopyWith<
    CardMediaAttachment,
    CardMediaAttachment,
    CardMediaAttachment
  >
  get copyWith =>
      _CardMediaAttachmentCopyWithImpl<
        CardMediaAttachment,
        CardMediaAttachment
      >(this as CardMediaAttachment, $identity, $identity);
  @override
  String toString() {
    return CardMediaAttachmentMapper.ensureInitialized().stringifyValue(
      this as CardMediaAttachment,
    );
  }

  @override
  bool operator ==(Object other) {
    return CardMediaAttachmentMapper.ensureInitialized().equalsValue(
      this as CardMediaAttachment,
      other,
    );
  }

  @override
  int get hashCode {
    return CardMediaAttachmentMapper.ensureInitialized().hashValue(
      this as CardMediaAttachment,
    );
  }
}

extension CardMediaAttachmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CardMediaAttachment, $Out> {
  CardMediaAttachmentCopyWith<$R, CardMediaAttachment, $Out>
  get $asCardMediaAttachment => $base.as(
    (v, t, t2) => _CardMediaAttachmentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CardMediaAttachmentCopyWith<
  $R,
  $In extends CardMediaAttachment,
  $Out
>
    implements CardAttachmentCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? templateId,
    AttachmentType? type,
    String? label,
    String? storagePath,
    String? publicUrl,
    String? localPath,
    String? mimeType,
    String? altText,
    DateTime? createdAt,
  });
  CardMediaAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CardMediaAttachmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardMediaAttachment, $Out>
    implements CardMediaAttachmentCopyWith<$R, CardMediaAttachment, $Out> {
  _CardMediaAttachmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardMediaAttachment> $mapper =
      CardMediaAttachmentMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? templateId,
    AttachmentType? type,
    String? label,
    String? storagePath,
    Object? publicUrl = $none,
    Object? localPath = $none,
    String? mimeType,
    Object? altText = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (templateId != null) #templateId: templateId,
      if (type != null) #type: type,
      if (label != null) #label: label,
      if (storagePath != null) #storagePath: storagePath,
      if (publicUrl != $none) #publicUrl: publicUrl,
      if (localPath != $none) #localPath: localPath,
      if (mimeType != null) #mimeType: mimeType,
      if (altText != $none) #altText: altText,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  CardMediaAttachment $make(CopyWithData data) => CardMediaAttachment(
    id: data.get(#id, or: $value.id),
    templateId: data.get(#templateId, or: $value.templateId),
    type: data.get(#type, or: $value.type),
    label: data.get(#label, or: $value.label),
    storagePath: data.get(#storagePath, or: $value.storagePath),
    publicUrl: data.get(#publicUrl, or: $value.publicUrl),
    localPath: data.get(#localPath, or: $value.localPath),
    mimeType: data.get(#mimeType, or: $value.mimeType),
    altText: data.get(#altText, or: $value.altText),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  CardMediaAttachmentCopyWith<$R2, CardMediaAttachment, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CardMediaAttachmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CardAttachmentMapper extends ClassMapperBase<CardAttachment> {
  CardAttachmentMapper._();

  static CardAttachmentMapper? _instance;
  static CardAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardAttachmentMapper._());
      CardMediaAttachmentMapper.ensureInitialized();
      CardLinkAttachmentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CardAttachment';

  @override
  final MappableFields<CardAttachment> fields = const {};

  static CardAttachment _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'CardAttachment',
      'attachment_source',
      '${data.value['attachment_source']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CardAttachment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardAttachment>(map);
  }

  static CardAttachment fromJson(String json) {
    return ensureInitialized().decodeJson<CardAttachment>(json);
  }
}

mixin CardAttachmentMappable {
  String toJson();
  Map<String, dynamic> toMap();
  CardAttachmentCopyWith<CardAttachment, CardAttachment, CardAttachment>
  get copyWith;
}

abstract class CardAttachmentCopyWith<$R, $In extends CardAttachment, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  CardAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class CardLinkAttachmentMapper extends SubClassMapperBase<CardLinkAttachment> {
  CardLinkAttachmentMapper._();

  static CardLinkAttachmentMapper? _instance;
  static CardLinkAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardLinkAttachmentMapper._());
      CardAttachmentMapper.ensureInitialized().addSubMapper(_instance!);
      AttachmentTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CardLinkAttachment';

  static String _$id(CardLinkAttachment v) => v.id;
  static const Field<CardLinkAttachment, String> _f$id = Field('id', _$id);
  static String _$templateId(CardLinkAttachment v) => v.templateId;
  static const Field<CardLinkAttachment, String> _f$templateId = Field(
    'templateId',
    _$templateId,
    key: r'template_id',
  );
  static AttachmentType _$type(CardLinkAttachment v) => v.type;
  static const Field<CardLinkAttachment, AttachmentType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$label(CardLinkAttachment v) => v.label;
  static const Field<CardLinkAttachment, String> _f$label = Field(
    'label',
    _$label,
  );
  static String _$url(CardLinkAttachment v) => v.url;
  static const Field<CardLinkAttachment, String> _f$url = Field('url', _$url);
  static String? _$altText(CardLinkAttachment v) => v.altText;
  static const Field<CardLinkAttachment, String> _f$altText = Field(
    'altText',
    _$altText,
    key: r'alt_text',
    opt: true,
  );
  static DateTime _$createdAt(CardLinkAttachment v) => v.createdAt;
  static const Field<CardLinkAttachment, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );

  @override
  final MappableFields<CardLinkAttachment> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #type: _f$type,
    #label: _f$label,
    #url: _f$url,
    #altText: _f$altText,
    #createdAt: _f$createdAt,
  };

  @override
  final String discriminatorKey = 'attachment_source';
  @override
  final dynamic discriminatorValue = 'link';
  @override
  late final ClassMapperBase superMapper =
      CardAttachmentMapper.ensureInitialized();

  static CardLinkAttachment _instantiate(DecodingData data) {
    return CardLinkAttachment(
      id: data.dec(_f$id),
      templateId: data.dec(_f$templateId),
      type: data.dec(_f$type),
      label: data.dec(_f$label),
      url: data.dec(_f$url),
      altText: data.dec(_f$altText),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CardLinkAttachment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardLinkAttachment>(map);
  }

  static CardLinkAttachment fromJson(String json) {
    return ensureInitialized().decodeJson<CardLinkAttachment>(json);
  }
}

mixin CardLinkAttachmentMappable {
  String toJson() {
    return CardLinkAttachmentMapper.ensureInitialized()
        .encodeJson<CardLinkAttachment>(this as CardLinkAttachment);
  }

  Map<String, dynamic> toMap() {
    return CardLinkAttachmentMapper.ensureInitialized()
        .encodeMap<CardLinkAttachment>(this as CardLinkAttachment);
  }

  CardLinkAttachmentCopyWith<
    CardLinkAttachment,
    CardLinkAttachment,
    CardLinkAttachment
  >
  get copyWith =>
      _CardLinkAttachmentCopyWithImpl<CardLinkAttachment, CardLinkAttachment>(
        this as CardLinkAttachment,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CardLinkAttachmentMapper.ensureInitialized().stringifyValue(
      this as CardLinkAttachment,
    );
  }

  @override
  bool operator ==(Object other) {
    return CardLinkAttachmentMapper.ensureInitialized().equalsValue(
      this as CardLinkAttachment,
      other,
    );
  }

  @override
  int get hashCode {
    return CardLinkAttachmentMapper.ensureInitialized().hashValue(
      this as CardLinkAttachment,
    );
  }
}

extension CardLinkAttachmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CardLinkAttachment, $Out> {
  CardLinkAttachmentCopyWith<$R, CardLinkAttachment, $Out>
  get $asCardLinkAttachment => $base.as(
    (v, t, t2) => _CardLinkAttachmentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CardLinkAttachmentCopyWith<
  $R,
  $In extends CardLinkAttachment,
  $Out
>
    implements CardAttachmentCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? templateId,
    AttachmentType? type,
    String? label,
    String? url,
    String? altText,
    DateTime? createdAt,
  });
  CardLinkAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CardLinkAttachmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardLinkAttachment, $Out>
    implements CardLinkAttachmentCopyWith<$R, CardLinkAttachment, $Out> {
  _CardLinkAttachmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardLinkAttachment> $mapper =
      CardLinkAttachmentMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? templateId,
    AttachmentType? type,
    String? label,
    String? url,
    Object? altText = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (templateId != null) #templateId: templateId,
      if (type != null) #type: type,
      if (label != null) #label: label,
      if (url != null) #url: url,
      if (altText != $none) #altText: altText,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  CardLinkAttachment $make(CopyWithData data) => CardLinkAttachment(
    id: data.get(#id, or: $value.id),
    templateId: data.get(#templateId, or: $value.templateId),
    type: data.get(#type, or: $value.type),
    label: data.get(#label, or: $value.label),
    url: data.get(#url, or: $value.url),
    altText: data.get(#altText, or: $value.altText),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  CardLinkAttachmentCopyWith<$R2, CardLinkAttachment, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CardLinkAttachmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
