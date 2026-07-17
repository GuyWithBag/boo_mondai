// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        EditDeckAppBar,
        EditDeckBottomNavBar,
        EditDeckEditorBody,
        EditDeckSideBar,
        Scaffold,
        StoredMediaPathHelper,
        ToolBar,
        showSnackbar,
        useEditDeckController,
        useScaffoldController,
        useToolBarController;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

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
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final scaffoldController = useScaffoldController(isFloatingSideBar: true);
    final toolBarController = useToolBarController();

    bool validate() => formKey.currentState?.validate() ?? true;

    void addTemplate() {
      if (!validate()) return;
      controller.addTemplate();
    }

    void selectTemplate(String templateId) {
      if (!validate()) return;
      controller.selectTemplate(templateId);
    }

    final tokens = context.themeTokens<AppTokens>();

    return Scaffold(
      controller: scaffoldController,
      appBar: EditDeckAppBar(
        titleController: controller.titleController,
        onSave: () async {
          if (!validate()) return;

          await controller.saveDeck(title: controller.titleController.text);
          if (!context.mounted) return;
          showSnackbar(context, message: 'Deck Saved');
        },
        isSaving: controller.isLoading,
      ),
      floatingActionButton: Button.icon(
        icon: Icons.add,
        onPressed: addTemplate,
        tokens: tokens,
      ),
      sidebar: EditDeckSideBar(
        activeTemplateId: controller.activeTemplateId,
        onAdd: addTemplate,
        onTemplateSelected: selectTemplate,
        templates: controller.templates,
      ),
      bottomNavBar: controller.hasActiveTemplate
          ? EditDeckBottomNavBar(editor: controller)
          : null,
      // bottomNavBar: EditDeckBottomNavBar(editor: controller),
      haveSideBarOpenButton: true,
      // hideAppBarOnScroll: true,
      // hideFloatingActionButtonOnScroll: true,
      // materialResizeToAvoidBottomInset: false,
      inheritMainBottomNavBarHeight: false,
      toolBar: ToolBar.withActions(
        controller: toolBarController,
        useAttachments: true,
        createAttachmentPath: (file) {
          final deck = controller.deck;
          if (deck == null || controller.activeTemplateId == null) return null;

          return StoredMediaPathHelper.deckAttachment(
            deckTitle: deck.title,
            fileName: file.name,
          );
        },
        onAttachmentInserted: controller.markDirty,
      ),
      body: Form(
        key: formKey,
        child: EditDeckEditorBody(editor: controller),
      ),
    );
  }
}
