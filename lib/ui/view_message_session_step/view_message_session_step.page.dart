import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppMediaPack,
        Scaffold,
        AppBar,
        ProgressBar,
        Button,
        BottomNavBar,
        MessageSessionStep,
        AppTokens,
        SettingsController,
        SettingsService,
        StudySessionStepHelper,
        StudySessionController,
        ViewStudySessionController,
        UiSoundsService;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:media_variants/media_variants.dart';
import 'package:provider/provider.dart';
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
  final MessageSessionStep step;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final messageStepSound = StudySessionStepHelper.getMessageStepSound(step);

    useEffect(() {
      if (messageStepSound == null) return null;

      unawaited(
        UiSoundsService.playIfEnabled(
          context.mediaPackController<AppMediaPack>().resolve(messageStepSound),
          settingsController: context.read<SettingsController>(),
          enabledSetting: SettingsService.uiSoundsEnabled,
        ),
      );
      return null;
    }, [step.id]);

    return Scaffold(
      scrollable: false,
      appBar: AppBar(
        onPop: studySessionPageController.onSessionPop,
        child: ProgressBar(value: controller.getProgressPercentage()),
      ),
      bottomNavBar: BottomNavBar(
        child: Button(
          onPressed: controller.advancePresentationStep,
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
