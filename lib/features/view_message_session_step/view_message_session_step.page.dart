import 'package:boo_mondai/features/view_study_session/view_study_session.controller.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Scaffold,
        AppBar,
        ProgressBar,
        Button,
        BottomNavBar,
        MessageSessionStep,
        AppTokens,
        StudySessionController;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:theme_variants/theme_variants.dart';

class ViewMessageSessionStepPage extends StatelessWidget {
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
