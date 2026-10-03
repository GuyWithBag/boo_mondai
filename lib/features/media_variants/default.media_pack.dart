import 'package:boo_mondai/features/media_variants/app_media_pack.model.dart';
import 'package:boo_mondai/features/media_variants/media_asset.model.dart';
import 'package:boo_mondai/features/media_variants/media_pack.model.dart';
import 'package:boo_mondai/features/settings/models/setting.path.dart';
import 'package:boo_mondai/features/settings/settings.store.dart';

bool uiSoundsEnabled() =>
    SettingsStore.instance.get<bool>(SettingPath.uiSoundsEnabled);

bool buttonDownSoundEnabled() =>
    uiSoundsEnabled() &&
    SettingsStore.instance.get<bool>(SettingPath.buttonDownSoundEnabled);

bool buttonUpSoundEnabled() =>
    uiSoundsEnabled() &&
    SettingsStore.instance.get<bool>(SettingPath.buttonUpSoundEnabled);

bool studySessionSoundsEnabled() =>
    uiSoundsEnabled() &&
    SettingsStore.instance.get<bool>(SettingPath.studySessionSoundsEnabled);

const defaultMediaPack = MediaPack<AppMediaPack>(
  id: 'default',
  name: 'Default',
  media: (
    buttonDownSound: MediaAsset.audio(
      'assets/ui/button_down/minimalist_3.wav',
      enabled: buttonDownSoundEnabled,
    ),
    buttonUpSound: MediaAsset.audio(
      'assets/ui/button_up/minimalist_1.wav',
      enabled: buttonUpSoundEnabled,
    ),
    studySessionRevealSound: MediaAsset.none(),
    studySessionCorrectSound: MediaAsset.none(),
    studySessionIncorrectSound: MediaAsset.none(),
    studySessionAgainSound: MediaAsset.none(),
    studySessionHardSound: MediaAsset.none(),
    studySessionGoodSound: MediaAsset.none(),
    studySessionEasySound: MediaAsset.none(),
    studySessionContinueSound: MediaAsset.none(),
    studySessionCompleteSound: MediaAsset.none(),
    studySessionSlowDownSound: MediaAsset.none(),
    studySessionProgressMilestoneSound: MediaAsset.none(),
  ),
);
