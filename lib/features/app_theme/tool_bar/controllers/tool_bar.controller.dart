import 'package:boo_mondai/lib.barrel.dart' show ToolBarAction;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ToolBarController {
  final activeTextController = signal<TextEditingController?>(null);
  final activeTextAllowsAttachments = signal(false);
  final isDisposed = signal(false);

  late final hasActiveTextController = computed(
    () => activeTextController.value != null,
  );
  late final canUseAttachments = computed(
    () => hasActiveTextController.value && activeTextAllowsAttachments.value,
  );

  void setActiveTextController(
    TextEditingController controller, {
    bool allowAttachments = false,
  }) {
    if (isDisposed.value) return;
    if (activeTextController.value == controller &&
        activeTextAllowsAttachments.value == allowAttachments) {
      return;
    }
    activeTextController.value = controller;
    activeTextAllowsAttachments.value = allowAttachments;
  }

  void clearActiveTextController(TextEditingController controller) {
    if (isDisposed.value) return;
    if (activeTextController.value != controller) return;

    activeTextController.value = null;
    activeTextAllowsAttachments.value = false;
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
    activeTextAllowsAttachments.value = false;
  }
}
