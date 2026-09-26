import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart'
    show ButtonColor, ModalAction, ModalTone, showModal;
import 'package:boo_mondai/features/search/models/search.token_shape.dart';
import 'package:boo_mondai/features/search/models/search_tokens.dart';
import 'package:boo_mondai/features/search_filter.modal/search_filter.modal_field_shell.dart';
import 'package:boo_mondai/features/search_filter.modal/search_filter.modal_editors.dart';
import 'package:boo_mondai/features/search_filter.modal/search_filter.modal_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

Future<String?> showSearchFilterModal({
  required BuildContext context,
  required SearchTokens currentTokens,
  List<SearchTokenShape>? tokenShapes,
  List<SearchTokenModalField> fields = const [],
  ModalTone tone = ModalTone.surface,
}) {
  final shapes = tokenShapes ?? currentTokens.tokenShapes;
  final tokenValues = ValueNotifier<Map<String, List<String>>>({
    for (final shape in shapes)
      shape.name: List<String>.of(currentTokens.getAll(shape)),
  });
  final freeText = ValueNotifier(currentTokens.freeText);

  return showModal<String?>(
    context: context,
    barrierDismissible: true,
    title: 'Search Filters',
    tone: tone,
    actions: [
      ModalAction<String?>(value: null, label: 'Cancel'),
      ModalAction<String?>(
        value: null,
        label: 'Reset',
        onPressed: () {
          freeText.value = currentTokens.freeText;
          tokenValues.value = {
            for (final shape in shapes)
              shape.name: List<String>.of(currentTokens.getAll(shape)),
          };
        },
        dismissesModal: false,
      ),
      ModalAction<String?>(
        value: null,
        label: 'Apply',
        color: ButtonColor.primary,
        valueBuilder: () => _formatSearchInput(
          freeText: freeText.value,
          tokenShapes: shapes,
          values: tokenValues.value,
        ),
      ),
    ],
    child: _SearchFilterBody(
      currentTokens: currentTokens,
      tokenShapes: shapes,
      fields: fields,
      freeText: freeText,
      tokenValues: tokenValues,
    ),
  ).whenComplete(() {
    freeText.dispose();
    tokenValues.dispose();
  });
}

class _SearchFilterBody extends HookWidget {
  const _SearchFilterBody({
    required this.currentTokens,
    required this.tokenShapes,
    required this.fields,
    required this.freeText,
    required this.tokenValues,
  });

  final SearchTokens currentTokens;
  final List<SearchTokenShape> tokenShapes;
  final List<SearchTokenModalField> fields;
  final ValueNotifier<String> freeText;
  final ValueNotifier<Map<String, List<String>>> tokenValues;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final currentFreeText = useListenable(freeText);
    final currentTokenValues = useListenable(tokenValues);
    final modalFields = _fieldsFor(tokenShapes, fields)
      ..sort((l, r) => l.tokenShape.order.compareTo(r.tokenShape.order));
    final maxContentHeight = MediaQuery.sizeOf(context).height * 0.50;

    void setTokenValues(SearchTokenShape shape, List<String> values) {
      tokenValues.value = {
        ...tokenValues.value,
        shape.name: List.unmodifiable(values),
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxContentHeight),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchFilterFieldShell(
                  label: 'Search terms',
                  child: SearchFilterTextEditor(
                    value: currentFreeText.value,
                    placeholder: 'Search',
                    onChanged: (value) => freeText.value = value,
                  ),
                ),
                if (modalFields.isNotEmpty)
                  SizedBox(height: tokens.spaceLayoutGapLg),
                for (var i = 0; i < modalFields.length; i++) ...[
                  SearchFilterFieldShell(
                    label: modalFields[i].label,
                    child: modalFields[i].buildEditor(
                      context,
                      currentTokens,
                      currentTokenValues.value[modalFields[i]
                              .tokenShape
                              .name] ??
                          const [],
                      (values) =>
                          setTokenValues(modalFields[i].tokenShape, values),
                    ),
                  ),
                  if (i != modalFields.length - 1)
                    SizedBox(height: tokens.spaceLayoutGapLg),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<SearchTokenModalField> _fieldsFor(
  List<SearchTokenShape> tokenShapes,
  List<SearchTokenModalField> fields,
) {
  if (fields.isNotEmpty) return [...fields];

  return [
    for (final shape in tokenShapes)
      SearchTokenModalField(
        tokenShape: shape,
        label: CasingHelper.toTitleCase(shape.name),
        buildEditor: (context, tokens, values, onChanged) {
          return SearchFilterChipEditor(
            values: values,
            placeholder: shape.name,
            onChanged: onChanged,
          );
        },
      ),
  ];
}

String _formatSearchInput({
  required String freeText,
  required List<SearchTokenShape> tokenShapes,
  required Map<String, List<String>> values,
}) {
  final parts = <String>[
    if (freeText.trim().isNotEmpty) freeText.trim(),
    for (final shape in tokenShapes)
      for (final value in values[shape.name] ?? const <String>[])
        if (value.trim().isNotEmpty) '${shape.name}:${_formatValue(value)}',
  ];

  return parts.join(' ').trim();
}

String _formatValue(String value) {
  final trimmed = value.trim();
  if (trimmed.contains(RegExp(r'[\s,]'))) return '"$trimmed"';
  return trimmed;
}
