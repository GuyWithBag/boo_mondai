import 'package:boo_mondai/features/ui_sounds/ui_sounds.service.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextWeight,
        surfaceStyle,
        textStyle,
        TextSize;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show HookWidget, useEffect, useRef, useState;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class DarkModeToggleCard extends HookWidget {
  const DarkModeToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.themeVariantsController<AppTokens>();
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final isDark = switch (controller.themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    final previousIsDark = useRef(isDark);
    final orbitTurns = useState(0.0);
    useEffect(() {
      if (previousIsDark.value != isDark) {
        previousIsDark.value = isDark;
        orbitTurns.value += 1;
      }
      return null;
    }, [isDark]);

    final tokens = context.themeTokens<AppTokens>();

    final contrastTextPaint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.difference;
    final contrastTextStyle = textStyle
        .resolve(tokens, const [TextWeight.heavy, TextSize.header2])
        .copyWith(foreground: contrastTextPaint);
    final baseStyle = surfaceStyle.resolve(tokens, const [
      SurfaceColor.baseline,
      SurfaceBorder.none,
      SurfacePadding.none,
      SurfaceShape.rounded,
      SurfaceShadow.baseline,
    ]);
    final height = 120.h;
    final style = baseStyle.copyWith(
      decoration: baseStyle.decoration.copyWith(
        color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFF7EC8F5),
      ),
      height: height,
      clipBehavior: Clip.antiAlias,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final orbitRadius = width * 0.95;
        final orbitDiameter = orbitRadius * 2;
        final anchorX = -width * 0.3;
        final anchorY = height * 2.3;
        final moonDiameter = 300.r;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
            controller.setThemeMode(nextMode);
            await UiSoundsService.soloud.playSource(
              asset: 'assets/ui/button_down/minimalist_3.wav',
              volume: 2,
            );
            await UiSoundsService.soloud.playSource(
              asset: 'assets/ui/button_up/minimalist_1.wav',
              volume: 2,
            );
          },
          child: Surface(
            style: style,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: anchorX - orbitRadius,
                  top: anchorY - orbitRadius,
                  child: AnimatedRotation(
                    turns: orbitTurns.value,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: orbitDiameter,
                      height: orbitDiameter,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: orbitRadius + width * 0.72 - moonDiameter / 2,
                            top: orbitRadius - height * 0.98 - moonDiameter / 2,
                            child: _Moon(
                              isDark: isDark,
                              diameter: moonDiameter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.spaceLayoutGapMd),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        isDark ? 'Toggle Light Mode' : 'Toggle Dark Mode',
                        textAlign: TextAlign.right,
                        style: contrastTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Moon extends StatelessWidget {
  const _Moon({required this.isDark, required this.diameter});

  final bool isDark;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 360),
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFFD7D7D7) : const Color(0xFFFFD75A),
        shape: BoxShape.circle,
      ),
    );
  }
}
