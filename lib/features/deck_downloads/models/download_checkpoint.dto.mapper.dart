// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'download_checkpoint.dto.dart';

class DownloadCheckpointMapper extends ClassMapperBase<DownloadCheckpoint> {
  DownloadCheckpointMapper._();

  static DownloadCheckpointMapper? _instance;
  static DownloadCheckpointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DownloadCheckpointMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DownloadCheckpoint';

  static String _$deckId(DownloadCheckpoint v) => v.deckId;
  static const Field<DownloadCheckpoint, String> _f$deckId = Field(
    'deckId',
    _$deckId,
    key: r'deck_id',
  );
  static String _$deckTitle(DownloadCheckpoint v) => v.deckTitle;
  static const Field<DownloadCheckpoint, String> _f$deckTitle = Field(
    'deckTitle',
    _$deckTitle,
    key: r'deck_title',
  );
  static int _$totalTemplates(DownloadCheckpoint v) => v.totalTemplates;
  static const Field<DownloadCheckpoint, int> _f$totalTemplates = Field(
    'totalTemplates',
    _$totalTemplates,
    key: r'total_templates',
  );
  static List<String> _$fetchedTemplateIds(DownloadCheckpoint v) =>
      v.fetchedTemplateIds;
  static const Field<DownloadCheckpoint, List<String>> _f$fetchedTemplateIds =
      Field(
        'fetchedTemplateIds',
        _$fetchedTemplateIds,
        key: r'fetched_template_ids',
      );
  static DownloadCheckpointStatus _$status(DownloadCheckpoint v) => v.status;
  static const Field<DownloadCheckpoint, DownloadCheckpointStatus> _f$status =
      Field('status', _$status);
  static DateTime _$createdAt(DownloadCheckpoint v) => v.createdAt;
  static const Field<DownloadCheckpoint, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(DownloadCheckpoint v) => v.updatedAt;
  static const Field<DownloadCheckpoint, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<DownloadCheckpoint> fields = const {
    #deckId: _f$deckId,
    #deckTitle: _f$deckTitle,
    #totalTemplates: _f$totalTemplates,
    #fetchedTemplateIds: _f$fetchedTemplateIds,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static DownloadCheckpoint _instantiate(DecodingData data) {
    return DownloadCheckpoint(
      deckId: data.dec(_f$deckId),
      deckTitle: data.dec(_f$deckTitle),
      totalTemplates: data.dec(_f$totalTemplates),
      fetchedTemplateIds: data.dec(_f$fetchedTemplateIds),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DownloadCheckpoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DownloadCheckpoint>(map);
  }

  static DownloadCheckpoint fromJson(String json) {
    return ensureInitialized().decodeJson<DownloadCheckpoint>(json);
  }
}

mixin DownloadCheckpointMappable {
  String toJson() {
    return DownloadCheckpointMapper.ensureInitialized()
        .encodeJson<DownloadCheckpoint>(this as DownloadCheckpoint);
  }

  Map<String, dynamic> toMap() {
    return DownloadCheckpointMapper.ensureInitialized()
        .encodeMap<DownloadCheckpoint>(this as DownloadCheckpoint);
  }

  DownloadCheckpointCopyWith<
    DownloadCheckpoint,
    DownloadCheckpoint,
    DownloadCheckpoint
  >
  get copyWith =>
      _DownloadCheckpointCopyWithImpl<DownloadCheckpoint, DownloadCheckpoint>(
        this as DownloadCheckpoint,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DownloadCheckpointMapper.ensureInitialized().stringifyValue(
      this as DownloadCheckpoint,
    );
  }

  @override
  bool operator ==(Object other) {
    return DownloadCheckpointMapper.ensureInitialized().equalsValue(
      this as DownloadCheckpoint,
      other,
    );
  }

  @override
  int get hashCode {
    return DownloadCheckpointMapper.ensureInitialized().hashValue(
      this as DownloadCheckpoint,
    );
  }
}

extension DownloadCheckpointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DownloadCheckpoint, $Out> {
  DownloadCheckpointCopyWith<$R, DownloadCheckpoint, $Out>
  get $asDownloadCheckpoint => $base.as(
    (v, t, t2) => _DownloadCheckpointCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DownloadCheckpointCopyWith<
  $R,
  $In extends DownloadCheckpoint,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get fetchedTemplateIds;
  $R call({
    String? deckId,
    String? deckTitle,
    int? totalTemplates,
    List<String>? fetchedTemplateIds,
    DownloadCheckpointStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  DownloadCheckpointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DownloadCheckpointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DownloadCheckpoint, $Out>
    implements DownloadCheckpointCopyWith<$R, DownloadCheckpoint, $Out> {
  _DownloadCheckpointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DownloadCheckpoint> $mapper =
      DownloadCheckpointMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get fetchedTemplateIds => ListCopyWith(
    $value.fetchedTemplateIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(fetchedTemplateIds: v),
  );
  @override
  $R call({
    String? deckId,
    String? deckTitle,
    int? totalTemplates,
    List<String>? fetchedTemplateIds,
    DownloadCheckpointStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (deckId != null) #deckId: deckId,
      if (deckTitle != null) #deckTitle: deckTitle,
      if (totalTemplates != null) #totalTemplates: totalTemplates,
      if (fetchedTemplateIds != null) #fetchedTemplateIds: fetchedTemplateIds,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  DownloadCheckpoint $make(CopyWithData data) => DownloadCheckpoint(
    deckId: data.get(#deckId, or: $value.deckId),
    deckTitle: data.get(#deckTitle, or: $value.deckTitle),
    totalTemplates: data.get(#totalTemplates, or: $value.totalTemplates),
    fetchedTemplateIds: data.get(
      #fetchedTemplateIds,
      or: $value.fetchedTemplateIds,
    ),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  DownloadCheckpointCopyWith<$R2, DownloadCheckpoint, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DownloadCheckpointCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
