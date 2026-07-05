import 'package:boo_mondai/features/app_theme/controllers/tool_bar.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ToolBarController', () {
    test('block quote prefixes the whole list line at the cursor', () {
      final controller = ToolBarController();
      final textController = TextEditingController(text: '- List item');
      textController.selection = const TextSelection.collapsed(offset: 4);

      controller.setActiveTextController(textController);
      controller.insertBlockQuote();

      expect(textController.text, '> - List item');

      controller.dispose();
      textController.dispose();
    });

    test('block quote prefixes whole lines touched by a partial selection', () {
      final controller = ToolBarController();
      final textController = TextEditingController(
        text: 'Intro\n- First\n1. Second\nOutro',
      );
      textController.selection = const TextSelection(
        baseOffset: 8,
        extentOffset: 18,
      );

      controller.setActiveTextController(textController);
      controller.insertBlockQuote();

      expect(textController.text, 'Intro\n> - First\n> 1. Second\nOutro');

      controller.dispose();
      textController.dispose();
    });

    test('applies camel case to selected text', () {
      final fixture = _toolbarFixture('hello world-example_text');

      fixture.controller.applyCamelCase();

      expect(fixture.textController.text, 'helloWorldExampleText');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'helloWorldExampleText',
      );
      fixture.dispose();
    });

    test('applies pascal case to selected text', () {
      final fixture = _toolbarFixture('hello world-example_text');

      fixture.controller.applyPascalCase();

      expect(fixture.textController.text, 'HelloWorldExampleText');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'HelloWorldExampleText',
      );
      fixture.dispose();
    });

    test('applies snake case to selected text', () {
      final fixture = _toolbarFixture('helloWorld Example-text');

      fixture.controller.applySnakeCase();

      expect(fixture.textController.text, 'hello_world_example_text');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'hello_world_example_text',
      );
      fixture.dispose();
    });

    test('applies kebab case to selected text', () {
      final fixture = _toolbarFixture('helloWorld Example_text');

      fixture.controller.applyKebabCase();

      expect(fixture.textController.text, 'hello-world-example-text');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'hello-world-example-text',
      );
      fixture.dispose();
    });

    test('applies title case to selected text', () {
      final fixture = _toolbarFixture('helloWorld example-text');

      fixture.controller.applyTitleCase();

      expect(fixture.textController.text, 'Hello World Example Text');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'Hello World Example Text',
      );
      fixture.dispose();
    });

    test(
      'toggles selected text between uppercase and lowercase without deselecting',
      () {
        final fixture = _toolbarFixture('hello');

        fixture.controller.toggleUpperLowerCase();

        expect(fixture.textController.text, 'HELLO');
        expect(
          fixture.textController.selection.textInside(
            fixture.textController.text,
          ),
          'HELLO',
        );

        fixture.controller.toggleUpperLowerCase();

        expect(fixture.textController.text, 'hello');
        expect(
          fixture.textController.selection.textInside(
            fixture.textController.text,
          ),
          'hello',
        );
        fixture.dispose();
      },
    );

    test('case action falls back to the current word without a selection', () {
      final controller = ToolBarController();
      final textController = TextEditingController(text: 'keep hello-world ok');
      textController.selection = const TextSelection.collapsed(offset: 8);

      controller.setActiveTextController(textController);
      controller.applyPascalCase();

      expect(textController.text, 'keep HelloWorld ok');
      expect(
        textController.selection.textInside(textController.text),
        'HelloWorld',
      );

      controller.dispose();
      textController.dispose();
    });

    test('indents whole lines touched by a partial selection', () {
      final controller = ToolBarController();
      final textController = TextEditingController(text: 'Intro\nA\nB\nOutro');
      textController.selection = const TextSelection(
        baseOffset: 7,
        extentOffset: 9,
      );

      controller.setActiveTextController(textController);
      controller.indentSelectedLines();

      expect(textController.text, 'Intro\n  A\n  B\nOutro');

      controller.dispose();
      textController.dispose();
    });

    test('unindents whole lines touched by a partial selection', () {
      final controller = ToolBarController();
      final textController = TextEditingController(
        text: 'Intro\n  A\n\tB\n C\nOutro',
      );
      textController.selection = const TextSelection(
        baseOffset: 9,
        extentOffset: 14,
      );

      controller.setActiveTextController(textController);
      controller.unindentSelectedLines();

      expect(textController.text, 'Intro\nA\nB\nC\nOutro');

      controller.dispose();
      textController.dispose();
    });
  });
}

_ToolBarFixture _toolbarFixture(String text) {
  final controller = ToolBarController();
  final textController = TextEditingController(text: text);
  textController.selection = TextSelection(
    baseOffset: 0,
    extentOffset: text.length,
  );
  controller.setActiveTextController(textController);
  return _ToolBarFixture(controller, textController);
}

class _ToolBarFixture {
  const _ToolBarFixture(this.controller, this.textController);

  final ToolBarController controller;
  final TextEditingController textController;

  void dispose() {
    controller.dispose();
    textController.dispose();
  }
}
