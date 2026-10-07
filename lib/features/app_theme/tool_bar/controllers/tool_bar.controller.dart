import 'package:boo_mondai/lib.barrel.dart' show ToolBarAction;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ToolBarController {
  final activeTextController = signal<TextEditingController?>(null);
  final activeFocusNode = signal<FocusNode?>(null);
  final activeTextAllowsAttachments = signal(false);
  final isVisible = signal(false);
  final isDisposed = signal(false);

  late final hasActiveTextController = computed(
    () => activeTextController.value != null,
  );
  late final canUseAttachments = computed(
    () => hasActiveTextController.value && activeTextAllowsAttachments.value,
  );

  void show({
    required TextEditingController textController,
    required FocusNode focusNode,
    bool allowAttachments = false,
  }) {
    if (isDisposed.value) return;
    if (activeTextController.value == textController &&
        activeFocusNode.value == focusNode &&
        activeTextAllowsAttachments.value == allowAttachments) {
      isVisible.value = true;
      return;
    }
    activeTextController.value = textController;
    activeFocusNode.value = focusNode;
    activeTextAllowsAttachments.value = allowAttachments;
    isVisible.value = true;
  }

  void hide({TextEditingController? textController}) {
    if (isDisposed.value) return;
    if (textController != null &&
        activeTextController.value != textController) {
      return;
    }

    activeTextController.value = null;
    activeFocusNode.value = null;
    activeTextAllowsAttachments.value = false;
    isVisible.value = false;
  }

  void setActiveTextController(
    TextEditingController controller, {
    bool allowAttachments = false,
  }) {
    if (isDisposed.value) return;
    activeTextController.value = controller;
    activeFocusNode.value = null;
    activeTextAllowsAttachments.value = allowAttachments;
    isVisible.value = true;
  }

  void clearActiveTextController(TextEditingController controller) {
    hide(textController: controller);
  }

  bool canPerform(ToolBarAction action) {
    if (!hasActiveTextController.value) return false;
    return !action.requiresAttachmentSupport || canUseAttachments.value;
  }

  Future<void> perform(ToolBarAction action) async {
    final controller = activeTextController.value;
    if (controller == null || !canPerform(action)) return;

    await action.perform(controller);
  }

  void dispose() {
    if (isDisposed.value) return;
    isDisposed.value = true;

    activeTextController.value = null;
    activeFocusNode.value = null;
    activeTextAllowsAttachments.value = false;
    isVisible.value = false;
  }
}
