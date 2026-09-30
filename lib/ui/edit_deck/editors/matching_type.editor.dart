import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardVerticalAlignmentControl,
        EditDeckController,
        EditDeckFormValidator,
        FormField,
        MarkdownText,
        MarkdownTextMode,
        MatchingTypeEditorController,
        MatchingTypeValue,
        SectionEyebrow,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextFieldFrame,
        TextFieldSize,
        TextColor,
        TextSize,
        TextWeight,
        textStyle,
        surfaceStyle;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MatchingTypeEditor extends SignalHookWidget {
  const MatchingTypeEditor({required this.editDeckController, super.key});

  final EditDeckController editDeckController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useMemoized(
      () =>
          MatchingTypeEditorController(editDeckController: editDeckController),
      [editDeckController.selectedTemplateKey.value],
    );
    useEffect(() => controller.dispose, [controller]);
    final values = controller.values.value;

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        FormField(
          value: values,
          validator: EditDeckFormValidator.matchingPairs,
          builder: (_, field) => _MatchingTypeValuesPanel(
            controller: controller,
            onChanged: field.didChange,
          ),
        ),
        CardVerticalAlignmentControl(
          value: controller.template.verticallyCentered,
          onChanged: controller.onVerticalAlignmentControlChanged,
        ),
      ],
    );
  }
}

class _MatchingTypeValuesPanel extends StatelessWidget {
  const _MatchingTypeValuesPanel({
    required this.controller,
    required this.onChanged,
  });

  final MatchingTypeEditorController controller;
  final ValueChanged<List<MatchingTypeValue>> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final values = controller.values.value;
    final rowCount = controller.rowCount.value;

    void syncField() => onChanged(controller.values.value);

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: SectionEyebrow('Matching Values'.toUpperCase())),
              Text(
                '${values.length} values',
                style: textStyle.resolve(tokens, const [
                  TextSize.labelSmall,
                  TextWeight.body,
                  TextColor.muted,
                ]),
              ),
            ],
          ),
          Row(
            spacing: tokens.spaceLayoutGapSm,
            children: const [
              Expanded(child: _ColumnLabel('Column 1')),
              Expanded(child: _ColumnLabel('Column 2')),
            ],
          ),
          Column(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              for (var row = 0; row < rowCount; row++)
                _MatchingTypeRow(
                  controller: controller,
                  row: row,
                  canRemove: rowCount > 1,
                  onChanged: syncField,
                ),
            ],
          ),
          Button.dashed(
            tokens: tokens,
            leading: const Icon(Icons.add),
            onPressed: () {
              controller.addRow();
              syncField();
            },
            child: const Text('Add Row'),
          ),
        ],
      ),
    );
  }
}

class _ColumnLabel extends StatelessWidget {
  const _ColumnLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Text(
      label.toUpperCase(),
      style: textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
    );
  }
}

class _MatchingTypeRow extends StatelessWidget {
  const _MatchingTypeRow({
    required this.controller,
    required this.row,
    required this.canRemove,
    required this.onChanged,
  });

  final MatchingTypeEditorController controller;
  final int row;
  final bool canRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Row(
      spacing: tokens.spaceLayoutGapSm,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _MatchingTypeCell(
            value: controller.valueAt(0, row),
            column: 0,
            row: row,
            controller: controller,
            onChanged: onChanged,
          ),
        ),
        Icon(Icons.compare_arrows_rounded, color: tokens.colorTextMuted),
        Expanded(
          child: _MatchingTypeCell(
            value: controller.valueAt(1, row),
            column: 1,
            row: row,
            controller: controller,
            onChanged: onChanged,
          ),
        ),
        Button.iconOnlySmall(
          icon: Icons.delete_rounded,
          onPressed: canRemove
              ? () {
                  controller.removeRow(row);
                  onChanged();
                }
              : null,
        ),
      ],
    );
  }
}

class _MatchingTypeCell extends StatelessWidget {
  const _MatchingTypeCell({
    required this.value,
    required this.column,
    required this.row,
    required this.controller,
    required this.onChanged,
  });

  final MatchingTypeValue? value;
  final int column;
  final int row;
  final MatchingTypeEditorController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final value = this.value;

    final child = DragTarget<_MatchingTypeDragData>(
      onWillAcceptWithDetails: (details) =>
          details.data.column != column || details.data.row != row,
      onAcceptWithDetails: (details) {
        controller.moveValue(
          fromColumn: details.data.column,
          fromRow: details.data.row,
          toColumn: column,
          toRow: row,
        );
        onChanged();
      },
      builder: (context, candidates, _) {
        final isTargeted = candidates.isNotEmpty;
        return Surface(
          style: surfaceStyle.resolve(tokens, [
            isTargeted ? SurfaceColor.primarySoft : SurfaceColor.muted,
            SurfaceShape.roundedXsm,
            SurfacePadding.sm,
            SurfaceShadow.none,
          ]),
          child: Row(
            spacing: tokens.spaceLayoutGapXsm,
            children: [
              Icon(Icons.drag_indicator_rounded, color: tokens.colorTextMuted),
              Expanded(
                child: MarkdownText(
                  allowAttachments: true,
                  data: value?.text ?? '',
                  onChanged: (text) {
                    controller.updateValueText(
                      column: column,
                      row: row,
                      text: text,
                    );
                    onChanged();
                  },
                  mode: MarkdownTextMode.input,
                  variants: const [
                    TextFieldSize.labelLarge,
                    TextFieldFrame.outline,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (value == null) return child;

    return LongPressDraggable<_MatchingTypeDragData>(
      data: _MatchingTypeDragData(column: column, row: row),
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Opacity(opacity: 0.92, child: child),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.45, child: child),
      child: child,
    );
  }
}

class _MatchingTypeDragData {
  const _MatchingTypeDragData({required this.column, required this.row});

  final int column;
  final int row;
}
