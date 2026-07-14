import 'package:flutter/widgets.dart';

abstract class ToolBarAction {
  const ToolBarAction();

  IconData get icon;

  bool get requiresAttachmentSupport => false;

  Future<void> perform(TextEditingController controller);
}
