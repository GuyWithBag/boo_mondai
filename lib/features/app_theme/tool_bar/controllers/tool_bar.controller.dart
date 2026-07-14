import 'package:boo_mondai/lib.barrel.dart' show Controller, ToolBarAction;
import 'package:flutter/material.dart';

class ToolBarController extends Controller {
  TextEditingController? _activeTextController;
  bool _activeTextAllowsAttachments = false;

  TextEditingController? get activeTextController => _activeTextController;
  bool get hasActiveTextController => _activeTextController != null;
  bool get activeTextAllowsAttachments =>
      hasActiveTextController && _activeTextAllowsAttachments;

  void setActiveTextController(
    TextEditingController controller, {
    bool allowAttachments = false,
  }) {
    if (_activeTextController == controller &&
        _activeTextAllowsAttachments == allowAttachments) {
      return;
    }
    _activeTextController = controller;
    _activeTextAllowsAttachments = allowAttachments;
    notifyListeners();
  }

  void clearActiveTextController(TextEditingController controller) {
    if (_activeTextController != controller) return;

    _activeTextController = null;
    _activeTextAllowsAttachments = false;
    notifyListeners();
  }

  bool canPerform(ToolBarAction action) {
    if (!hasActiveTextController) return false;
    return !action.requiresAttachmentSupport || activeTextAllowsAttachments;
  }

  Future<void> perform(ToolBarAction action) async {
    final controller = _activeTextController;
    if (controller == null || !canPerform(action)) return;

    await action.perform(controller);
  }
}
