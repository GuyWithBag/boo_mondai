// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/empty_state.dart
// PURPOSE: Reusable empty state with icon, title, message and optional action
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, textStyle, TextSize, TextWeight, ProgressBar, Button;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ScaffoldScrollLockScope extends InheritedWidget {
  const ScaffoldScrollLockScope({
    super.key,
    required this.setScrollLocked,
    required super.child,
  });

  final void Function(Object key, bool value) setScrollLocked;

  static ScaffoldScrollLockScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScaffoldScrollLockScope>();
  }

  @override
  bool updateShouldNotify(ScaffoldScrollLockScope oldWidget) {
    return setScrollLocked != oldWidget.setScrollLocked;
  }
}

class StatusLayoutState extends HookWidget {
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
    this.disableScaffoldScrollingWhenShown = false,
  });

  final IconData? icon;
  final Widget? leading;
  final String title;
  final String message;
  final List<Widget> actions;
  final Widget? extraAction;
  final Widget? child;
  final double? progressValue;
  final bool disableScaffoldScrollingWhenShown;

  factory StatusLayoutState.exception({
    Key? key,
    required Exception? exception,
    VoidCallback? onRetry,
    bool disableScaffoldScrollingWhenShown = false,
  }) {
    return StatusLayoutState(
      key: key,
      icon: Icons.error_outline,
      title: 'Something went wrong',
      message: exception?.toString() ?? 'An unknown error occurred.',
      actions: [
        if (onRetry != null)
          Button(
            onPressed: onRetry,
            leading: const Icon(Icons.refresh),
            child: const Text('Retry'),
          ),
      ],
      disableScaffoldScrollingWhenShown: disableScaffoldScrollingWhenShown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final scrollLockScope = ScaffoldScrollLockScope.maybeOf(context);
    final setScrollLocked = scrollLockScope?.setScrollLocked;
    final scrollLockKey = useMemoized(Object.new);

    useEffect(() {
      if (!disableScaffoldScrollingWhenShown || setScrollLocked == null) {
        return null;
      }

      var active = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!active) return;
        setScrollLocked(scrollLockKey, true);
      });

      return () {
        active = false;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          setScrollLocked(scrollLockKey, false);
        });
      };
    }, [disableScaffoldScrollingWhenShown, setScrollLocked, scrollLockKey]);

    return Column(
      spacing: tokens.spaceLayoutGapSm,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon, size: 56.r, color: tokens.colorTextMuted),
        ?leading,
        SelectableText(
          title,
          style: textStyle.resolve(tokens, const [
            TextSize.header2,
            TextWeight.strong,
          ]),
          textAlign: TextAlign.center,
        ),
        SelectableText(
          message,
          style: textStyle.resolve(tokens, const [
            TextSize.label,
            TextWeight.body,
          ]),
          textAlign: TextAlign.center,
        ),
        if (progressValue != null) ProgressBar(value: progressValue!),
        ?child,
        if (actions.isNotEmpty || extraAction != null)
          SizedBox(height: tokens.spaceLayoutGapSm),
        if (actions.isNotEmpty && extraAction == null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: tokens.spaceLayoutGapSm,
            children: [...actions],
          ),
        if (actions.isNotEmpty || extraAction != null)
          Column(
            spacing: tokens.spaceLayoutGapSm,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (actions.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: tokens.spaceLayoutGapSm,
                  children: actions,
                ),
              ?extraAction,
            ],
          ),
      ],
    );
  }
}
