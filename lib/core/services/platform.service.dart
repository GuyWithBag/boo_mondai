// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/services/platform.service.dart
// PURPOSE: Static helpers for web, mobile, and desktop device checks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io' show Platform;

import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

abstract final class PlatformService {
  static bool get isWeb => kIsWeb;

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static EdgeInsets getScaffoldPadding(AppTokens tokens) {
    if (isMobile) {
      return EdgeInsets.symmetric(
        horizontal: tokens.spaceScaffoldPadding,
        vertical: tokens.spaceScaffoldPaddingMobileY,
      );
    }
    return EdgeInsets.symmetric(
      horizontal: tokens.spaceScaffoldPadding,
      vertical: tokens.spaceScaffoldPadding,
    );
  }
}
