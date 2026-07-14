import 'package:boo_mondai/lib.barrel.dart'
    show
        BlockQuoteToolBarAction,
        CamelCaseToolBarAction,
        IndentToolBarAction,
        KebabCaseToolBarAction,
        PascalCaseToolBarAction,
        SnakeCaseToolBarAction,
        TitleCaseToolBarAction,
        ToggleUpperLowerCaseToolBarAction,
        ToolBarController,
        UnindentToolBarAction;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ToolBarController', () {
    test('tracks attachment capability for the active text field', () {
      final controller = ToolBarController();
      final titleController = TextEditingController();
      final descriptionController = TextEditingController();

      controller.setActiveTextController(titleController);
      expect(controller.activeTextAllowsAttachments, isFalse);

      controller.setActiveTextController(
        descriptionController,
        allowAttachments: true,
      );
      expect(controller.activeTextAllowsAttachments, isTrue);

      controller.setActiveTextController(titleController);
      expect(controller.activeTextAllowsAttachments, isFalse);

      controller.dispose();
      titleController.dispose();
      descriptionController.dispose();
    });

    test('only clears the controller that currently owns the toolbar', () {
      final controller = ToolBarController();
      final firstController = TextEditingController();
      final secondController = TextEditingController();

      controller.setActiveTextController(firstController);
      controller.setActiveTextController(
        secondController,
        allowAttachments: true,
      );
      controller.clearActiveTextController(firstController);

      expect(controller.activeTextController, same(secondController));
      expect(controller.activeTextAllowsAttachments, isTrue);

      controller.clearActiveTextController(secondController);

      expect(controller.activeTextController, isNull);
      expect(controller.activeTextAllowsAttachments, isFalse);

      controller.dispose();
      firstController.dispose();
      secondController.dispose();
    });

    test('block quote prefixes the whole list line at the cursor', () async {
      final controller = ToolBarController();
      final textController = TextEditingController(text: '- List item');
      textController.selection = const TextSelection.collapsed(offset: 4);

      controller.setActiveTextController(textController);
      await controller.perform(const BlockQuoteToolBarAction());

      expect(textController.text, '> - List item');

      controller.dispose();
      textController.dispose();
    });

    test(
      'block quote prefixes whole lines touched by a partial selection',
      () async {
        final controller = ToolBarController();
        final textController = TextEditingController(
          text: 'Intro\n- First\n1. Second\nOutro',
        );
        textController.selection = const TextSelection(
          baseOffset: 8,
          extentOffset: 18,
        );

        controller.setActiveTextController(textController);
        await controller.perform(const BlockQuoteToolBarAction());

        expect(textController.text, 'Intro\n> - First\n> 1. Second\nOutro');

        controller.dispose();
        textController.dispose();
      },
    );

    test('applies camel case to selected text', () async {
      final fixture = _toolbarFixture('hello world-example_text');

      await fixture.controller.perform(const CamelCaseToolBarAction());

      expect(fixture.textController.text, 'helloWorldExampleText');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'helloWorldExampleText',
      );
      fixture.dispose();
    });

    test('applies pascal case to selected text', () async {
      final fixture = _toolbarFixture('hello world-example_text');

      await fixture.controller.perform(const PascalCaseToolBarAction());

      expect(fixture.textController.text, 'HelloWorldExampleText');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'HelloWorldExampleText',
      );
      fixture.dispose();
    });

    test('applies snake case to selected text', () async {
      final fixture = _toolbarFixture('helloWorld Example-text');

      await fixture.controller.perform(const SnakeCaseToolBarAction());

      expect(fixture.textController.text, 'hello_world_example_text');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'hello_world_example_text',
      );
      fixture.dispose();
    });

    test('applies kebab case to selected text', () async {
      final fixture = _toolbarFixture('helloWorld Example_text');

      await fixture.controller.perform(const KebabCaseToolBarAction());

      expect(fixture.textController.text, 'hello-world-example-text');
      expect(
        fixture.textController.selection.textInside(
          fixture.textController.text,
        ),
        'hello-world-example-text',
      );
      fixture.dispose();
    });

    test('applies title case to selected text', () async {
      final fixture = _toolbarFixture('helloWorld example-text');

      await fixture.controller.perform(const TitleCaseToolBarAction());

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
      () async {
        final fixture = _toolbarFixture('hello');

        await fixture.controller.perform(
          const ToggleUpperLowerCaseToolBarAction(),
        );

        expect(fixture.textController.text, 'HELLO');
        expect(
          fixture.textController.selection.textInside(
            fixture.textController.text,
          ),
          'HELLO',
        );

        await fixture.controller.perform(
          const ToggleUpperLowerCaseToolBarAction(),
        );

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

    test(
      'case action falls back to the current word without a selection',
      () async {
        final controller = ToolBarController();
        final textController = TextEditingController(
          text: 'keep hello-world ok',
        );
        textController.selection = const TextSelection.collapsed(offset: 8);

        controller.setActiveTextController(textController);
        await controller.perform(const PascalCaseToolBarAction());

        expect(textController.text, 'keep HelloWorld ok');
        expect(
          textController.selection.textInside(textController.text),
          'HelloWorld',
        );

        controller.dispose();
        textController.dispose();
      },
    );

    test('indents whole lines touched by a partial selection', () async {
      final controller = ToolBarController();
      final textController = TextEditingController(text: 'Intro\nA\nB\nOutro');
      textController.selection = const TextSelection(
        baseOffset: 7,
        extentOffset: 9,
      );

      controller.setActiveTextController(textController);
      await controller.perform(const IndentToolBarAction());

      expect(textController.text, 'Intro\n  A\n  B\nOutro');

      controller.dispose();
      textController.dispose();
    });

    test('unindents whole lines touched by a partial selection', () async {
      final controller = ToolBarController();
      final textController = TextEditingController(
        text: 'Intro\n  A\n\tB\n C\nOutro',
      );
      textController.selection = const TextSelection(
        baseOffset: 9,
        extentOffset: 14,
      );

      controller.setActiveTextController(textController);
      await controller.perform(const UnindentToolBarAction());

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
