import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        LocalDB,
        MarkdownText,
        MarkdownTextMode,
        Scaffold,
        StatusLayoutState,
        TextColor,
        TextSize,
        TextWeight,
        textStyle;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:theme_variants/theme_variants.dart';

class ViewNotificationIntentPage extends StatelessWidget {
  const ViewNotificationIntentPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final notification = LocalDB.notifications.selectByPk({'id': id});

    return Scaffold(
      appBar: const AppBar(title: 'Notification'),
      body: notification == null
          ? const StatusLayoutState(
              icon: Icons.notifications_off_outlined,
              title: 'Notification not found',
              message: 'This notification is no longer available.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: tokens.spaceLayoutGapMd,
              children: [
                MarkdownText(
                  data: notification.title,
                  mode: MarkdownTextMode.previewSelectable,
                  defaultMarkdownAlignment: WrapAlignment.start,
                  baseTextStyle: textStyle.resolve(tokens, const [
                    TextSize.header,
                    TextWeight.heavy,
                    TextColor.baseline,
                  ]),
                ),
                MarkdownText(
                  data: notification.body,
                  mode: MarkdownTextMode.previewSelectable,
                  defaultMarkdownAlignment: WrapAlignment.start,
                  baseTextStyle: textStyle.resolve(tokens, const [
                    TextSize.body,
                    TextWeight.body,
                    TextColor.baseline,
                  ]),
                ),
              ],
            ),
    );
  }
}
