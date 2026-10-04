import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        NotificationBubbleColor,
        NotificationBubbleController,
        NotificationBubbleVariant,
        TextColor,
        TextSize,
        TextWeight,
        notificationBubbleStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class NotificationBubble extends SignalHookWidget {
  const NotificationBubble({
    super.key,
    this.color = NotificationBubbleColor.surface,
    this.variant = NotificationBubbleVariant.elevated,
    this.variants = const [],
    this.minWidth = 320,
    this.maxWidth = 420,
  });

  final NotificationBubbleColor color;
  final NotificationBubbleVariant variant;
  final List<Object> variants;
  final double minWidth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = NotificationBubbleController.instance;
    final notification = controller.activeNotification.value;
    final resolvedStyle = notificationBubbleStyle.resolve(tokens, [
      color,
      variant,
      ...variants,
    ]);

    if (notification == null) return const SizedBox.shrink();

    final route = controller.routeFor(notification);
    final canOpen = route != null && route.isNotEmpty;
    final bubble = Padding(
      padding: EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      child: Align(
        alignment: Alignment.topRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: canOpen
                  ? () async {
                      await controller.dismiss();
                      if (!context.mounted) return;
                      context.push(route);
                    }
                  : null,
              child: Surface(
                style: resolvedStyle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: textStyle.resolve(tokens, const [
                              TextSize.label,
                              TextWeight.heavy,
                            ]),
                          ),
                          SizedBox(height: tokens.spaceLayoutGapXsm),
                          Text(
                            notification.body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle.resolve(tokens, const [
                              TextSize.body,
                              TextWeight.body,
                              TextColor.muted,
                            ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: tokens.spaceLayoutGapSm),
                    Button.iconOnlySmall(
                      icon: Icons.close,
                      onPressed: controller.dismiss,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: resolvedStyle.transform != null
          ? EdgeInsets.only(top: tokens.modalShadowOffset)
          : EdgeInsets.zero,
      child:
          Dismissible(
                key: ValueKey(notification.id),
                direction: DismissDirection.horizontal,
                onDismissed: (_) => controller.dismiss(),
                child: bubble,
              )
              .animate(key: ValueKey('notification-bubble-${notification.id}'))
              .fadeIn(duration: 220.ms, curve: Curves.easeOutCubic)
              .slideX(
                begin: 1,
                end: 0,
                duration: 260.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
