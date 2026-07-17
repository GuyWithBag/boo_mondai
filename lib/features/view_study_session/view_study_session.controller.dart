import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        SessionMode,
        StreakController,
        StudySessionController,
        ViewStudyCardsController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart' show ReadContext;

final class ViewStudySessionController extends Controller {
  ViewStudySessionController({
    required BuildContext context,
    required SessionMode mode,
    required StudySessionController sessionController,
    required ViewStudyCardsController? dashboardController,
  }) : _context = context,
       _mode = mode,
       _sessionController = sessionController,
       _dashboardController = dashboardController;

  final BuildContext _context;
  final SessionMode _mode;
  final StudySessionController _sessionController;
  final ViewStudyCardsController? _dashboardController;

  bool _didHandleCompletion = false;

  void onCompletion() {
    if (!_sessionController.isComplete) {
      _didHandleCompletion = false;
      return;
    }

    if (_didHandleCompletion) return;
    _didHandleCompletion = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_context.mounted) return;

      if (_mode == SessionMode.review) {
        _context.read<StreakController>().recordActivity(DateTime.now());
        return;
      }

      if (_mode == SessionMode.drill) {
        final sessionId = _sessionController.session?.id;
        if (sessionId == null) return;
        _context.go('/drill/$sessionId/result');
      }
    });
  }

  void onSessionPop() {
    if (_mode == SessionMode.review) {
      _dashboardController?.load();
    }
    _context.pop();
  }

  void onReviewCompletePressed() {
    _sessionController.reset();
    _dashboardController?.load();
    _context.pop();
  }
}

ViewStudySessionController useStudySessionPageController({
  required BuildContext context,
  required SessionMode mode,
  required StudySessionController sessionController,
  required ViewStudyCardsController? dashboardController,
}) {
  final pageController = useMemoized(
    () => ViewStudySessionController(
      context: context,
      mode: mode,
      sessionController: sessionController,
      dashboardController: dashboardController,
    ),
    [mode, sessionController, dashboardController],
  );

  useEffect(() => pageController.dispose, [pageController]);

  return pageController;
}
