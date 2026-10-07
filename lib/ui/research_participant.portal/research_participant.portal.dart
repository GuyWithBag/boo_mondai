import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart'
    show SnackbarColor, showSnackbar;
import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ButtonColor,
        LoadingIndicator,
        LocalDB,
        Pages,
        ProfileRole,
        ProfileService,
        ResearchParticipantChineseSetAData,
        ResearchParticipantChineseSetBData,
        ResearchParticipantData,
        ResearchParticipantJapaneseSetAData,
        ResearchParticipantJapaneseSetBData;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';

class ResearchParticipantPortal extends SignalHookWidget {
  const ResearchParticipantPortal({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ProfileService.currentProfile.value;
    final isInitializing = useState(false);
    final isInitialized = useState(false);
    final data = dataForRole(profile.role);

    useEffect(() {
      isInitialized.value = data == null || isDataInitialized(data);
      return null;
    }, [profile.role, data]);

    if (!profile.isParticipant) {
      return const SizedBox.shrink();
    }

    return Button(
      variants: [ButtonColor.primary],
      onPressed: isInitializing.value || isInitialized.value
          ? null
          : () => initializeParticipantData(
              context,
              isInitializing: isInitializing,
              isInitialized: isInitialized,
              data: data,
            ),
      leading: isInitializing.value
          ? const LoadingIndicator()
          : const Icon(Icons.assignment_turned_in_outlined),
      mainAxisAlignment: MainAxisAlignment.start,
      child: Text(
        isInitializing.value
            ? 'Initializing participant data...'
            : isInitialized.value
            ? 'Participant Data Initialized'
            : 'Initialize Participant Data',
      ),
    );
  }

  Future<void> initializeParticipantData(
    BuildContext context, {
    required ValueNotifier<bool> isInitializing,
    required ValueNotifier<bool> isInitialized,
    required ResearchParticipantData? data,
  }) async {
    if (data == null) return;

    isInitializing.value = true;
    try {
      final profile = ProfileService.currentProfile.value;
      await data.initialize(profile);
      isInitialized.value = true;
      if (!context.mounted) return;

      showSnackbar(
        context,
        message: 'Participant data initialized',
        color: SnackbarColor.success,
      );
      context.go(Pages.decksLocal.url);
    } catch (error) {
      if (!context.mounted) return;

      showSnackbar(context, message: error.toString());
    } finally {
      isInitializing.value = false;
    }
  }

  ResearchParticipantData? dataForRole(ProfileRole role) {
    return switch (role) {
      ProfileRole.participantChineseA => ResearchParticipantChineseSetAData(),
      ProfileRole.participantChineseB => ResearchParticipantChineseSetBData(),
      ProfileRole.participantJapaneseA => ResearchParticipantJapaneseSetAData(),
      ProfileRole.participantJapaneseB => ResearchParticipantJapaneseSetBData(),
      _ => null,
    };
  }

  bool isDataInitialized(ResearchParticipantData data) {
    return LocalDB.deck.selectByPk({'id': data.participantDeckId}) != null;
  }
}
