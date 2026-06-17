// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/app.dart
// PURPOSE: MaterialApp with router, theme, and ScreenUtil setup
// PROVIDERS: AuthController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';
import 'package:boo_mondai/lib.barrel.dart';

bool _scaleScreenUtilForSmallAndMediumWidth() {
  if (PlatformService.isDesktop) {
    return false;
  }
  return Breakpoints.isMobile(
    Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight),
  );
}

class BooMondaiApp extends HookWidget {
  final AuthController authController;
  final SettingsController settingsController;

  const BooMondaiApp({
    super.key,
    required this.authController,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(() => createRouter(authController), [
      authController,
    ]);
    final controller = useMemoized(
      () => UserSettingsThemeBridge.createController(settingsController),
      [settingsController],
    );
    useListenable(controller);

    return ThemeVariantsProvider<AppTokens>(
      controller: controller,
      child: ScreenUtilInit(
        designSize: Breakpoints.baseMobileSize,
        minTextAdapt: true,
        splitScreenMode: true,
        enableScaleWH: _scaleScreenUtilForSmallAndMediumWidth,
        enableScaleText: _scaleScreenUtilForSmallAndMediumWidth,
        builder: (context, child) => MaterialApp.router(
          title: 'BooMondai',
          debugShowCheckedModeBanner: false,
          theme: controller.getCurrentLightTheme().themeData,
          darkTheme: controller.getCurrentDarkTheme().themeData,
          themeMode: controller.themeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}
