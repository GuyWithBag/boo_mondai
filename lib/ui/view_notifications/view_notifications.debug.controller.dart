import 'package:boo_mondai/lib.barrel.dart'
    show
        ImmediateSchedule,
        LocalDB,
        NotificationIds,
        NotificationIntent,
        NotificationIntentType,
        NotificationsController,
        Pages,
        showSnackbar;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ViewNotificationsDebugController {
  ViewNotificationsDebugController() {
    controllerTextEffect = effect(() {
      titleController.addListener(syncTitle);
      bodyController.addListener(syncBody);
      routeController.addListener(syncCustomRoute);
      purgeAfterDaysController.addListener(syncPurgeAfterDaysText);

      syncTitle();
      syncBody();
      syncCustomRoute();
      syncPurgeAfterDaysText();

      return () {
        titleController.removeListener(syncTitle);
        bodyController.removeListener(syncBody);
        routeController.removeListener(syncCustomRoute);
        purgeAfterDaysController.removeListener(syncPurgeAfterDaysText);
      };
    });
  }

  final titleController = TextEditingController(text: 'Debug notification');
  final bodyController = TextEditingController(
    text: 'Inserted from the notification debug modal.',
  );
  final routeController = TextEditingController();
  final purgeAfterDaysController = TextEditingController(text: '30');

  final title = signal('');
  final body = signal('');
  final customRoute = signal('');
  final purgeAfterDaysText = signal('30');
  final type = signal(NotificationIntentType.firstDrillSurvey);
  final persistInInbox = signal(true);
  final showSystemNotification = signal(false);
  final assignIntentRoute = signal(true);
  final isSubmitting = signal(false);

  late final EffectCleanup controllerTextEffect;

  late final purgeAfterDays = computed<int?>(
    () => int.tryParse(purgeAfterDaysText.value.trim()),
  );

  late final hasValidPurgeAfterDays = computed(
    () => (purgeAfterDays.value ?? 0) >= 1,
  );

  late final routeFieldEnabled = computed(() => !assignIntentRoute.value);

  late final canSubmit = computed(
    () =>
        title.value.trim().isNotEmpty &&
        body.value.trim().isNotEmpty &&
        hasValidPurgeAfterDays.value &&
        !isSubmitting.value,
  );

  late final submitLabel = computed(
    () => isSubmitting.value ? 'Inserting...' : 'Insert',
  );

  void syncTitle() {
    title.value = titleController.text;
  }

  void syncBody() {
    body.value = bodyController.text;
  }

  void syncCustomRoute() {
    customRoute.value = routeController.text;
  }

  void syncPurgeAfterDaysText() {
    purgeAfterDaysText.value = purgeAfterDaysController.text;
  }

  void setType(NotificationIntentType value) {
    type.value = value;
  }

  void setPersistInInbox(bool value) {
    persistInInbox.value = value;
  }

  void setShowSystemNotification(bool value) {
    showSystemNotification.value = value;
  }

  void setAssignIntentRoute(bool value) {
    assignIntentRoute.value = value;
  }

  Future<void> insertNotification(BuildContext context) async {
    if (isSubmitting.value) return;

    final resolvedTitle = title.value.trim();
    final resolvedBody = body.value.trim();

    if (resolvedTitle.isEmpty || resolvedBody.isEmpty) {
      showSnackbar(
        context,
        message: 'Title and body are required.',
        leading: const Icon(Icons.error_outline),
      );
      return;
    }

    final resolvedPurgeAfterDays = purgeAfterDays.value ?? 30;
    if (resolvedPurgeAfterDays < 1) {
      showSnackbar(
        context,
        message: 'Purge after days must be at least 1.',
        leading: const Icon(Icons.error_outline),
      );
      return;
    }

    isSubmitting.value = true;

    final id =
        NotificationIds.dynamicIdOffset +
        DateTime.now().microsecondsSinceEpoch % NotificationIds.dynamicIdRange;
    final route = assignIntentRoute.value
        ? Pages.notificationIntentUrl(id)
        : customRoute.value.trim().isEmpty
        ? null
        : customRoute.value.trim();

    await NotificationsController.instance.notify(
      NotificationIntent.create(
        id: id,
        profileId: LocalDB.currentProfile.getOrCreate().id,
        type: type.value,
        title: resolvedTitle,
        body: resolvedBody,
        route: route,
        persistInInbox: persistInInbox.value,
        showSystemNotification: showSystemNotification.value,
        purgeAfterDays: resolvedPurgeAfterDays,
      ),
      const ImmediateSchedule.now(),
    );
    isSubmitting.value = false;

    if (!context.mounted) return;
    showSnackbar(
      context,
      message: 'Debug notification inserted.',
      leading: const Icon(Icons.notifications_active_outlined),
    );
    Navigator.of(context).pop();
  }

  void dispose() {
    controllerTextEffect();
    title.dispose();
    body.dispose();
    customRoute.dispose();
    purgeAfterDaysText.dispose();
    type.dispose();
    persistInInbox.dispose();
    showSystemNotification.dispose();
    assignIntentRoute.dispose();
    isSubmitting.dispose();
    purgeAfterDays.dispose();
    hasValidPurgeAfterDays.dispose();
    routeFieldEnabled.dispose();
    canSubmit.dispose();
    submitLabel.dispose();
    titleController.dispose();
    bodyController.dispose();
    routeController.dispose();
    purgeAfterDaysController.dispose();
  }
}
