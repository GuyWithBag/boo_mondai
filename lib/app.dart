// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/app.dart
// PURPOSE: MaterialApp with router, theme, and ScreenUtil setup
// PROVIDERS: AuthController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_variants/media_variants.dart';
import 'package:theme_variants/theme_variants.dart';
import 'package:boo_mondai/lib.barrel.dart' hide TextField;

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

  const BooMondaiApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(() => createRouter(authController), [
      authController,
    ]);
    final settings = SettingsStore.instance;
    final controller = useMemoized(
      () => UserSettingsThemeBridge.createController(settings),
      [settings],
    );
    final mediaPackController = useMemoized(createAppMediaPackController);
    useListenable(controller);
    return ThemeVariantsProvider<AppTokens>(
      controller: controller,
      child: MediaPackProvider<AppMediaPack>(
        controller: mediaPackController,
        child: ScreenUtilInit(
          designSize: Breakpoints.baseMobileSize,
          minTextAdapt: false,
          splitScreenMode: false,
          // enableScaleWH: _scaleScreenUtilForSmallAndMediumWidth,
          enableScaleWH: () => false,
          // enableScaleText: _scaleScreenUtilForSmallAndMediumWidth,
          enableScaleText: () => false,
          builder: (context, child) => MaterialApp.router(
            title: 'BooMondai',
            debugShowCheckedModeBanner: false,
            theme: controller.getCurrentLightTheme().themeData,
            darkTheme: controller.getCurrentDarkTheme().themeData,
            themeMode: controller.themeMode,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
