import 'package:boo_mondai/features/features.barrel.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ViewImportController {
  ViewImportController() {
    importTextController.addListener(
      () => importText.value = importTextController.value.text,
    );
    formDeckTitleController.addListener(
      () => formDeckTitle.value = formDeckTitleController.value.text,
    );
  }

  final TextEditingController importTextController = TextEditingController();
  final TextEditingController formDeckTitleController = TextEditingController();
  final importText = signal('');
  final formDeckTitle = signal('');

  final isPickingFile = signal(false);
  // final errorMessage = signal<String?>(null);

  void importFromText() {
    Deck
  }

  Future<void> importFromFile() async {}

  void dispose() {
    importTextController.dispose();
    formDeckTitleController.dispose();
    importText.dispose();
  }
}
