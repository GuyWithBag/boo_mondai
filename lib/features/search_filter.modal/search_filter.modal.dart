import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ButtonColor,
        ModalAction,
        ModalTone,
        SearchFilter,
        SearchFilterCodec,
        showModal;
import 'package:boo_mondai/features/search_filter.modal/search_filter.modal_field_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

Future<TFilter?> showSearchFilterModal<TFilter extends SearchFilter>({
  required BuildContext context,
  required SearchFilterCodec<TFilter> codec,
  required TFilter currentFilter,
  ModalTone tone = ModalTone.surface,
}) {
  final filter = ValueNotifier<TFilter>(currentFilter);

  return showModal<TFilter?>(
    context: context,
    barrierDismissible: true,
    title: 'Search Filters',
    tone: tone,
    actions: [
      ModalAction<TFilter?>(value: null, label: 'Cancel'),
      ModalAction<TFilter?>(
        value: null,
        label: 'Reset',
        onPressed: () => filter.value = currentFilter,
        dismissesModal: false,
      ),
      ModalAction<TFilter?>(
        value: null,
        label: 'Apply',
        color: ButtonColor.primary,
        valueBuilder: () => filter.value,
      ),
    ],
    child: _SearchFilterBody<TFilter>(codec: codec, filter: filter),
  ).whenComplete(filter.dispose);
}

class _SearchFilterBody<TFilter extends SearchFilter> extends HookWidget {
  const _SearchFilterBody({required this.codec, required this.filter});

  final SearchFilterCodec<TFilter> codec;
  final ValueNotifier<TFilter> filter;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final currentFilter = useListenable(filter);
    final fields = [...codec.modalFields]
      ..sort((l, r) => l.directive.order.compareTo(r.directive.order));
    final maxContentHeight = MediaQuery.sizeOf(context).height * 0.50;

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
                for (var i = 0; i < fields.length; i++) ...[
                  SearchFilterFieldShell(
                    label: fields[i].label,
                    child: fields[i].buildEditor(
                      context,
                      currentFilter.value,
                      (next) => filter.value = next,
                    ),
                  ),
                  if (i != fields.length - 1)
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
