// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review.dto.dart';

class ReviewMapper extends ClassMapperBase<Review> {
  ReviewMapper._();

  static ReviewMapper? _instance;
  static ReviewMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewMapper._());
      CommentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Review';

  static String _$id(Review v) => v.id;
  static const Field<Review, String> _f$id = Field('id', _$id);
  static String _$contentId(Review v) => v.contentId;
  static const Field<Review, String> _f$contentId =
      Field('contentId', _$contentId, key: r'content_id');
  static String _$title(Review v) => v.title;
  static const Field<Review, String> _f$title = Field('title', _$title);
  static String _$body(Review v) => v.body;
  static const Field<Review, String> _f$body = Field('body', _$body);
  static DateTime _$deletedAt(Review v) => v.deletedAt;
  static const Field<Review, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at');
  static bool _$isNegative(Review v) => v.isNegative;
  static const Field<Review, bool> _f$isNegative = Field(
      'isNegative', _$isNegative,
      key: r'is_negative', opt: true, def: false);

  @override
  final MappableFields<Review> fields = const {
    #id: _f$id,
    #contentId: _f$contentId,
    #title: _f$title,
    #body: _f$body,
    #deletedAt: _f$deletedAt,
    #isNegative: _f$isNegative,
  };

  static Review _instantiate(DecodingData data) {
    return Review(
        id: data.dec(_f$id),
        contentId: data.dec(_f$contentId),
        title: data.dec(_f$title),
        body: data.dec(_f$body),
        deletedAt: data.dec(_f$deletedAt),
        isNegative: data.dec(_f$isNegative));
  }

  @override
  final Function instantiate = _instantiate;

  static Review fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Review>(map);
  }

  static Review fromJson(String json) {
    return ensureInitialized().decodeJson<Review>(json);
  }
}

mixin ReviewMappable {
  String toJson() {
    return ReviewMapper.ensureInitialized().encodeJson<Review>(this as Review);
  }

  Map<String, dynamic> toMap() {
    return ReviewMapper.ensureInitialized().encodeMap<Review>(this as Review);
  }

  ReviewCopyWith<Review, Review, Review> get copyWith =>
      _ReviewCopyWithImpl<Review, Review>(this as Review, $identity, $identity);
  @override
  String toString() {
    return ReviewMapper.ensureInitialized().stringifyValue(this as Review);
  }

  @override
  bool operator ==(Object other) {
    return ReviewMapper.ensureInitialized().equalsValue(this as Review, other);
  }

  @override
  int get hashCode {
    return ReviewMapper.ensureInitialized().hashValue(this as Review);
  }
}

extension ReviewValueCopy<$R, $Out> on ObjectCopyWith<$R, Review, $Out> {
  ReviewCopyWith<$R, Review, $Out> get $asReview =>
      $base.as((v, t, t2) => _ReviewCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReviewCopyWith<$R, $In extends Review, $Out>
    implements CommentCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? contentId,
      String? title,
      String? body,
      DateTime? deletedAt,
      bool? isNegative});
  ReviewCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReviewCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Review, $Out>
    implements ReviewCopyWith<$R, Review, $Out> {
  _ReviewCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Review> $mapper = ReviewMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? contentId,
          String? title,
          String? body,
          DateTime? deletedAt,
          bool? isNegative}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (contentId != null) #contentId: contentId,
        if (title != null) #title: title,
        if (body != null) #body: body,
        if (deletedAt != null) #deletedAt: deletedAt,
        if (isNegative != null) #isNegative: isNegative
      }));
  @override
  Review $make(CopyWithData data) => Review(
      id: data.get(#id, or: $value.id),
      contentId: data.get(#contentId, or: $value.contentId),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body),
      deletedAt: data.get(#deletedAt, or: $value.deletedAt),
      isNegative: data.get(#isNegative, or: $value.isNegative));

  @override
  ReviewCopyWith<$R2, Review, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ReviewCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
