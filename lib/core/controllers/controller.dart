// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/auth_controller.dart
// PURPOSE: Manages UI state, loading indicators, and migration flows.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

abstract class Controller extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Exception? error;

  // ── Helpers ─────────────────────────────────────────────

  void setError(Exception? value) {
    error = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    if (value) error = null; // Clear previous errors when starting a new action
    notifyListeners();
  }
}
