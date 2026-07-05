// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'change_tracker_entry.dart';

class ChangeTrackerEntryMapper extends ClassMapperBase<ChangeTrackerEntry> {
  ChangeTrackerEntryMapper._();

  static ChangeTrackerEntryMapper? _instance;
  static ChangeTrackerEntryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChangeTrackerEntryMapper._());
      ChangedEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChangeTrackerEntry';
  @override
  Function get typeFactory => <T>(f) => f<ChangeTrackerEntry<T>>();

  static String _$id(ChangeTrackerEntry v) => v.id;
  static const Field<ChangeTrackerEntry, String> _f$id =
      Field('id', _$id, opt: true);
  static ChangeSource _$source(ChangeTrackerEntry v) => v.source;
  static const Field<ChangeTrackerEntry, ChangeSource> _f$source =
      Field('source', _$source);
  static String _$title(ChangeTrackerEntry v) => v.title;
  static const Field<ChangeTrackerEntry, String> _f$title =
      Field('title', _$title);
  static ChangeTrackerStatus _$status(ChangeTrackerEntry v) => v.status;
  static const Field<ChangeTrackerEntry, ChangeTrackerStatus> _f$status =
      Field('status', _$status, opt: true, def: ChangeTrackerStatus.idle);
  static List<ChangedEntity<dynamic>> _$changes(ChangeTrackerEntry v) =>
      v.changes;
  static dynamic _arg$changes<T>(f) => f<List<ChangedEntity<T>>>();
  static const Field<ChangeTrackerEntry, List<ChangedEntity<dynamic>>>
      _f$changes =
      Field('changes', _$changes, opt: true, def: const [], arg: _arg$changes);
  static double? _$progress(ChangeTrackerEntry v) => v.progress;
  static const Field<ChangeTrackerEntry, double> _f$progress =
      Field('progress', _$progress, opt: true);
  static String? _$errorMessage(ChangeTrackerEntry v) => v.errorMessage;
  static const Field<ChangeTrackerEntry, String> _f$errorMessage =
      Field('errorMessage', _$errorMessage, key: r'error_message', opt: true);
  static DateTime _$startedAt(ChangeTrackerEntry v) => v.startedAt;
  static const Field<ChangeTrackerEntry, DateTime> _f$startedAt =
      Field('startedAt', _$startedAt, key: r'started_at', opt: true);
  static DateTime? _$finishedAt(ChangeTrackerEntry v) => v.finishedAt;
  static const Field<ChangeTrackerEntry, DateTime> _f$finishedAt =
      Field('finishedAt', _$finishedAt, key: r'finished_at', opt: true);

  @override
  final MappableFields<ChangeTrackerEntry> fields = const {
    #id: _f$id,
    #source: _f$source,
    #title: _f$title,
    #status: _f$status,
    #changes: _f$changes,
    #progress: _f$progress,
    #errorMessage: _f$errorMessage,
    #startedAt: _f$startedAt,
    #finishedAt: _f$finishedAt,
  };

  static ChangeTrackerEntry<T> _instantiate<T>(DecodingData data) {
    return ChangeTrackerEntry(
        id: data.dec(_f$id),
        source: data.dec(_f$source),
        title: data.dec(_f$title),
        status: data.dec(_f$status),
        changes: data.dec(_f$changes),
        progress: data.dec(_f$progress),
        errorMessage: data.dec(_f$errorMessage),
        startedAt: data.dec(_f$startedAt),
        finishedAt: data.dec(_f$finishedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ChangeTrackerEntry<T> fromMap<T>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChangeTrackerEntry<T>>(map);
  }

  static ChangeTrackerEntry<T> fromJson<T>(String json) {
    return ensureInitialized().decodeJson<ChangeTrackerEntry<T>>(json);
  }
}

mixin ChangeTrackerEntryMappable<T> {
  String toJson() {
    return ChangeTrackerEntryMapper.ensureInitialized()
        .encodeJson<ChangeTrackerEntry<T>>(this as ChangeTrackerEntry<T>);
  }

  Map<String, dynamic> toMap() {
    return ChangeTrackerEntryMapper.ensureInitialized()
        .encodeMap<ChangeTrackerEntry<T>>(this as ChangeTrackerEntry<T>);
  }

  ChangeTrackerEntryCopyWith<ChangeTrackerEntry<T>, ChangeTrackerEntry<T>,
          ChangeTrackerEntry<T>, T>
      get copyWith => _ChangeTrackerEntryCopyWithImpl<
          ChangeTrackerEntry<T>,
          ChangeTrackerEntry<T>,
          T>(this as ChangeTrackerEntry<T>, $identity, $identity);
  @override
  String toString() {
    return ChangeTrackerEntryMapper.ensureInitialized()
        .stringifyValue(this as ChangeTrackerEntry<T>);
  }

  @override
  bool operator ==(Object other) {
    return ChangeTrackerEntryMapper.ensureInitialized()
        .equalsValue(this as ChangeTrackerEntry<T>, other);
  }

  @override
  int get hashCode {
    return ChangeTrackerEntryMapper.ensureInitialized()
        .hashValue(this as ChangeTrackerEntry<T>);
  }
}

extension ChangeTrackerEntryValueCopy<$R, $Out, T>
    on ObjectCopyWith<$R, ChangeTrackerEntry<T>, $Out> {
  ChangeTrackerEntryCopyWith<$R, ChangeTrackerEntry<T>, $Out, T>
      get $asChangeTrackerEntry => $base.as(
          (v, t, t2) => _ChangeTrackerEntryCopyWithImpl<$R, $Out, T>(v, t, t2));
}

abstract class ChangeTrackerEntryCopyWith<$R, $In extends ChangeTrackerEntry<T>,
    $Out, T> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ChangedEntity<T>,
          ChangedEntityCopyWith<$R, ChangedEntity<T>, ChangedEntity<T>, T>>
      get changes;
  $R call(
      {String? id,
      ChangeSource? source,
      String? title,
      ChangeTrackerStatus? status,
      List<ChangedEntity<T>>? changes,
      double? progress,
      String? errorMessage,
      DateTime? startedAt,
      DateTime? finishedAt});
  ChangeTrackerEntryCopyWith<$R2, $In, $Out2, T> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ChangeTrackerEntryCopyWithImpl<$R, $Out, T>
    extends ClassCopyWithBase<$R, ChangeTrackerEntry<T>, $Out>
    implements ChangeTrackerEntryCopyWith<$R, ChangeTrackerEntry<T>, $Out, T> {
  _ChangeTrackerEntryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChangeTrackerEntry> $mapper =
      ChangeTrackerEntryMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ChangedEntity<T>,
          ChangedEntityCopyWith<$R, ChangedEntity<T>, ChangedEntity<T>, T>>
      get changes => ListCopyWith($value.changes,
          (v, t) => v.copyWith.$chain(t), (v) => call(changes: v));
  @override
  $R call(
          {Object? id = $none,
          ChangeSource? source,
          String? title,
          ChangeTrackerStatus? status,
          List<ChangedEntity<T>>? changes,
          Object? progress = $none,
          Object? errorMessage = $none,
          Object? startedAt = $none,
          Object? finishedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (source != null) #source: source,
        if (title != null) #title: title,
        if (status != null) #status: status,
        if (changes != null) #changes: changes,
        if (progress != $none) #progress: progress,
        if (errorMessage != $none) #errorMessage: errorMessage,
        if (startedAt != $none) #startedAt: startedAt,
        if (finishedAt != $none) #finishedAt: finishedAt
      }));
  @override
  ChangeTrackerEntry<T> $make(CopyWithData data) => ChangeTrackerEntry(
      id: data.get(#id, or: $value.id),
      source: data.get(#source, or: $value.source),
      title: data.get(#title, or: $value.title),
      status: data.get(#status, or: $value.status),
      changes: data.get(#changes, or: $value.changes),
      progress: data.get(#progress, or: $value.progress),
      errorMessage: data.get(#errorMessage, or: $value.errorMessage),
      startedAt: data.get(#startedAt, or: $value.startedAt),
      finishedAt: data.get(#finishedAt, or: $value.finishedAt));

  @override
  ChangeTrackerEntryCopyWith<$R2, ChangeTrackerEntry<T>, $Out2, T>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ChangeTrackerEntryCopyWithImpl<$R2, $Out2, T>($value, $cast, t);
}
