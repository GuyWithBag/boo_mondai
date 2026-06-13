import 'package:boo_mondai/lib.barrel.dart'
    show
        AppModalTone,
        AppTokens,
        Button,
        ButtonTone,
        Modal,
        SearchFilter,
        SearchFilterCodec;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

Future<TFilter?> showSearchFilterModal<TFilter extends SearchFilter>({
  required BuildContext context,
  required SearchFilterCodec<TFilter> codec,
  required TFilter currentFilter,
  AppModalTone tone = AppModalTone.surface,
}) {
  return showDialog<TFilter>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _SearchFilterModal<TFilter>(
      codec: codec,
      currentFilter: currentFilter,
      tone: tone,
    ),
  );
}

class _SearchFilterModal<TFilter extends SearchFilter> extends HookWidget {
  const _SearchFilterModal({
    required this.codec,
    required this.currentFilter,
    required this.tone,
  });

  final SearchFilterCodec<TFilter> codec;
  final TFilter currentFilter;
  final AppModalTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final filter = useState<TFilter>(currentFilter);
    final fields = [...codec.modalFields]
      ..sort(
        (left, right) => left.directive.order.compareTo(right.directive.order),
      );

    void reset() {
      filter.value = currentFilter;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spacePanelGapLg),
      child: Modal(
        tone: tone,
        leading: const Icon(Icons.tune),
        actions: [
          Button(
            tone: ButtonTone.ghost,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Button(
            tone: ButtonTone.ghost,
            onPressed: reset,
            child: const Text('Reset'),
          ),
          Button(
            tone: ButtonTone.filled,
            onPressed: () => Navigator.pop(context, filter.value),
            child: const Text('Apply'),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Search Filters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: tokens.spacePanelGapLg),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0; index < fields.length; index++) ...[
                      _SearchFilterFieldShell(
                        label: fields[index].label,
                        child: fields[index].buildEditor(
                          context,
                          filter.value,
                          (nextFilter) => filter.value = nextFilter,
                        ),
                      ),
                      if (index != fields.length - 1)
                        SizedBox(height: tokens.spacePanelGapLg),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        SizedBox(height: tokens.spacePanelGapSm),
        child,
      ],
    );
  }
}
