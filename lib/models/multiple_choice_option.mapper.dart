// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'multiple_choice_option.dart';

class MultipleChoiceOptionMapper extends ClassMapperBase<MultipleChoiceOption> {
  MultipleChoiceOptionMapper._();

  static MultipleChoiceOptionMapper? _instance;
  static MultipleChoiceOptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MultipleChoiceOptionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MultipleChoiceOption';

  static String _$id(MultipleChoiceOption v) => v.id;
  static const Field<MultipleChoiceOption, String> _f$id = Field('id', _$id);
  static String _$templateId(MultipleChoiceOption v) => v.templateId;
  static const Field<MultipleChoiceOption, String> _f$templateId =
      Field('templateId', _$templateId);
  static String _$optionText(MultipleChoiceOption v) => v.optionText;
  static const Field<MultipleChoiceOption, String> _f$optionText =
      Field('optionText', _$optionText);
  static bool _$isCorrect(MultipleChoiceOption v) => v.isCorrect;
  static const Field<MultipleChoiceOption, bool> _f$isCorrect =
      Field('isCorrect', _$isCorrect);
  static int _$displayOrder(MultipleChoiceOption v) => v.displayOrder;
  static const Field<MultipleChoiceOption, int> _f$displayOrder =
      Field('displayOrder', _$displayOrder);

  @override
  final MappableFields<MultipleChoiceOption> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #optionText: _f$optionText,
    #isCorrect: _f$isCorrect,
    #displayOrder: _f$displayOrder,
  };

  static MultipleChoiceOption _instantiate(DecodingData data) {
    return MultipleChoiceOption(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        optionText: data.dec(_f$optionText),
        isCorrect: data.dec(_f$isCorrect),
        displayOrder: data.dec(_f$displayOrder));
  }

  @override
  final Function instantiate = _instantiate;

  static MultipleChoiceOption fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MultipleChoiceOption>(map);
  }

  static MultipleChoiceOption fromJson(String json) {
    return ensureInitialized().decodeJson<MultipleChoiceOption>(json);
  }
}

mixin MultipleChoiceOptionMappable {
  String toJson() {
    return MultipleChoiceOptionMapper.ensureInitialized()
        .encodeJson<MultipleChoiceOption>(this as MultipleChoiceOption);
  }

  Map<String, dynamic> toMap() {
    return MultipleChoiceOptionMapper.ensureInitialized()
        .encodeMap<MultipleChoiceOption>(this as MultipleChoiceOption);
  }

  MultipleChoiceOptionCopyWith<MultipleChoiceOption, MultipleChoiceOption,
      MultipleChoiceOption> get copyWith => _MultipleChoiceOptionCopyWithImpl<
          MultipleChoiceOption, MultipleChoiceOption>(
      this as MultipleChoiceOption, $identity, $identity);
  @override
  String toString() {
    return MultipleChoiceOptionMapper.ensureInitialized()
        .stringifyValue(this as MultipleChoiceOption);
  }

  @override
  bool operator ==(Object other) {
    return MultipleChoiceOptionMapper.ensureInitialized()
        .equalsValue(this as MultipleChoiceOption, other);
  }

  @override
  int get hashCode {
    return MultipleChoiceOptionMapper.ensureInitialized()
        .hashValue(this as MultipleChoiceOption);
  }
}

extension MultipleChoiceOptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MultipleChoiceOption, $Out> {
  MultipleChoiceOptionCopyWith<$R, MultipleChoiceOption, $Out>
      get $asMultipleChoiceOption => $base.as(
          (v, t, t2) => _MultipleChoiceOptionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MultipleChoiceOptionCopyWith<
    $R,
    $In extends MultipleChoiceOption,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? templateId,
      String? optionText,
      bool? isCorrect,
      int? displayOrder});
  MultipleChoiceOptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MultipleChoiceOptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MultipleChoiceOption, $Out>
    implements MultipleChoiceOptionCopyWith<$R, MultipleChoiceOption, $Out> {
  _MultipleChoiceOptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MultipleChoiceOption> $mapper =
      MultipleChoiceOptionMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? templateId,
          String? optionText,
          bool? isCorrect,
          int? displayOrder}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (optionText != null) #optionText: optionText,
        if (isCorrect != null) #isCorrect: isCorrect,
        if (displayOrder != null) #displayOrder: displayOrder
      }));
  @override
  MultipleChoiceOption $make(CopyWithData data) => MultipleChoiceOption(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      optionText: data.get(#optionText, or: $value.optionText),
      isCorrect: data.get(#isCorrect, or: $value.isCorrect),
      displayOrder: data.get(#displayOrder, or: $value.displayOrder));

  @override
  MultipleChoiceOptionCopyWith<$R2, MultipleChoiceOption, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MultipleChoiceOptionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
