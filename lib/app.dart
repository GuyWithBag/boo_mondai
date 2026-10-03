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
import 'package:boo_mondai/lib.barrel.dart' hide TextField;

class BooMondaiApp extends HookWidget {
  final AuthController authController;

  const BooMondaiApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(() => createRouter(authController), [
      authController,
    ]);
    useEffect(() {
      NotificationsService.setRouteHandler(router.push);
      return NotificationsService.clearRouteHandler;
    }, [router]);
    final settings = SettingsStore.instance;
    final controller = useMemoized(
      () => UserSettingsThemeBridge.createController(settings),
      [settings],
    );
    useListenable(controller);
    return ThemeVariantsProvider<AppTokens>(
      controller: controller,
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
    );
  }
}
