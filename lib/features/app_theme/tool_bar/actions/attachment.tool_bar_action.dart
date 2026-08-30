import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show MarkdownHelper, ToolBarAction, ToolBarTextEditingControllerExtension;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';

final class AttachmentToolBarAction extends ToolBarAction {
  const AttachmentToolBarAction({this.createPath, this.onInserted});

  final String? Function(PlatformFile file)? createPath;
  final VoidCallback? onInserted;

  @override
  IconData get icon => Icons.image_outlined;

  @override
  bool get requiresAttachmentSupport => true;

  @override
  Future<void> perform(TextEditingController controller) async {
    final file = await FileSystemHandler.pickSupportedFile();
    if (file == null) return;

    // Assuming this is an absolute path?
    final path = createPath?.call(file);
    if (path == null) return;

    final markdown = await MarkdownHelper.fromFileToViewFileSyntax(
      path: path,
      file: file,
    );

    await FileSystemHandler.storeFile(path: path, file: file);

    if (markdown == null) return;

    controller.replaceSelection(markdown);
    onInserted?.call();
  }
}
