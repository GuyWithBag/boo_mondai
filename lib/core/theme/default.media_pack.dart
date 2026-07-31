import 'package:boo_mondai/core/theme/app_media_pack.model.dart';
import 'package:media_variants/media_variants.dart';

const defaultMediaPack = MediaPack<AppMediaPack>(
  id: 'default',
  name: 'Default',
  media: (
    buttonDownSound: MediaAsset.audio('assets/ui/button_down/minimalist_3.wav'),
    buttonUpSound: MediaAsset.audio('assets/ui/button_up/minimalist_1.wav'),
  ),
);
