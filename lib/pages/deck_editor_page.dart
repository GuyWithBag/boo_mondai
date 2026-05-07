// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckEditorPage extends HookWidget {
  const DeckEditorPage({
    super.key,
    required this.deckId,
    required this.initialTemplateId,
  });

  final String deckId;
  final String? initialTemplateId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeckEditorPageController(
        deckId: deckId,
        initialTemplateId: initialTemplateId,
      ),
      child: HookBuilder(
        builder: (context) {
          final controller = context.watch<DeckEditorPageController>();
          final formKey = useMemoized(GlobalKey<FormState>.new);

          Future<void> handleSaveDeck() async {
            if (formKey.currentState?.validate() ?? true) {
              await controller.saveDeck();
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Deck saved'),
                      duration: Duration(seconds: 1),
                    ),
                  );
              }
            }
          }

          final hasActiveTemplate =
              controller.activeTemplateId != null; // <-- Updated

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Deck'),
              actions: [
                if (controller.isDirty)
                  TextButton(
                    onPressed: controller.isLoading ? null : handleSaveDeck,
                    child: controller.isLoading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
              ],
            ),
            floatingActionButton: LayoutBuilder(
              builder: (ctx, constraints) {
                if (constraints.maxWidth >= 960) return const SizedBox.shrink();
                return FloatingActionButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? true) {
                      controller.addBlankTemplate(); // <-- Updated
                    }
                  },
                  tooltip: 'Add new card',
                  child: const Icon(Icons.add),
                );
              },
            ),
            body: Form(
              key: formKey,
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  final showSidebar = constraints.maxWidth >= 960;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showSidebar)
                        EditorSidebar(
                          templates: controller.templates, // <-- Updated
                          activeTemplateId:
                              controller.activeTemplateId, // <-- Updated
                          isAdding: false,
                          onAdd: () {
                            if (formKey.currentState?.validate() ?? true) {
                              controller.addBlankTemplate(); // <-- Updated
                            }
                          },
                          children: [
                            for (final template
                                in controller.templates) // <-- Updated
                              SidebarItem(
                                template: template, // <-- Updated
                                isActive:
                                    template.id == controller.activeTemplateId,
                                onTap: () {
                                  if (formKey.currentState?.validate() ??
                                      true) {
                                    controller.selectTemplate(template.id);
                                  }
                                },
                              ),
                          ],
                        ),
                      Expanded(
                        child: !hasActiveTemplate
                            ? NoCardSelected(
                                onAdd:
                                    controller.addBlankTemplate, // <-- Updated
                                isAdding: false,
                              )
                            : const EditorMain(),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
