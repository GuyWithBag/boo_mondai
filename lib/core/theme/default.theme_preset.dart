import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, booMondaiLight, booMondaiDark;
import 'package:theme_variants/theme_variants.dart';

LightDarkThemePreset<AppTokens> createBooMondaiPreset() =>
    LightDarkThemePreset<AppTokens>(
      id: 'boomondai',
      name: 'BooMondai',
      light: booMondaiLight,
      dark: booMondaiDark,
    );

LightDarkThemePreset<AppTokens> get booMondaiPreset => createBooMondaiPreset();
