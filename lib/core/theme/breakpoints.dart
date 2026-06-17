// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/theme/breakpoints.dart
// PURPOSE: Responsive breakpoint constants for mobile/tablet/desktop
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

abstract final class Breakpoints {
  static const Size mobile = Size(600, 800);
  static const Size tablet = Size(840, 1024);
  static const Size desktop = Size(1200, 900);
  static const Size tv = Size(1600, 1200);

  static const Size baseMobileSize = Size(377, 831);

  static bool isMobile(Size size) =>
      // size.width < mobile.width && size.height < mobile.height;
      size.width < mobile.width;

  static bool isTablet(Size size) =>
      size.width >= mobile.width &&
      size.height >= mobile.height &&
      (size.width < tablet.width || size.height < tablet.height);

  static bool isDesktop(Size size) =>
      size.width >= tablet.width &&
      size.height >= tablet.height &&
      (size.width < tv.width || size.height < tv.height);

  static bool isTv(Size size) =>
      size.width >= tv.width && size.height >= tv.height;
}
