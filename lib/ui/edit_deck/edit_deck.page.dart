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
        useToolBarController,
        EditDeckController;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckPage extends SignalHookWidget {
  const EditDeckPage({
    super.key,
    required this.deckId,
    required this.initialTemplateId,
  });

  final String deckId;
  final String? initialTemplateId;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => EditDeckController(
        deckId: deckId,
        initialTemplateId: initialTemplateId,
      ),
    );

    final toolBarController = useToolBarController();

    final tokens = context.themeTokens<AppTokens>();
    final isSaving = controller.isLoading.value;

    return Scaffold(
      isFloatingSideBar: true,
      appBar: EditDeckAppBar(
        titleController: controller.titleController,
        onSave: () async {
          await controller.save();
          if (!context.mounted) return;
          showSnackbar(context, message: 'Deck Saved');
        },
        isSaving: isSaving,
      ),
      floatingActionButton: Button.icon(
        icon: Icons.add,
        onPressed: controller.onAddTemplatePressed,
        tokens: tokens,
      ),
      sidebar: EditDeckSideBar(controller: controller),
      bottomNavBar: controller.hasCurrentTemplate.value
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
        createAttachmentPath: controller.createAttachmentPath,
      ),
      body: Form(
        key: controller.formKey,
        child: EditDeckEditorBody(editor: controller),
      ),
    );
  }
}
