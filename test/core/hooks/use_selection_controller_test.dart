import 'package:boo_mondai/core/hooks/use_selection_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('selects one value in single select mode', () {
    final changes = <Set<int>>[];
    final controller = SelectionValueController<int>(
      selectedValues: const [1],
      onSelectionChanged: changes.add,
    );
    addTearDown(controller.dispose);

    controller.select(2);

    expect(controller.selectedValues, {2});
    expect(changes, [
      {2},
    ]);
  });

  test('toggles multiple values when multiple select is enabled', () {
    final controller = SelectionValueController<int>(
      multiple: true,
      emptySelectionAllowed: true,
    );
    addTearDown(controller.dispose);

    controller.toggle(1);
    controller.toggle(2);
    controller.toggle(1);

    expect(controller.selectedValues, {2});
  });

  test('does not exceed max selected limit', () {
    final controller = SelectionValueController<int>(
      multiple: true,
      maxSelected: 2,
    );
    addTearDown(controller.dispose);

    controller.select(1);
    controller.select(2);
    controller.select(3);

    expect(controller.selectedValues, {1, 2});
  });
}
