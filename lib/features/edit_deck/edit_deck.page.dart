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

    Future<void> addImageAttachment() async {
      final markdown = await controller
          .pickAndAddImageAttachmentMarkdownToActiveTemplate();
      if (markdown == null) return;

      toolBarController.insertMarkdown(markdown);
    }

    final tokens = context.themeTokens<AppTokens>();
    final canUseMarkdownActions = toolBarController.hasActiveTextController;

    Button markdownAction({
      required IconData icon,
      required VoidCallback onPressed,
    }) {
      return Button.icon(
        icon: icon,
        onPressed: canUseMarkdownActions ? onPressed : null,
        tokens: tokens,
      );
    }

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
      // resizeToAvoidBottomInset: false,
      resizeBodyForKeyboard: true,
      inheritMainBottomNavBarHeight: false,
      toolBar: ToolBar(
        actions: [
          Button.icon(
            icon: Icons.image_outlined,
            onPressed: canUseMarkdownActions ? addImageAttachment : null,
            tokens: tokens,
          ),
          markdownAction(
            icon: Icons.title,
            onPressed: () => toolBarController.insertHeading(1),
          ),
          markdownAction(
            icon: Icons.format_size,
            onPressed: () => toolBarController.insertHeading(2),
          ),
          markdownAction(
            icon: Icons.format_bold,
            onPressed: toolBarController.toggleBold,
          ),
          markdownAction(
            icon: Icons.format_italic,
            onPressed: toolBarController.toggleItalic,
          ),
          markdownAction(
            icon: Icons.format_strikethrough,
            onPressed: toolBarController.toggleStrikethrough,
          ),
          markdownAction(
            icon: Icons.code,
            onPressed: toolBarController.toggleInlineCode,
          ),
          markdownAction(
            icon: Icons.data_object,
            onPressed: toolBarController.insertCodeBlock,
          ),
          markdownAction(
            icon: Icons.format_quote,
            onPressed: toolBarController.insertBlockQuote,
          ),
          markdownAction(
            icon: Icons.format_list_bulleted,
            onPressed: toolBarController.insertUnorderedList,
          ),
          markdownAction(
            icon: Icons.format_list_numbered,
            onPressed: toolBarController.insertOrderedList,
          ),
          markdownAction(
            icon: Icons.check_box_outlined,
            onPressed: toolBarController.insertTaskList,
          ),
          markdownAction(
            icon: Icons.link,
            onPressed: toolBarController.insertLink,
          ),
          markdownAction(
            icon: Icons.add_photo_alternate_outlined,
            onPressed: toolBarController.insertImage,
          ),
          markdownAction(
            icon: Icons.horizontal_rule,
            onPressed: toolBarController.insertHorizontalRule,
          ),
          markdownAction(
            icon: Icons.table_chart_outlined,
            onPressed: toolBarController.insertTable,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: EditDeckEditorBody(
          editor: controller,
          onMarkdownFieldFocused: toolBarController.setActiveTextController,
        ),
      ),
    );
  }
}
