// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/browser_deck_detail/author_avatar_row.dart
// PURPOSE: Row displaying author and optional original-author avatars
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show ProfileLabel, AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class DeckProfilesLabel extends StatelessWidget {
  const DeckProfilesLabel({
    super.key,
    required this.profileName,
    this.profileAvatar,
    this.sourceProfileName,
    this.sourceProfileAvatar,
  });

  final String profileName;
  final ImageProvider? profileAvatar;
  final String? sourceProfileName;
  final ImageProvider? sourceProfileAvatar;

  @override
  Widget build(BuildContext context) {
    final hasSourceProfile =
        sourceProfileName != null && sourceProfileName!.trim().isNotEmpty;
    final tokens = context.themeTokens<AppTokens>();

    return Row(
      spacing: tokens.spaceLayoutGapMd.w,
      children: [
        ProfileLabel(
          displayName: profileName,
          avatar: profileAvatar,
          label: 'By',
        ),
        if (hasSourceProfile) ...[
          SizedBox(width: tokens.spaceLayoutGapMd),
          ProfileLabel(
            displayName: sourceProfileName!,
            avatar: sourceProfileAvatar,
            label: 'Originally By',
            isSourceAuthor: true,
          ),
        ],
      ],
    );
  }
}
