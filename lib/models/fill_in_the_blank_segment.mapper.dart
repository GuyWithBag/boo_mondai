// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fill_in_the_blank_segment.dart';

class FillInTheBlankSegmentMapper
    extends ClassMapperBase<FillInTheBlankSegment> {
  FillInTheBlankSegmentMapper._();

  static FillInTheBlankSegmentMapper? _instance;
  static FillInTheBlankSegmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FillInTheBlankSegmentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FillInTheBlankSegment';

  static String _$id(FillInTheBlankSegment v) => v.id;
  static const Field<FillInTheBlankSegment, String> _f$id = Field('id', _$id);
  static String _$cardId(FillInTheBlankSegment v) => v.cardId;
  static const Field<FillInTheBlankSegment, String> _f$cardId =
      Field('cardId', _$cardId);
  static String _$fullText(FillInTheBlankSegment v) => v.fullText;
  static const Field<FillInTheBlankSegment, String> _f$fullText =
      Field('fullText', _$fullText);
  static int _$blankStart(FillInTheBlankSegment v) => v.blankStart;
  static const Field<FillInTheBlankSegment, int> _f$blankStart =
      Field('blankStart', _$blankStart);
  static int _$blankEnd(FillInTheBlankSegment v) => v.blankEnd;
  static const Field<FillInTheBlankSegment, int> _f$blankEnd =
      Field('blankEnd', _$blankEnd);
  static String _$correctAnswer(FillInTheBlankSegment v) => v.correctAnswer;
  static const Field<FillInTheBlankSegment, String> _f$correctAnswer =
      Field('correctAnswer', _$correctAnswer);

  @override
  final MappableFields<FillInTheBlankSegment> fields = const {
    #id: _f$id,
    #cardId: _f$cardId,
    #fullText: _f$fullText,
    #blankStart: _f$blankStart,
    #blankEnd: _f$blankEnd,
    #correctAnswer: _f$correctAnswer,
  };

  static FillInTheBlankSegment _instantiate(DecodingData data) {
    return FillInTheBlankSegment(
        id: data.dec(_f$id),
        cardId: data.dec(_f$cardId),
        fullText: data.dec(_f$fullText),
        blankStart: data.dec(_f$blankStart),
        blankEnd: data.dec(_f$blankEnd),
        correctAnswer: data.dec(_f$correctAnswer));
  }

  @override
  final Function instantiate = _instantiate;

  static FillInTheBlankSegment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FillInTheBlankSegment>(map);
  }

  static FillInTheBlankSegment fromJson(String json) {
    return ensureInitialized().decodeJson<FillInTheBlankSegment>(json);
  }
}

mixin FillInTheBlankSegmentMappable {
  String toJson() {
    return FillInTheBlankSegmentMapper.ensureInitialized()
        .encodeJson<FillInTheBlankSegment>(this as FillInTheBlankSegment);
  }

  Map<String, dynamic> toMap() {
    return FillInTheBlankSegmentMapper.ensureInitialized()
        .encodeMap<FillInTheBlankSegment>(this as FillInTheBlankSegment);
  }

  FillInTheBlankSegmentCopyWith<FillInTheBlankSegment, FillInTheBlankSegment,
      FillInTheBlankSegment> get copyWith => _FillInTheBlankSegmentCopyWithImpl<
          FillInTheBlankSegment, FillInTheBlankSegment>(
      this as FillInTheBlankSegment, $identity, $identity);
  @override
  String toString() {
    return FillInTheBlankSegmentMapper.ensureInitialized()
        .stringifyValue(this as FillInTheBlankSegment);
  }

  @override
  bool operator ==(Object other) {
    return FillInTheBlankSegmentMapper.ensureInitialized()
        .equalsValue(this as FillInTheBlankSegment, other);
  }

  @override
  int get hashCode {
    return FillInTheBlankSegmentMapper.ensureInitialized()
        .hashValue(this as FillInTheBlankSegment);
  }
}

extension FillInTheBlankSegmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FillInTheBlankSegment, $Out> {
  FillInTheBlankSegmentCopyWith<$R, FillInTheBlankSegment, $Out>
      get $asFillInTheBlankSegment => $base.as(
          (v, t, t2) => _FillInTheBlankSegmentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FillInTheBlankSegmentCopyWith<
    $R,
    $In extends FillInTheBlankSegment,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? cardId,
      String? fullText,
      int? blankStart,
      int? blankEnd,
      String? correctAnswer});
  FillInTheBlankSegmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FillInTheBlankSegmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FillInTheBlankSegment, $Out>
    implements FillInTheBlankSegmentCopyWith<$R, FillInTheBlankSegment, $Out> {
  _FillInTheBlankSegmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FillInTheBlankSegment> $mapper =
      FillInTheBlankSegmentMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? cardId,
          String? fullText,
          int? blankStart,
          int? blankEnd,
          String? correctAnswer}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (cardId != null) #cardId: cardId,
        if (fullText != null) #fullText: fullText,
        if (blankStart != null) #blankStart: blankStart,
        if (blankEnd != null) #blankEnd: blankEnd,
        if (correctAnswer != null) #correctAnswer: correctAnswer
      }));
  @override
  FillInTheBlankSegment $make(CopyWithData data) => FillInTheBlankSegment(
      id: data.get(#id, or: $value.id),
      cardId: data.get(#cardId, or: $value.cardId),
      fullText: data.get(#fullText, or: $value.fullText),
      blankStart: data.get(#blankStart, or: $value.blankStart),
      blankEnd: data.get(#blankEnd, or: $value.blankEnd),
      correctAnswer: data.get(#correctAnswer, or: $value.correctAnswer));

  @override
  FillInTheBlankSegmentCopyWith<$R2, FillInTheBlankSegment, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _FillInTheBlankSegmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
