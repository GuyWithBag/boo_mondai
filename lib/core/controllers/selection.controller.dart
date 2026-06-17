import 'package:flutter/foundation.dart';

class SelectionController<T> extends ChangeNotifier {
  final Set<T> _selected = {};

  bool get isSelecting => _selected.isNotEmpty;
  int get count => _selected.length;
  Set<T> get selectedItems => Set.unmodifiable(_selected);

  bool isSelected(T item) => _selected.contains(item);

  void toggle(T item) {
    if (_selected.contains(item)) {
      _selected.remove(item);
    } else {
      _selected.add(item);
    }
    notifyListeners();
  }

  void select(T item) {
    if (_selected.add(item)) {
      notifyListeners();
    }
  }

  void deselect(T item) {
    if (_selected.remove(item)) {
      notifyListeners();
    }
  }

  void selectAll(Iterable<T> items) {
    final before = _selected.length;
    _selected.addAll(items);
    if (_selected.length != before) {
      notifyListeners();
    }
  }

  void clear() {
    if (_selected.isEmpty) return;
    _selected.clear();
    notifyListeners();
  }

  void retainWhere(bool Function(T item) test) {
    final before = _selected.length;
    _selected.removeWhere((item) => !test(item));
    if (_selected.length != before) {
      notifyListeners();
    }
  }
}
