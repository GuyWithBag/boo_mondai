import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, FormField, createAppThemeController;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_variants/theme_variants.dart';

void main() {
  testWidgets('validates programmatic listenable changes', (tester) async {
    final controller = TextEditingController(text: 'Initial value');
    final formKey = GlobalKey<FormState>();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: Form(
          key: formKey,
          child: FormField<String>(
            value: controller.text,
            listenable: controller,
            valueReader: () => controller.text,
            validator: _required,
            builder: (_, field) =>
                TextField(controller: controller, onChanged: field.didChange),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isTrue);

    controller.clear();
    await tester.pump();

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('moves synchronization to a replacement listenable', (
    tester,
  ) async {
    final firstController = TextEditingController(text: 'First value');
    final secondController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var useSecondController = false;
    late StateSetter rebuild;
    addTearDown(firstController.dispose);
    addTearDown(secondController.dispose);

    await tester.pumpWidget(
      _TestApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            final controller = useSecondController
                ? secondController
                : firstController;
            return Form(
              key: formKey,
              child: FormField<String>(
                value: controller.text,
                listenable: controller,
                valueReader: () => controller.text,
                validator: _required,
                builder: (_, field) => TextField(
                  controller: controller,
                  onChanged: field.didChange,
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isTrue);

    rebuild(() => useSecondController = true);
    await tester.pump();
    await tester.pump();

    expect(formKey.currentState!.validate(), isFalse);
  });

  testWidgets('preserves the width of a positioned child', (tester) async {
    const fieldKey = Key('positioned-field');

    await tester.pumpWidget(
      const _TestApp(
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: FormField<String>(
                key: fieldKey,
                value: '',
                builder: _buildFixedWidthChild,
              ),
            ),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byKey(fieldKey)).width, 100);
  });
}

Widget _buildFixedWidthChild(
  BuildContext context,
  FormFieldState<String> field,
) {
  return const SizedBox(width: 100, height: 100);
}

String? _required(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ThemeVariantsProvider<AppTokens>(
      controller: createAppThemeController(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(home: Scaffold(body: child)),
      ),
    );
  }
}
