// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vocabulary_test_result.dart';

class VocabularyTestResultMapper extends ClassMapperBase<VocabularyTestResult> {
  VocabularyTestResultMapper._();

  static VocabularyTestResultMapper? _instance;
  static VocabularyTestResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VocabularyTestResultMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VocabularyTestResult';

  static String _$id(VocabularyTestResult v) => v.id;
  static const Field<VocabularyTestResult, String> _f$id = Field('id', _$id);
  static String _$userId(VocabularyTestResult v) => v.userId;
  static const Field<VocabularyTestResult, String> _f$userId =
      Field('userId', _$userId);
  static String _$testSet(VocabularyTestResult v) => v.testSet;
  static const Field<VocabularyTestResult, String> _f$testSet =
      Field('testSet', _$testSet);
  static int _$score(VocabularyTestResult v) => v.score;
  static const Field<VocabularyTestResult, int> _f$score =
      Field('score', _$score);
  static Map<String, dynamic> _$answers(VocabularyTestResult v) => v.answers;
  static const Field<VocabularyTestResult, Map<String, dynamic>> _f$answers =
      Field('answers', _$answers);
  static DateTime _$submittedAt(VocabularyTestResult v) => v.submittedAt;
  static const Field<VocabularyTestResult, DateTime> _f$submittedAt =
      Field('submittedAt', _$submittedAt);

  @override
  final MappableFields<VocabularyTestResult> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #testSet: _f$testSet,
    #score: _f$score,
    #answers: _f$answers,
    #submittedAt: _f$submittedAt,
  };

  static VocabularyTestResult _instantiate(DecodingData data) {
    return VocabularyTestResult(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        testSet: data.dec(_f$testSet),
        score: data.dec(_f$score),
        answers: data.dec(_f$answers),
        submittedAt: data.dec(_f$submittedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static VocabularyTestResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VocabularyTestResult>(map);
  }

  static VocabularyTestResult fromJson(String json) {
    return ensureInitialized().decodeJson<VocabularyTestResult>(json);
  }
}

mixin VocabularyTestResultMappable {
  String toJson() {
    return VocabularyTestResultMapper.ensureInitialized()
        .encodeJson<VocabularyTestResult>(this as VocabularyTestResult);
  }

  Map<String, dynamic> toMap() {
    return VocabularyTestResultMapper.ensureInitialized()
        .encodeMap<VocabularyTestResult>(this as VocabularyTestResult);
  }

  VocabularyTestResultCopyWith<VocabularyTestResult, VocabularyTestResult,
      VocabularyTestResult> get copyWith => _VocabularyTestResultCopyWithImpl<
          VocabularyTestResult, VocabularyTestResult>(
      this as VocabularyTestResult, $identity, $identity);
  @override
  String toString() {
    return VocabularyTestResultMapper.ensureInitialized()
        .stringifyValue(this as VocabularyTestResult);
  }

  @override
  bool operator ==(Object other) {
    return VocabularyTestResultMapper.ensureInitialized()
        .equalsValue(this as VocabularyTestResult, other);
  }

  @override
  int get hashCode {
    return VocabularyTestResultMapper.ensureInitialized()
        .hashValue(this as VocabularyTestResult);
  }
}

extension VocabularyTestResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VocabularyTestResult, $Out> {
  VocabularyTestResultCopyWith<$R, VocabularyTestResult, $Out>
      get $asVocabularyTestResult => $base.as(
          (v, t, t2) => _VocabularyTestResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VocabularyTestResultCopyWith<
    $R,
    $In extends VocabularyTestResult,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get answers;
  $R call(
      {String? id,
      String? userId,
      String? testSet,
      int? score,
      Map<String, dynamic>? answers,
      DateTime? submittedAt});
  VocabularyTestResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _VocabularyTestResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VocabularyTestResult, $Out>
    implements VocabularyTestResultCopyWith<$R, VocabularyTestResult, $Out> {
  _VocabularyTestResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VocabularyTestResult> $mapper =
      VocabularyTestResultMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get answers => MapCopyWith($value.answers,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(answers: v));
  @override
  $R call(
          {String? id,
          String? userId,
          String? testSet,
          int? score,
          Map<String, dynamic>? answers,
          DateTime? submittedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (testSet != null) #testSet: testSet,
        if (score != null) #score: score,
        if (answers != null) #answers: answers,
        if (submittedAt != null) #submittedAt: submittedAt
      }));
  @override
  VocabularyTestResult $make(CopyWithData data) => VocabularyTestResult(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      testSet: data.get(#testSet, or: $value.testSet),
      score: data.get(#score, or: $value.score),
      answers: data.get(#answers, or: $value.answers),
      submittedAt: data.get(#submittedAt, or: $value.submittedAt));

  @override
  VocabularyTestResultCopyWith<$R2, VocabularyTestResult, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _VocabularyTestResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
