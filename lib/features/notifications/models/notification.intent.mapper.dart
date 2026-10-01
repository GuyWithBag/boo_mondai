// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification.intent.dart';

class NotificationIntentTypeMapper extends EnumMapper<NotificationIntentType> {
  NotificationIntentTypeMapper._();

  static NotificationIntentTypeMapper? _instance;
  static NotificationIntentTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationIntentTypeMapper._());
    }
    return _instance!;
  }

  static NotificationIntentType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NotificationIntentType decode(dynamic value) {
    switch (value) {
      case r'review_reminder':
        return NotificationIntentType.reviewReminder;
      case r'streak_reminder':
        return NotificationIntentType.streakReminder;
      case r'download_complete':
        return NotificationIntentType.downloadComplete;
      case r'sync_complete':
        return NotificationIntentType.syncComplete;
      case r'first_drill_survey':
        return NotificationIntentType.firstDrillSurvey;
      case r'study_deck_review':
        return NotificationIntentType.studyDeckReview;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NotificationIntentType self) {
    switch (self) {
      case NotificationIntentType.reviewReminder:
        return r'review_reminder';
      case NotificationIntentType.streakReminder:
        return r'streak_reminder';
      case NotificationIntentType.downloadComplete:
        return r'download_complete';
      case NotificationIntentType.syncComplete:
        return r'sync_complete';
      case NotificationIntentType.firstDrillSurvey:
        return r'first_drill_survey';
      case NotificationIntentType.studyDeckReview:
        return r'study_deck_review';
    }
  }
}

extension NotificationIntentTypeMapperExtension on NotificationIntentType {
  String toValue() {
    NotificationIntentTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NotificationIntentType>(this)
        as String;
  }
}

class NotificationIntentMapper extends ClassMapperBase<NotificationIntent> {
  NotificationIntentMapper._();

  static NotificationIntentMapper? _instance;
  static NotificationIntentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationIntentMapper._());
      NotificationIntentTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationIntent';

  static int _$id(NotificationIntent v) => v.id;
  static const Field<NotificationIntent, int> _f$id = Field('id', _$id);
  static String _$profileId(NotificationIntent v) => v.profileId;
  static const Field<NotificationIntent, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');
  static NotificationIntentType _$type(NotificationIntent v) => v.type;
  static const Field<NotificationIntent, NotificationIntentType> _f$type =
      Field('type', _$type);
  static String _$title(NotificationIntent v) => v.title;
  static const Field<NotificationIntent, String> _f$title =
      Field('title', _$title);
  static String _$body(NotificationIntent v) => v.body;
  static const Field<NotificationIntent, String> _f$body =
      Field('body', _$body);
  static DateTime _$createdAt(NotificationIntent v) => v.createdAt;
  static const Field<NotificationIntent, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(NotificationIntent v) => v.updatedAt;
  static const Field<NotificationIntent, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static DateTime _$purgeAt(NotificationIntent v) => v.purgeAt;
  static const Field<NotificationIntent, DateTime> _f$purgeAt =
      Field('purgeAt', _$purgeAt, key: r'purge_at');
  static String? _$route(NotificationIntent v) => v.route;
  static const Field<NotificationIntent, String> _f$route =
      Field('route', _$route, opt: true);
  static bool _$persistInInbox(NotificationIntent v) => v.persistInInbox;
  static const Field<NotificationIntent, bool> _f$persistInInbox = Field(
      'persistInInbox', _$persistInInbox,
      key: r'persist_in_inbox', opt: true, def: false);
  static bool _$showSystemNotification(NotificationIntent v) =>
      v.showSystemNotification;
  static const Field<NotificationIntent, bool> _f$showSystemNotification =
      Field('showSystemNotification', _$showSystemNotification,
          key: r'show_system_notification', opt: true, def: true);
  static DateTime? _$readAt(NotificationIntent v) => v.readAt;
  static const Field<NotificationIntent, DateTime> _f$readAt =
      Field('readAt', _$readAt, key: r'read_at', opt: true);
  static DateTime? _$deletedAt(NotificationIntent v) => v.deletedAt;
  static const Field<NotificationIntent, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at', opt: true);
  static int _$purgeAfterDays(NotificationIntent v) => v.purgeAfterDays;
  static const Field<NotificationIntent, int> _f$purgeAfterDays = Field(
      'purgeAfterDays', _$purgeAfterDays,
      key: r'purge_after_days', opt: true, def: 30);

  @override
  final MappableFields<NotificationIntent> fields = const {
    #id: _f$id,
    #profileId: _f$profileId,
    #type: _f$type,
    #title: _f$title,
    #body: _f$body,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #purgeAt: _f$purgeAt,
    #route: _f$route,
    #persistInInbox: _f$persistInInbox,
    #showSystemNotification: _f$showSystemNotification,
    #readAt: _f$readAt,
    #deletedAt: _f$deletedAt,
    #purgeAfterDays: _f$purgeAfterDays,
  };

  static NotificationIntent _instantiate(DecodingData data) {
    return NotificationIntent(
        id: data.dec(_f$id),
        profileId: data.dec(_f$profileId),
        type: data.dec(_f$type),
        title: data.dec(_f$title),
        body: data.dec(_f$body),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        purgeAt: data.dec(_f$purgeAt),
        route: data.dec(_f$route),
        persistInInbox: data.dec(_f$persistInInbox),
        showSystemNotification: data.dec(_f$showSystemNotification),
        readAt: data.dec(_f$readAt),
        deletedAt: data.dec(_f$deletedAt),
        purgeAfterDays: data.dec(_f$purgeAfterDays));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationIntent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationIntent>(map);
  }

  static NotificationIntent fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationIntent>(json);
  }
}

