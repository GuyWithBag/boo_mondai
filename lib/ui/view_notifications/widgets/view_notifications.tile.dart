import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        MarkdownText,
        MarkdownTextMode,
        NotificationIntent,
        NotificationsController,
        Pages,
        SurfaceBorder,
        SurfaceColor,
        SurfaceShape,
        SurfaceShadow,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle,
        SurfacePadding;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewNotificationsTile extends StatelessWidget {
  const ViewNotificationsTile({required this.notification, super.key});

  final NotificationIntent notification;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final route =
        notification.route ??
        (notification.ifRouteNullPushToView
            ? Pages.notificationIntentUrl(notification.id)
            : null);
    final canOpen = route != null && route.isNotEmpty;
    final isRead = notification.readAt != null;
    final style = surfaceStyle.resolve(tokens, [
      isRead ? SurfaceColor.baseline : SurfaceColor.muted,
      SurfaceBorder.baseline,
      SurfaceShape.roundedXsm,
      SurfaceShadow.none,
      SurfacePadding.sm,
    ]);

    return Dismissible(
      key: ValueKey(notification.id),
      onDismissed: (_) {
        NotificationsController.instance.deleteNotification(notification.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: tokens.spaceLayoutGapMd),
      ),
      child: InkWell(
        onTap: canOpen
            ? () async {
                await NotificationsController.instance.markRead(
                  notification.id,
                );
                if (!context.mounted) return;
                context.push(route);
              }
            : null,
        child: Surface(
          style: style,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: tokens.spaceLayoutGapXsm,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MarkdownText(
                      data: notification.title,
                      mode: MarkdownTextMode.preview,
                      defaultMarkdownAlignment: WrapAlignment.start,
                      baseTextStyle: textStyle.resolve(tokens, const [
                        TextSize.label,
                        TextWeight.heavy,
                      ]),
                    ),
                  ),
                  Button.iconOnlySmall(
                    icon: Icons.check,
                    onPressed: () => NotificationsController.instance.markRead(
                      notification.id,
                    ),
                  ),
                  Button.iconOnlySmall(
                    icon: Icons.close,
                    onPressed: () => NotificationsController.instance
                        .deleteNotification(notification.id),
                  ),
                ],
              ),
              MarkdownText(
                data: notification.body,
                mode: MarkdownTextMode.preview,
                defaultMarkdownAlignment: WrapAlignment.start,
                baseTextStyle: textStyle.resolve(tokens, const [
                  TextSize.body,
                  TextWeight.body,
                  TextColor.muted,
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
