import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppModalTone,
        AppTokens,
        Button,
        ButtonTone,
        Modal,
        TextSize,
        TextTone,
        TextWeight,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:theme_variants/theme_variants.dart';

sealed class ExportPayloadModalResult {
  const ExportPayloadModalResult();
}

class ExportPayloadCopied extends ExportPayloadModalResult {
  const ExportPayloadCopied();
}

class ExportPayloadSavedToFile extends ExportPayloadModalResult {
  const ExportPayloadSavedToFile();
}

class ExportPayloadDismissed extends ExportPayloadModalResult {
  const ExportPayloadDismissed();
}

class ExportPayloadModal extends StatelessWidget {
  const ExportPayloadModal({
    super.key,
    required this.title,
    required this.body,
    required this.payloadJson,
  });

  final String title;
  final String body;
  final String payloadJson;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    Future<void> copyPayload() async {
      await Clipboard.setData(ClipboardData(text: payloadJson));
      if (!context.mounted) return;
      Navigator.pop(context, const ExportPayloadCopied());
    }

    Future<void> saveToFile() async {
      await FilePicker.saveFile(
        dialogTitle: 'Export JSON',
        fileName: 'boo_mondai_export.json',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        bytes: utf8.encode(payloadJson),
      );
      if (!context.mounted) return;
      Navigator.pop(context, const ExportPayloadSavedToFile());
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spaceLayoutGapLg),
      child: Modal(
        tone: AppModalTone.surface,
        leading: const Icon(Icons.ios_share_rounded),
        actions: [
          Button(
            onPressed: () =>
                Navigator.pop(context, const ExportPayloadDismissed()),
            child: const Text('Close'),
          ),
          Button(onPressed: saveToFile, child: const Text('Export to File')),
          Button(
            variants: const [ButtonTone.filled],
            onPressed: copyPayload,
            child: const Text('Copy JSON'),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: textStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: textStyle.resolve(tokens, const [
                TextSize.label,
                TextWeight.body,
                TextTone.secondary,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapLg),
            ConstrainedBox(
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
                  child: SelectableText(
                    payloadJson,
                    style: textStyle.resolve(tokens, const [
                      TextSize.label,
                      TextWeight.body,
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<ExportPayloadModalResult?> showExportPayloadModal({
  required BuildContext context,
  required String title,
  required String body,
  required String payloadJson,
}) {
  return showDialog<ExportPayloadModalResult>(
    context: context,
    builder: (_) =>
        ExportPayloadModal(title: title, body: body, payloadJson: payloadJson),
  );
}
