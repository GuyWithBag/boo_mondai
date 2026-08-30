import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        NotificationIntent,
        SurfaceBorder,
        SurfaceColor,
        SurfaceShape,
        SurfaceShadow,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class NotificationBlock extends StatelessWidget {
  const NotificationBlock({required this.notification, super.key});

  final NotificationIntent notification;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final route = notification.route;
    final canOpen = route != null && route.isNotEmpty;
    final style = surfaceStyle.resolve(tokens, const [
      SurfaceColor.muted,
      SurfaceBorder.baseline,
      SurfaceShape.roundedSm,
      SurfaceShadow.none,
    ]);

    return Surface(
      style: style,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: tokens.spaceLayoutGapSm,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: tokens.spaceLayoutGapXsm,
              children: [
                Text(
                  notification.title,
                  style: textStyle.resolve(tokens, const [
                    TextSize.label,
                    TextWeight.heavy,
                  ]),
                ),
                Text(
                  notification.body,
                  style: textStyle.resolve(tokens, const [
                    TextSize.body,
                    TextWeight.body,
                    TextColor.muted,
                  ]),
                ),
              ],
            ),
          ),
          if (canOpen)
            Button.icon(
              tokens: tokens,
              icon: Icons.arrow_forward,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(route);
              },
            ),
        ],
      ),
    );
  }
}
