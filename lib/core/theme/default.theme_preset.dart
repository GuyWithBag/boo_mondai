import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, booMondaiLight, booMondaiDark;
import 'package:theme_variants/theme_variants.dart';

final booMondaiPreset = LightDarkThemePreset<AppTokens>(
  id: 'boomondai',
  name: 'BooMondai',
  light: booMondaiLight,
  dark: booMondaiDark,
);
