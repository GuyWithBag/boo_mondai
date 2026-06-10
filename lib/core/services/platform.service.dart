// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/services/platform.service.dart
// PURPOSE: Static helpers for web, mobile, and desktop device checks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

abstract final class PlatformService {
  static bool get isWeb => kIsWeb;

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}
