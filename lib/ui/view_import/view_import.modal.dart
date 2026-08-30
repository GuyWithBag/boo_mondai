import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart'
    show
        TextColor,
        TextField,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        showModal,
        textStyle;
import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart' show ViewImportController;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

Future<String?> showViewImportModal(BuildContext context) {
  return showModal<String>(
    context: context,
    leading: const Icon(Icons.upload_file_outlined),
    title: 'Import',
    subtitle: 'Paste import data or choose a local file.',
    showCancelButton: true,
    child: const ViewImportModal(),
  );
}

class ViewImportModal extends SignalHookWidget {
  const ViewImportModal({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useMemoized(ViewImportController.new);

    useEffect(() => controller.dispose, [controller]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: tokens.spaceLayoutGapXsm),
        TextField(
          controller: controller.importTextController,
          variants: const [TextFieldSize.normal, TextFieldFrame.outline],
          placeholder: 'Deck Title',
          maxLines: 1,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: TextField(
            controller: controller.importTextController,
            variants: const [TextFieldSize.normal, TextFieldFrame.outline],
            placeholder: 'Paste JSON, CSV, or text import data here...',
            minLines: 8,
            maxLines: 12,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Expanded(
              child: Button(
                onPressed: controller.importText.isNotEmpty
                    ? () => controller.importFromText()
                    : null,
                leading: const Icon(Icons.text_snippet_outlined),
                variants: const [ButtonColor.primary],
                child: const Text('Import from text'),
              ),
            ),
            Expanded(
              child: Button(
                onPressed: controller.isPickingFile.value
                    ? null
                    : () => controller.importFromFile(),
                leading: const Icon(Icons.folder_open_outlined),
                child: Text(
                  controller.isPickingFile.value
                      ? 'Opening...'
                      : 'Import from file',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
