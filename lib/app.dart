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

class BooMondaiApp extends HookWidget {
  final AuthController authController;
  const BooMondaiApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    // ── Create Router ───────────────────────────────────
    // Hand the controller to GoRouter before starting the app
    final router = createRouter(authController);
    final controller = useMemoized(createAppThemeController);
    return ThemeVariantsProvider<AppTokens>(
      controller: controller,
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
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
