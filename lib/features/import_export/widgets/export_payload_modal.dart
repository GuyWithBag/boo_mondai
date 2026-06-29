import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, ButtonColor, buttonStyle, showModal;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Icons,
        ConstrainedBox,
        Icon,
        BoxConstraints,
        EdgeInsets,
        Text,
        Navigator,
        Theme,
        BorderRadius,
        Border,
        BoxDecoration,
        SelectableText,
        SingleChildScrollView,
        DecoratedBox,
        Builder;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:theme_variants/theme_variants.dart';

enum ExportPayloadModalResult { copied, savedToFile, dismissed }

Future<ExportPayloadModalResult?> showExportPayloadModal({
  required BuildContext context,
  required String title,
  required String body,
  required String payloadJson,
}) {
  Future<void> copyPayload(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: payloadJson));
    if (!context.mounted) return;
    Navigator.pop(context, ExportPayloadModalResult.copied);
  }

  Future<void> saveToFile(BuildContext context) async {
    await FilePicker.saveFile(
      dialogTitle: 'Export JSON',
      fileName: 'boo_mondai_export.json',
      type: FileType.custom,
      allowedExtensions: const ['json'],
      bytes: utf8.encode(payloadJson),
    );
    if (!context.mounted) return;
    Navigator.pop(context, ExportPayloadModalResult.savedToFile);
  }

  return showModal<ExportPayloadModalResult>(
    context: context,
    leading: const Icon(Icons.ios_share_rounded),
    title: title,
    subtitle: body,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 420),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: SelectableText(payloadJson),
        ),
      ),
    ),
    actionsCustom: [
      Builder(
        builder: (context) => Button(
          onPressed: () =>
              Navigator.pop(context, ExportPayloadModalResult.dismissed),
          child: const Text('Close'),
        ),
      ),
      Builder(
        builder: (context) => Button(
          onPressed: () => saveToFile(context),
          child: const Text('Export to File'),
        ),
      ),
      Builder(
        builder: (context) => Button(
          style: buttonStyle.resolve(
            context.themeTokens<AppTokens>(),
            const [ButtonColor.primary],
          ),
          onPressed: () => copyPayload(context),
          child: const Text('Copy JSON'),
        ),
      ),
    ],
  );
}
