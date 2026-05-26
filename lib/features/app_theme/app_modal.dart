import 'package:boo_mondai/lib.barrel.dart'
    show AppModalTone, AppTokens, appModalStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    this.leading,
    required this.child,
    this.actions = const [],
    this.tone = AppModalTone.surface,
    this.maxWidth = 520,
  });

  final Widget? leading;
  final Widget child;
  final List<Widget> actions;
  final AppModalTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Surface(
          style: appModalStyle.resolve(tokens, [tone]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading != null) ...[
                Align(
                  alignment: Alignment.topCenter,
                  child: IconTheme.merge(
                    data: IconThemeData(size: tokens.sizeIconLg),
                    child: leading!,
                  ),
                ),
                SizedBox(height: tokens.spacePanelGapLg),
              ],
              child,
              if (actions.isNotEmpty) ...[
                SizedBox(height: tokens.spacePanelGapLg),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: tokens.spacePanelGapSm,
                  runSpacing: tokens.spacePanelGapSm,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
