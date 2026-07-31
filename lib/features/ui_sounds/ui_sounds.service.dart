import 'package:boo_mondai/lib.barrel.dart' show Setting, SettingsController;
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:media_variants/media_variants.dart';

class UiSoundsService {
  UiSoundsService();

  static final SoLoud soloud = SoLoud.instance;

  static Future<void> init() async {
    await soloud.init();
  }

  static Future<void> playIfEnabled(
    MediaAsset asset, {
    required SettingsController settingsController,
    required Setting<bool> enabledSetting,
    double volume = 1,
  }) async {
    if (!settingsController.get(enabledSetting)) return;
    if (asset.type != MediaType.audio || asset.isEmpty) return;

    final source = await switch (asset.source) {
      MediaSource.asset => soloud.loadAsset(asset.requirePath),
      MediaSource.file => soloud.loadFile(asset.requirePath),
      MediaSource.network => soloud.loadUrl(asset.requirePath),
    };

    soloud.play(source, volume: volume);
  }
}
