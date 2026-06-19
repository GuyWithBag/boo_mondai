// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        EditDeckAppbar,
        EditDeckBottomNavbar,
        EditDeckEditorBody,
        EditDeckSidebar,
        Scaffold,
        showSnackbar,
        useEditDeckController,
        useEditDeckEditor,
        Button,
        ButtonColor;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final controller = useEditDeckController(
      deckId: deckId,
      initialTemplateId: initialTemplateId,
    );
    final editor = useEditDeckEditor(controller);

    return Scaffold(
      appBar: EditDeckAppbar(
        titleController: editor.titleController,
        onSave: () async {
          await editor.saveDeck();
          if (!context.mounted) return;
          showSnackbar(context, message: 'Deck Saved');
        },
        isSaving: editor.isSaving,
      ),
      floatingActionButton: Button.icon(
        color: ButtonColor.primary,
        onPressed: editor.addTemplate,
        icon: Icons.add,
      ),
      sidebar: EditDeckSidebar(
        activeTemplateId: editor.activeTemplateId,
        onAdd: editor.addTemplate,
        onTemplateSelected: editor.selectTemplate,
        templates: controller.templates,
      ),
      bottomNavigationBar: editor.hasActiveTemplate
          ? EditDeckBottomNavbar(editor: editor)
          : null,
      haveSidebarOpenButton: true,
      hideAppBarOnScroll: true,
      floatingSidebar: true,
      body: Form(
        key: editor.formKey,
        child: EditDeckEditorBody(editor: editor),
      ),
    );
  }
}
