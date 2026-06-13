// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/change_review/change_review_controller.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeLog,
        ChangeReviewPlan,
        ChangeReviewStatus,
        ChangeSource,
        Controller;

typedef ChangeReviewApply = Future<List<ChangeLog>> Function();

class ChangeReviewController extends Controller {
  final List<ChangeReviewPlan> _plans = [];
  final Map<String, ChangeReviewApply> _applyByPlanId = {};

  List<ChangeReviewPlan> get plans => List.unmodifiable(_plans);

  List<ChangeReviewPlan> get activePlans =>
      _plans.where((plan) => plan.isActive).toList(growable: false);

  ChangeReviewPlan? planById(String id) {
    for (final plan in _plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }

  ChangeReviewPlan start({
    required ChangeSource source,
    required String title,
    ChangeReviewStatus status = ChangeReviewStatus.previewing,
    double? progress,
    List<ChangeLog> changes = const [],
    ChangeReviewApply? onApply,
  }) {
    final plan = ChangeReviewPlan(
      source: source,
      title: title,
      status: status,
      progress: progress,
      changes: changes,
    );
    _plans.insert(0, plan);
    if (onApply != null) {
      _applyByPlanId[plan.id] = onApply;
    }
    notifyListeners();
    return plan;
  }

  void update(
    String planId, {
    ChangeReviewStatus? status,
    double? progress,
    List<ChangeLog>? changes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    final current = planById(planId);
    if (current?.status == ChangeReviewStatus.canceled) return;
    _replace(
      planId,
      (plan) => plan.copyWith(
        status: status,
        progress: progress,
        changes: changes,
        errorMessage: errorMessage,
        clearErrorMessage: clearErrorMessage,
      ),
    );
  }

  void complete(String planId, {List<ChangeLog>? changes}) {
    final current = planById(planId);
    if (current?.status == ChangeReviewStatus.canceled) return;
    _replace(
      planId,
      (plan) => plan.copyWith(
        status: ChangeReviewStatus.completed,
        progress: 1,
        changes: changes,
        clearErrorMessage: true,
        finishedAt: DateTime.now(),
      ),
    );
  }

  Future<void> apply(String planId) async {
    final applyFn = _applyByPlanId[planId];
    if (applyFn == null) {
      complete(planId);
      return;
    }

    update(planId, status: ChangeReviewStatus.applying, progress: 0);
    try {
      final changes = await applyFn();
      complete(planId, changes: changes);
    } catch (e) {
      fail(planId, e);
    } finally {
      _applyByPlanId.remove(planId);
    }
  }

  /// Marks the plan as paused. The actual pause signal is sent to
  /// DeckDownloadsService separately via its pauseDownload() method.
  void pause(String planId) {
    final current = planById(planId);
    if (current == null) return;
    if (current.status == ChangeReviewStatus.canceled ||
        current.status == ChangeReviewStatus.completed ||
        current.status == ChangeReviewStatus.failed)
      return;
    _replace(
      planId,
      (plan) => plan.copyWith(status: ChangeReviewStatus.paused),
    );
  }

  /// Marks the plan as applying again so the UI reflects resuming.
  /// The caller is responsible for actually re-running the download.
  void resume(String planId) {
    final current = planById(planId);
    if (current?.status != ChangeReviewStatus.paused) return;
    _replace(
      planId,
      (plan) => plan.copyWith(status: ChangeReviewStatus.applying),
    );
  }

  void fail(String planId, Object error) {
    final current = planById(planId);
    if (current?.status == ChangeReviewStatus.canceled) return;
    setError(error is Exception ? error : Exception(error.toString()));
    _replace(
      planId,
      (plan) => plan.copyWith(
        status: ChangeReviewStatus.failed,
        errorMessage: error.toString(),
        finishedAt: DateTime.now(),
      ),
    );
  }

  void cancel(String planId) {
    _applyByPlanId.remove(planId);
    _replace(
      planId,
      (plan) => plan.copyWith(
        status: ChangeReviewStatus.canceled,
        finishedAt: DateTime.now(),
      ),
    );
  }

  void remove(String planId) {
    final index = _plans.indexWhere((plan) => plan.id == planId);
    if (index == -1) return;
    _applyByPlanId.remove(planId);
    _plans.removeAt(index);
    notifyListeners();
  }

  void clearFinished() {
    for (final plan in _plans.where((plan) => !plan.isActive)) {
      _applyByPlanId.remove(plan.id);
    }
    _plans.removeWhere((plan) => !plan.isActive);
    notifyListeners();
  }

  void _replace(
    String planId,
    ChangeReviewPlan Function(ChangeReviewPlan) edit,
  ) {
    final index = _plans.indexWhere((plan) => plan.id == planId);
    if (index == -1) return;
    _plans[index] = edit(_plans[index]);
    notifyListeners();
  }
}
