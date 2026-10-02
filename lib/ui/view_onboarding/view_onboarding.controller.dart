import 'package:boo_mondai/lib.barrel.dart'
    show NotificationsService, Pages, SettingPath, SettingsStore;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

class ViewOnboardingController {
  ViewOnboardingController();

  static const int lastPageIndex = 2;

  final pageController = PageController();
  final currentPage = signal(0);
  final isRequestingNotifications = signal(false);

  void setCurrentPage(int index) {
    currentPage.value = index;
  }

  Future<void> goNext(BuildContext context) async {
    if (currentPage.value == lastPageIndex) {
      await SettingsStore.instance.set<bool>(
        SettingPath.onboardingCompleted,
        true,
      );
      if (context.mounted) context.go(Pages.home.url);
      return;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> goBack() async {
    if (currentPage.value == 0) return;
    await pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> requestNotifications(BuildContext context) async {
    if (isRequestingNotifications.value) return;

    isRequestingNotifications.value = true;
    try {
      await NotificationsService.requestPermission();
      if (context.mounted) await goNext(context);
    } finally {
      isRequestingNotifications.value = false;
    }
  }

  void dispose() {
    pageController.dispose();
    isRequestingNotifications.dispose();
    currentPage.dispose();
  }
}
