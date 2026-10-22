import 'package:signals_hooks/signals_hooks.dart';

class SelectionController<T> {
  SelectionController({
    Set<T> selectedValues = const {},
    this.onSelectionChanged,
    int? maxSelected,
    bool multiple = false,
    bool isEnabled = true,
    bool emptySelectionAllowed = true,
  }) : maxSelected = signal(null),
       multiple = signal(multiple),
       emptySelectionAllowed = signal(emptySelectionAllowed),
       isEnabled = signal(isEnabled),
       selectedValues = signal(selectedValues);

  final void Function(Set<T> selection)? onSelectionChanged;
  final Signal<Set<T>> selectedValues;

  late final Signal<bool> multiple;
  late final Signal<int?> maxSelected;
  late final Signal<bool> emptySelectionAllowed;
  late final Signal<bool> isEnabled;

  late final Computed<Set<T>> normalizedSelectedValues = computed(
    () => clampSelection(
      selectedValues.value,
      multiple: multiple.value,
      maxSelected: maxSelected.value,
    ),
  );
  late final Computed<T?> selectedValue = computed(
    () => selectedValues.value.isEmpty ? null : selectedValues.value.first,
  );
  late final EffectCleanup selectionEffect = effect(() {
    final normalized = normalizedSelectedValues.value;
    final current = untracked(() => selectedValues.value);

    if (setEquals(current, normalized)) return;

    selectedValues.value = normalized;
  });

  bool isSelected(T value) =>
      selectedValues.value.contains(value) && isEnabled.value;

  void select(T value) {
    if (!isEnabled.value) return;

    final next = multiple.value ? {...selectedValues.value, value} : {value};
    setSelected(next);
  }

  void toggle(T value) {
    if (!isEnabled.value) return;

    if (!selectedValues.value.contains(value)) {
      select(value);
      return;
    }

    if (!emptySelectionAllowed.value && selectedValues.value.length == 1) {
      return;
    }

    setSelected({...selectedValues.value}..remove(value));
  }

  void clear() {
    if (!emptySelectionAllowed.value) return;

    setSelected(const {});
  }

  void setSelected(Iterable<T> values) {
    if (!isEnabled.value) return;

    final normalized = clampSelection(
      values,
      multiple: multiple.value,
      maxSelected: maxSelected.value,
    );
    if (setEquals(selectedValues.value, normalized)) return;
    if (!emptySelectionAllowed.value && normalized.isEmpty) return;

    selectedValues.value = normalized;
    if (onSelectionChanged != null) {
      onSelectionChanged!(Set.unmodifiable(selectedValues.value));
    }
  }

  void dispose() {
    selectionEffect();
    selectedValue.dispose();
    normalizedSelectedValues.dispose();
  }
}

Set<T> clampSelection<T>(
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

bool setEquals<T>(Set<T> a, Set<T> b) {
  if (a.length != b.length) return false;

  for (final value in a) {
    if (!b.contains(value)) return false;
  }

  return true;
}
