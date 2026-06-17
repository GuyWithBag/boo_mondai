import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        surfaceStyle,
        SurfaceColor,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShape,
        SurfaceShadow,
        AppSpacing;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Color,
        EdgeInsets,
        SizedBox,
        MediaQuery,
        ThemeMode,
        Brightness,
        HitTestBehavior,
        Curves,
        BoxShape,
        BoxDecoration,
        AnimatedContainer,
        AnimatedPositioned,
        CrossAxisAlignment,
        Icons,
        Colors,
        Icon,
        Container,
        AnimatedRotation,
        TextAlign,
        Theme,
        FontStyle,
        FontWeight,
        Text,
        Expanded,
        Row,
        Padding,
        Stack,
        GestureDetector;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class DarkModeToggleCard extends StatelessWidget {
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
    final tokens = context.themeTokens<AppTokens>();
    final baseStyle = surfaceStyle.resolve(tokens, const [
      SurfaceColor.baseline,
      SurfaceBorder.normal,
      SurfacePadding.none,
      SurfaceShape.cardShape,
      SurfaceShadow.normal,
    ]);
    final style = baseStyle.copyWith(
      decoration: baseStyle.decoration.copyWith(
        color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFF7EC8F5),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
        controller.setThemeMode(nextMode);
        // TODO:
        // await UserSettingsService.updateThemeMode(
        //   userId: LocalDB.profile.getOrCreate().id,
        //   themeMode: nextMode,
        // );
      },
      child: Surface(
        style: style,
        child: SizedBox(
          height: 140,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeOutCubic,
                left: isDark ? 12 : 120,
                bottom: -92,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 360),
                  width: 300,
                  height: 220,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFD7D7D7)
                        : const Color(0xFFFFD75A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedRotation(
                      turns: isDark ? 0 : 0.5,
                      duration: const Duration(milliseconds: 360),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF232323)
                              : const Color(0xFFFFD75A),
                        ),
                        child: Icon(
                          isDark
                              ? Icons.nightlight_round
                              : Icons.wb_sunny_rounded,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF4A3B00),
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Text(
                        isDark ? 'Toggle Light Mode' : 'Toggle Dark Mode',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF17324B),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
