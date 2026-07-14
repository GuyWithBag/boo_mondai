import 'package:boo_mondai/lib.barrel.dart'
    show ChangeTrackerEntry, ChangeTrackerService;
import 'package:flutter/widgets.dart' show Listenable;

abstract interface class SyncWorkflowController implements Listenable {
  bool get isSyncing;
  String? get syncError;
  ChangeTrackerService? get changeTrackerService;
  ChangeTrackerEntry? get currentEntry;
  bool get isAlreadyUpToDate;
  bool get shouldShowSyncPage;

  void clearSyncError();
  void applyCurrentEntry();
  void dismissCurrentEntry();
  void clearAlreadyUpToDate();
}
