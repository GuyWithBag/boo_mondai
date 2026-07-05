import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SelectionController<T> extends ChangeNotifier {
  SelectionController({
    Iterable<T> selectedValues = const [],
    bool multiple = false,
    int? maxSelected,
    bool emptySelectionAllowed = false,
    ValueChanged<Set<T>>? onSelectionChanged,
    bool isEnabled = true,
  }) : _selectedValues = _normalize(
         selectedValues,
         multiple: multiple,
         maxSelected: maxSelected,
       ),
       _isEnabled = isEnabled,
       _multiple = multiple,
       _maxSelected = maxSelected,
       _emptySelectionAllowed = emptySelectionAllowed,
       _onSelectionChanged = onSelectionChanged;

  Set<T> _selectedValues;
  bool _multiple;
  int? _maxSelected;
  bool _emptySelectionAllowed;
  ValueChanged<Set<T>>? _onSelectionChanged;
  bool _isEnabled;

  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  Set<T> get selectedValues => Set.unmodifiable(_selectedValues);
  bool get multiple => _multiple;
  int? get maxSelected => _maxSelected;
  bool get emptySelectionAllowed => _emptySelectionAllowed;

  T? get selectedValue =>
      _selectedValues.isEmpty ? null : _selectedValues.first;

  bool isSelected(T value) => _selectedValues.contains(value) && isEnabled;

  void update({
    required Iterable<T> selectedValues,
    required bool multiple,
    required int? maxSelected,
    required bool emptySelectionAllowed,
    required ValueChanged<Set<T>>? onSelectionChanged,
    bool notify = true,
  }) {
    _multiple = multiple;
    _maxSelected = maxSelected;
    _emptySelectionAllowed = emptySelectionAllowed;
    _onSelectionChanged = onSelectionChanged;

    final normalized = _normalize(
      selectedValues,
      multiple: multiple,
      maxSelected: maxSelected,
    );
    if (_setEquals(_selectedValues, normalized)) return;

    _selectedValues = normalized;
    if (notify) {
      notifyListeners();
    }
  }

  void select(T value) {
    if (!_isEnabled) return;
    final next = _multiple ? {..._selectedValues, value} : {value};
    _setSelected(next);
  }

  void toggle(T value) {
    if (!_isEnabled) return;
    if (!_selectedValues.contains(value)) {
      select(value);
      return;
    }

    if (!_emptySelectionAllowed && _selectedValues.length == 1) return;

    _setSelected({..._selectedValues}..remove(value));
  }

  void clear() {
    if (!_emptySelectionAllowed) return;
    _setSelected(const {});
  }

  void _setSelected(Iterable<T> values) {
    if (!_isEnabled) return;
    final normalized = _normalize(
      values,
      multiple: _multiple,
      maxSelected: _maxSelected,
    );
    if (_setEquals(_selectedValues, normalized)) return;
    if (!_emptySelectionAllowed && normalized.isEmpty) return;

    _selectedValues = normalized;
    notifyListeners();
    _onSelectionChanged?.call(Set.unmodifiable(_selectedValues));
  }

  static Set<T> _normalize<T>(
    Iterable<T> values, {
    required bool multiple,
    required int? maxSelected,
  }) {
    final selected = <T>{};
    final limit = multiple ? maxSelected : 1;

    for (final value in values) {
      if (limit != null && selected.length >= limit) break;
      selected.add(value);
    }

    return selected;
  }
}

SelectionController<T> useSelectionController<T>({
  Iterable<T>? selectedValues,
  bool multiple = false,
  int? maxSelected,
  bool emptySelectionAllowed = false,
  ValueChanged<Set<T>>? onSelectionChanged,
  bool isEnabled = true,
  List<Object?> keys = const [],
}) {
  final controller = useMemoized(
    () => SelectionController<T>(
      selectedValues: selectedValues ?? const [],
      multiple: multiple,
      maxSelected: maxSelected,
      emptySelectionAllowed: emptySelectionAllowed,
      onSelectionChanged: onSelectionChanged,
      isEnabled: isEnabled,
    ),
    keys,
  );

  if (selectedValues != null) {
    controller.update(
      selectedValues: selectedValues,
      multiple: multiple,
      maxSelected: maxSelected,
      emptySelectionAllowed: emptySelectionAllowed,
      onSelectionChanged: onSelectionChanged,
      notify: false,
    );
  }
  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}

bool _setEquals<T>(Set<T> a, Set<T> b) {
  if (a.length != b.length) return false;

  for (final value in a) {
    if (!b.contains(value)) return false;
  }

  return true;
}
