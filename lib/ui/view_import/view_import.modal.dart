import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        ErrorText,
        LoadingIndicator,
        SegmentOption,
        SegmentedControl,
        ViewImportController;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

Future<bool?> showViewImportModal(BuildContext context) {
  return showModal<bool>(
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
    final importMode = controller.importMode.value;
    final shouldShowDeckTitle = controller.shouldShowDeckTitle.value;
    final canImportText = controller.canImportText.value;
    final canImportFile =
        !shouldShowDeckTitle ||
        controller.formDeckTitle.value.trim().isNotEmpty;
    final isBusy =
        controller.isImporting.value || controller.isPickingFile.value;
    final error = controller.error.value;

    useEffect(() => controller.dispose, [controller]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: tokens.spaceLayoutGapXsm),
        SegmentedControl<DeckImportMode>(
          value: importMode,
          onChanged: controller.setImportMode,
          enabled: !isBusy,
          options: const [
            SegmentOption(value: DeckImportMode.decks, label: 'Decks'),
            SegmentOption(value: DeckImportMode.cardTemplates, label: 'Cards'),
          ],
        ),
        if (shouldShowDeckTitle) ...[
          SizedBox(height: tokens.spaceLayoutGapSm),
          TextField(
            controller: controller.formDeckTitleController,
            variants: const [TextFieldSize.normal, TextFieldFrame.outline],
            placeholder: 'Deck title for imported cards',
            maxLines: 1,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
        ],
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
        if (error != null) ...[
          SizedBox(height: tokens.spaceLayoutGapSm),
          ErrorText.exception(error),
        ],
        SizedBox(height: tokens.spaceLayoutGapSm),
        Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Expanded(
              child: Button(
                onPressed: canImportText && !isBusy
                    ? () => controller.importFromText(context)
                    : null,
                leading: isBusy
                    ? const LoadingIndicator()
                    : const Icon(Icons.text_snippet_outlined),
                variants: const [ButtonColor.primary],
                child: const Text('Import from text'),
              ),
            ),
            Expanded(
              child: Button(
                onPressed: canImportFile && !isBusy
                    ? () => controller.importFromFile(context)
                    : null,
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
