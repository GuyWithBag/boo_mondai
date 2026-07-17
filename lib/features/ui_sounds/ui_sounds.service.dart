import 'package:flutter_soloud/flutter_soloud.dart';

class UiSoundsService {
  UiSoundsService();

  static final SoLoud soloud = SoLoud.instance;

  static Future<void> init() async {
    await soloud.init();
  }
}
