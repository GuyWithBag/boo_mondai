import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';

class ResearchParticipantPortal extends StatelessWidget {
  const ResearchParticipantPortal({super.key});

  @override
  Widget build(BuildContext context) {
    if (ProfileService.currentProfile.value.isParticipant) {
      return Button(child: const Text('Initialize Participant Data'));
    }
    return SizedBox.shrink();
  }
}
