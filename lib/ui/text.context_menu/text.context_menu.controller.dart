import 'package:boo_mondai/ui/text.context_menu/text.context_menu.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class TextContextMenuController {
  TextContextMenuController._() {
    editableTextEffect = effect(() {
      final currentEditableTextState = editableTextState.value;
      if (currentEditableTextState == null) return null;

      void handleChange() {
        handleEditableTextChanged(currentEditableTextState);
      }

      final textController = currentEditableTextState.widget.controller;
      textController.addListener(handleChange);

      return () {
        textController.removeListener(handleChange);
      };
    });
  }

  static final instance = TextContextMenuController._();
  static const quickActionCount = 4;
  static const buttonDimension = 44.0;
  static const dropdownMaxHeight = 220.0;
  static const estimatedWidth = buttonDimension * 5 + 16;
  static const verticalGap = 8.0;
  static const screenMargin = 8.0;

  final editableTextState = signal<EditableTextState?>(null);
  final isVisible = signal(false);
  final isDropdownOpen = signal(false);
  final entry = signal<OverlayEntry?>(null);
  final left = signal(0.0);
  final top = signal(0.0);
  final selection = signal<TextSelection?>(null);

  late final EffectCleanup editableTextEffect;

  late final buttonItems = computed<List<ContextMenuButtonItem>>(
    () => editableTextState.value?.contextMenuButtonItems ?? const [],
  );

  late final quickItems = computed<List<ContextMenuButtonItem>>(
    () => buttonItems.value.take(quickActionCount).toList(),
  );

  late final dropdownItems = computed<List<ContextMenuButtonItem>>(
    () => buttonItems.value,
  );

  late final anchors = computed<TextSelectionToolbarAnchors?>(
    () => editableTextState.value?.contextMenuAnchors,
  );

  late final hasButtonItems = computed(() => buttonItems.value.isNotEmpty);

  void show({
    required BuildContext context,
    required EditableTextState editableTextState,
  }) {
    this.editableTextState.value = editableTextState;
    selection.value = editableTextState.widget.controller.selection;
    updatePosition(context);
    isVisible.value = hasButtonItems.value;
    isDropdownOpen.value = false;

    if (!isVisible.value) {
      dismiss();
      return;
    }

    final currentEntry = entry.value;
    if (currentEntry != null && currentEntry.mounted) {
      currentEntry.markNeedsBuild();
      return;
    }

    late final OverlayEntry nextEntry;
    nextEntry = OverlayEntry(builder: (_) => const TextContextMenu());

    entry.value = nextEntry;
    Overlay.of(context, rootOverlay: true).insert(nextEntry);
  }

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void handleEditableTextChanged(EditableTextState editableTextState) {
    if (this.editableTextState.value != editableTextState) return;

    final nextSelection = editableTextState.widget.controller.selection;
    final previousSelection = selection.value;
    selection.value = nextSelection;

    if (nextSelection.isCollapsed ||
        (previousSelection != null && nextSelection != previousSelection)) {
      dismiss();
    }
  }

  void updatePosition(BuildContext context) {
    final anchors = this.anchors.value;
    if (anchors == null) return;

    final screenSize = MediaQuery.sizeOf(context);
    final primary = anchors.primaryAnchor;
    final secondary = anchors.secondaryAnchor ?? primary;
    final nextLeft = primary.dx - estimatedWidth / 2;
    final rowHeight = buttonDimension + screenMargin * 2;
    final aboveTop = primary.dy - rowHeight - verticalGap;
    final belowTop = secondary.dy + verticalGap;

    left.value = nextLeft.clamp(
      screenMargin,
      screenSize.width - estimatedWidth - screenMargin,
    );
    top.value = (aboveTop >= screenMargin ? aboveTop : belowTop).clamp(
      screenMargin,
      screenSize.height - screenMargin,
    );
  }

  void press(ContextMenuButtonItem item) {
    item.onPressed?.call();
    dismiss();
  }

  void dismiss() {
    isVisible.value = false;
    isDropdownOpen.value = false;
    editableTextState.value = null;
    selection.value = null;

    final currentEntry = entry.value;
    entry.value = null;
    if (currentEntry?.mounted ?? false) {
      currentEntry!.remove();
    }
  }

  void dispose() {
    editableTextEffect();
  }

  IconData iconFor(ContextMenuButtonItem item) {
    return switch (item.type) {
      ContextMenuButtonType.cut => Icons.content_cut,
      ContextMenuButtonType.copy => Icons.content_copy,
      ContextMenuButtonType.paste => Icons.content_paste,
      ContextMenuButtonType.selectAll => Icons.select_all,
      ContextMenuButtonType.delete => Icons.delete_outline,
      ContextMenuButtonType.lookUp => Icons.manage_search,
      ContextMenuButtonType.searchWeb => Icons.travel_explore,
      ContextMenuButtonType.share => Icons.ios_share,
      ContextMenuButtonType.liveTextInput => Icons.document_scanner_outlined,
      ContextMenuButtonType.custom => Icons.text_fields,
    };
  }

  String labelFor(BuildContext context, ContextMenuButtonItem item) {
    if (item.label != null) return item.label!;

    final localizations = MaterialLocalizations.of(context);
    return switch (item.type) {
      ContextMenuButtonType.cut => localizations.cutButtonLabel,
      ContextMenuButtonType.copy => localizations.copyButtonLabel,
      ContextMenuButtonType.paste => localizations.pasteButtonLabel,
      ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
      ContextMenuButtonType.delete => localizations.deleteButtonTooltip,
      ContextMenuButtonType.lookUp => localizations.lookUpButtonLabel,
      ContextMenuButtonType.searchWeb => localizations.searchWebButtonLabel,
      ContextMenuButtonType.share => localizations.shareButtonLabel,
      ContextMenuButtonType.liveTextInput => 'Live Text',
      ContextMenuButtonType.custom => '',
    };
  }
}
