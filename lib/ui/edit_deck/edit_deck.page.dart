// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        EditDeckBottomNavBar,
        EditDeckEditorBody,
        EditDeckSideBar,
        Scaffold,
        ToolBar,
        ToolBarController,
        EditDeckController,
        buildEditDeckAppBar;
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
    useEffect(() => controller.dispose, [controller]);

    final toolBarController = useMemoized(() => ToolBarController());
    useEffect(() => toolBarController.dispose, [toolBarController]);

    final tokens = context.themeTokens<AppTokens>();

    return Scaffold(
      isFloatingSideBar: true,
      appBar: buildEditDeckAppBar(context: context, controller: controller),
      floatingActionButton: Button.icon(
        icon: Icons.add,
        onPressed: () => controller.addTemplate(context),
        tokens: tokens,
      ),
      sidebar: EditDeckSideBar(controller: controller),
      bottomNavBar: controller.hasSelectedTemplate.value
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
        child: EditDeckEditorBody(controller: controller),
      ),
    );
  }
}
