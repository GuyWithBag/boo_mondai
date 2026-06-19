// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        EditDeckController,
        EditDeckEditorBody,
        EditDeckAppbar,
        EditDeckSidebar,
        useEditDeckEditor,
        Scaffold;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class EditDeckPage extends HookWidget {
  const EditDeckPage({
    super.key,
    required this.deckId,
    required this.initialTemplateId,
  });

  final String deckId;
  final String? initialTemplateId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditDeckController(
        deckId: deckId,
        initialTemplateId: initialTemplateId,
      ),
      child: HookBuilder(
        builder: (context) {
          final controller = context.watch<EditDeckController>();
          final editor = useEditDeckEditor(controller);

          Future<void> handleSaveDeck() async {
            final saved = await editor.saveDeck();
            if (saved && context.mounted) {
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

          return Scaffold(
            appBar: EditDeckAppbar(
              titleController: editor.titleController,
              onSave: handleSaveDeck,
              isSaving: editor.isSaving,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: editor.addTemplate,
              tooltip: 'Add new card',
              child: const Icon(Icons.add),
            ),
            sidebar: EditDeckSidebar(
              activeTemplateId: editor.activeTemplateId,
              onAdd: editor.addTemplate,
              onTemplateSelected: editor.selectTemplate,
              templates: controller.templates,
            ),
            haveSidebarOpenButton: true,
            floatingSidebar: true,
            body: Form(
              key: editor.formKey,
              child: EditDeckEditorBody(editor: editor),
            ),
          );
        },
      ),
    );
  }
}
