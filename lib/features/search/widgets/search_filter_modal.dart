import 'package:boo_mondai/lib.barrel.dart'
    show
        ModalTone,
        AppTokens,
        Button, buttonStyle,
        ButtonColor,
        SearchFilter,
        SearchFilterCodec,
        showModal;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Navigator,
        Theme,
        Widget,
        Text,
        SizedBox,
        ConstrainedBox,
        BoxConstraints,
        Column,
        CrossAxisAlignment,
        MainAxisSize,
        MediaQuery,
        SingleChildScrollView,
        StatelessWidget,
        MainAxisAlignment,
        Row;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

Future<TFilter?> showSearchFilterModal<TFilter extends SearchFilter>({
  required BuildContext context,
  required SearchFilterCodec<TFilter> codec,
  required TFilter currentFilter,
  ModalTone tone = ModalTone.surface,
}) {
  return showModal<TFilter>(
    context: context,
    barrierDismissible: true,
    title: 'Search Filters',
    tone: tone,
    child: _SearchFilterBody<TFilter>(
      codec: codec,
      currentFilter: currentFilter,
    ),
  );
}

class _SearchFilterBody<TFilter extends SearchFilter> extends HookWidget {
  const _SearchFilterBody({required this.codec, required this.currentFilter});

  final SearchFilterCodec<TFilter> codec;
  final TFilter currentFilter;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final filter = useState<TFilter>(currentFilter);
    final fields = [...codec.modalFields]
      ..sort((l, r) => l.directive.order.compareTo(r.directive.order));
    final maxContentHeight = MediaQuery.sizeOf(context).height * 0.68;

    // Rebuild with actions wired to current filter state
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
                  _SearchFilterFieldShell(
                    label: fields[i].label,
                    child: fields[i].buildEditor(
                      context,
                      filter.value,
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
        SizedBox(height: tokens.spaceLayoutGapLg),
        // Actions inline since they need access to filter state
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Button(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            SizedBox(width: tokens.spaceLayoutGapSm),
            Button(
              onPressed: () => filter.value = currentFilter,
              child: const Text('Reset'),
            ),
            SizedBox(width: tokens.spaceLayoutGapSm),
            Button(
              style: buttonStyle.resolve(tokens, const [ButtonColor.primary]),
              onPressed: () => Navigator.pop(context, filter.value),
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchFilterFieldShell extends StatelessWidget {
  const _SearchFilterFieldShell({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        child,
      ],
    );
  }
}
