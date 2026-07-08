// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/empty_state.dart
// PURPOSE: Reusable empty state with icon, title, message and optional action
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, textStyle, TextSize, TextWeight, ProgressBar;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StatusLayoutState extends StatelessWidget {
  const StatusLayoutState({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    this.actions = const [],
    this.leading,
    this.child,
    this.progressValue,
    this.extraAction,
  });

  final IconData? icon;
  final Widget? leading;
  final String title;
  final String message;
  final List<Widget> actions;
  final Widget? extraAction;
  final Widget? child;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon, size: 56.r, color: tokens.colorTextMuted),
        ?leading,
        Text(
          title,
          style: textStyle.resolve(tokens, const [
            TextSize.header2,
            TextWeight.strong,
          ]),
          textAlign: TextAlign.center,
        ),
        Text(
          message,
          style: textStyle.resolve(tokens, const [
            TextSize.label,
            TextWeight.body,
          ]),
          textAlign: TextAlign.center,
        ),
        if (progressValue != null) ProgressBar(value: progressValue!),
        ?child,
        if (actions.isNotEmpty && extraAction == null)
          Row(spacing: tokens.spaceLayoutGapSm, children: [...actions]),
        if (actions.isNotEmpty && extraAction != null)
          Column(
            spacing: tokens.spaceLayoutGapSm,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(spacing: tokens.spaceLayoutGapSm, children: actions),
              ?extraAction,
            ],
          ),
      ],
    );
  }
}
