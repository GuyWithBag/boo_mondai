import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppMediaPack,
        Scaffold,
        AppBar,
        ProgressBar,
        Button,
        BottomNavBar,
        StudySessionMessageStep,
        AppTokens,
        SettingPath,
        SettingsStore,
        StudySessionStepHelper,
        StudySessionController,
        ViewStudySessionController,
        UiSoundsService;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:media_variants/media_variants.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewMessageSessionStepPage extends HookWidget {
  const ViewMessageSessionStepPage({
    super.key,
    required this.controller,
    required this.studySessionPageController,
    required this.step,
  });

  final StudySessionController controller;
  final ViewStudySessionController studySessionPageController;
  final StudySessionMessageStep step;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final mediaPackController = context.mediaPackController<AppMediaPack>();
    final settingsStore = SettingsStore.instance;
    final messageStepSound = StudySessionStepHelper.getMessageStepSound(step);

    useEffect(() {
      if (messageStepSound == null) return null;

      unawaited(
        UiSoundsService.playIfEnabled(
          mediaPackController.resolve(messageStepSound),
          settingsStore: settingsStore,
          enabledSetting: SettingPath.uiSoundsEnabled,
        ),
      );
      return null;
    }, [step.id, messageStepSound, mediaPackController, settingsStore]);

    return Scaffold(
      scrollable: false,
      appBar: AppBar(
        onPop: () => studySessionPageController.onSessionPop(context),
        child: ProgressBar(value: controller.stepProgressPercentage.value),
      ),
      bottomNavBar: BottomNavBar(
        child: Button(
          onPressed: () => unawaited(
            controller.advancePresentationStep().catchError(
              (Object _, StackTrace _) {},
            ),
          ),
          child: const Text('Continue'),
        ),
      ),
      inheritMainBottomNavBarHeight: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              step.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tokens.spaceLayoutGapMd),
            Text(step.message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
