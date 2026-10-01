import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        MarkdownText,
        MarkdownTextMode,
        NotificationIntentType,
        SegmentOption,
        SegmentedControl,
        TextField,
        TextFieldFrame,
        TextFieldSize,
        ViewNotificationsDebugController,
        showModal;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewNotificationsDebug extends StatelessWidget {
  const ViewNotificationsDebug({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Button(
      onPressed: () => showViewNotificationsDebugModal(context),
      leading: const Icon(Icons.bug_report_outlined),
      elevated: false,
      child: const Text('Debug notifications'),
    );
  }
}

Future<void> showViewNotificationsDebugModal(BuildContext context) {
  return showModal<void>(
    context: context,
    leading: const Icon(Icons.bug_report_outlined),
    title: 'Debug notifications',
    child: const ViewNotificationsDebugModal(),
    showCancelButton: true,
  );
}

class ViewNotificationsDebugModal extends SignalHookWidget {
  const ViewNotificationsDebugModal({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useMemoized(ViewNotificationsDebugController.new);
    useEffect(() => controller.dispose, [controller]);

    final type = controller.type.value;
    final persistInInbox = controller.persistInInbox.value;
    final showSystemNotification = controller.showSystemNotification.value;
    final assignIntentRoute = controller.assignIntentRoute.value;
    final routeFieldEnabled = controller.routeFieldEnabled.value;
    final canSubmit = controller.canSubmit.value;
    final submitLabel = controller.submitLabel.value;
    final mediaQuery = MediaQuery.of(context);
    final maxBodyHeight =
        (mediaQuery.size.height -
            mediaQuery.viewInsets.bottom -
            tokens.spaceScaffoldPadding * 2) *
        0.58;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 440, maxHeight: maxBodyHeight),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: tokens.spaceLayoutGapXsm),
            SegmentedControl<NotificationIntentType>(
              value: type,
              onChanged: controller.setType,
              isScrollable: true,
              options: const [
                SegmentOption(
                  value: NotificationIntentType.firstDrillSurvey,
                  label: 'Survey',
                ),
                SegmentOption(
                  value: NotificationIntentType.downloadComplete,
                  label: 'Download',
                ),
                SegmentOption(
                  value: NotificationIntentType.syncComplete,
                  label: 'Sync',
                ),
                SegmentOption(
                  value: NotificationIntentType.studyDeckReview,
                  label: 'Review',
                ),
              ],
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            MarkdownText(
              data: controller.title.value,
              controller: controller.titleController,
              mode: MarkdownTextMode.input,
              variants: const [TextFieldSize.normal, TextFieldFrame.outline],
              placeholder: 'Title',
              maxLines: 1,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            MarkdownText(
              data: controller.body.value,
              controller: controller.bodyController,
              mode: MarkdownTextMode.input,
              variants: const [TextFieldSize.normal, TextFieldFrame.outline],
              placeholder: 'Body',
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            TextField(
              controller: controller.routeController,
              variants: const [TextFieldSize.normal, TextFieldFrame.outline],
              placeholder: 'Route, optional',
              enabled: routeFieldEnabled,
              maxLines: 1,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            TextField(
              controller: controller.purgeAfterDaysController,
              variants: const [TextFieldSize.normal, TextFieldFrame.outline],
              placeholder: 'Purge after days',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLines: 1,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Persist in inbox'),
              value: persistInInbox,
              onChanged: controller.setPersistInInbox,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show system notification'),
              value: showSystemNotification,
              onChanged: controller.setShowSystemNotification,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Route to intent view'),
              value: assignIntentRoute,
              onChanged: controller.setAssignIntentRoute,
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            Button(
              onPressed: canSubmit
                  ? () => controller.insertNotification(context)
                  : null,
              leading: const Icon(Icons.add_alert_outlined),
              variants: const [ButtonColor.primary],
              child: Text(submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