mixin NotificationIntentMappable {
  String toJson() {
    return NotificationIntentMapper.ensureInitialized()
        .encodeJson<NotificationIntent>(this as NotificationIntent);
  }

  Map<String, dynamic> toMap() {
    return NotificationIntentMapper.ensureInitialized()
        .encodeMap<NotificationIntent>(this as NotificationIntent);
  }

  NotificationIntentCopyWith<NotificationIntent, NotificationIntent,
          NotificationIntent>
      get copyWith => _NotificationIntentCopyWithImpl<NotificationIntent,
          NotificationIntent>(this as NotificationIntent, $identity, $identity);
  @override
  String toString() {
    return NotificationIntentMapper.ensureInitialized()
        .stringifyValue(this as NotificationIntent);
  }

  @override
  bool operator ==(Object other) {
    return NotificationIntentMapper.ensureInitialized()
        .equalsValue(this as NotificationIntent, other);
  }

  @override
  int get hashCode {
    return NotificationIntentMapper.ensureInitialized()
        .hashValue(this as NotificationIntent);
  }
}

extension NotificationIntentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationIntent, $Out> {
  NotificationIntentCopyWith<$R, NotificationIntent, $Out>
      get $asNotificationIntent => $base.as(
          (v, t, t2) => _NotificationIntentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NotificationIntentCopyWith<$R, $In extends NotificationIntent,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      String? profileId,
      NotificationIntentType? type,
      String? title,
      String? body,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? purgeAt,
      String? route,
      bool? persistInInbox,
      bool? showSystemNotification,
      DateTime? readAt,
      DateTime? deletedAt,
      int? purgeAfterDays});
  NotificationIntentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationIntentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationIntent, $Out>
    implements NotificationIntentCopyWith<$R, NotificationIntent, $Out> {
  _NotificationIntentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationIntent> $mapper =
      NotificationIntentMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          String? profileId,
          NotificationIntentType? type,
          String? title,
          String? body,
          DateTime? createdAt,
          DateTime? updatedAt,
          DateTime? purgeAt,
          Object? route = $none,
          bool? persistInInbox,
          bool? showSystemNotification,
          Object? readAt = $none,
          Object? deletedAt = $none,
          int? purgeAfterDays}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (profileId != null) #profileId: profileId,
        if (type != null) #type: type,
        if (title != null) #title: title,
        if (body != null) #body: body,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (purgeAt != null) #purgeAt: purgeAt,
        if (route != $none) #route: route,
        if (persistInInbox != null) #persistInInbox: persistInInbox,
        if (showSystemNotification != null)
          #showSystemNotification: showSystemNotification,
        if (readAt != $none) #readAt: readAt,
        if (deletedAt != $none) #deletedAt: deletedAt,
        if (purgeAfterDays != null) #purgeAfterDays: purgeAfterDays
      }));
  @override
  NotificationIntent $make(CopyWithData data) => NotificationIntent(
      id: data.get(#id, or: $value.id),
      profileId: data.get(#profileId, or: $value.profileId),
      type: data.get(#type, or: $value.type),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      purgeAt: data.get(#purgeAt, or: $value.purgeAt),
      route: data.get(#route, or: $value.route),
      persistInInbox: data.get(#persistInInbox, or: $value.persistInInbox),
      showSystemNotification:
          data.get(#showSystemNotification, or: $value.showSystemNotification),
      readAt: data.get(#readAt, or: $value.readAt),
      deletedAt: data.get(#deletedAt, or: $value.deletedAt),
      purgeAfterDays: data.get(#purgeAfterDays, or: $value.purgeAfterDays));

  @override
  NotificationIntentCopyWith<$R2, NotificationIntent, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _NotificationIntentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
