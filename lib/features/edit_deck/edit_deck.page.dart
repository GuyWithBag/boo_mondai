// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        EditDeckAppBar,
        EditDeckBottomNavBar,
        EditDeckEditorBody,
        EditDeckSideBar,
        Scaffold,
        useScaffoldController,
        showSnackbar,
        useEditDeckController,
        Button,
        AppTokens;
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
    final titleController = useTextEditingController();
    final scaffoldController = useScaffoldController(isFloatingSideBar: true);

    useEffect(() {
      final deckTitle = controller.deck?.title;
      if (deckTitle != null && titleController.text.isEmpty) {
        titleController.text = deckTitle;
      }
      return null;
    }, [controller.deck?.id, controller.deck?.title]);

    useEffect(() {
      controller.ensureVisibleQuestionType();
      return null;
    }, [controller.questionType]);

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
        titleController: titleController,
        onSave: () async {
          if (!validate()) return;

          await controller.saveDeck(title: titleController.text);
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
      resizeToAvoidBottomInset: false,
      inheritMainBottomNavBarHeight: false,
      body: Form(
        key: formKey,
        child: EditDeckEditorBody(editor: controller),
      ),
    );
  }
}
