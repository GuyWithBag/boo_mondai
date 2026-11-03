import 'package:boo_mondai/lib.barrel.dart' show AppTokens, booMondaiPreset;
import 'package:theme_variants/theme_variants.dart';

final appThemeRegistry = ThemeVariantRegistry<AppTokens>(
  presets: [booMondaiPreset],
);
