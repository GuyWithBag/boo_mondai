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
    this.profileAvatarUrl,
    this.sourceProfileName,
    this.sourceProfileAvatarUrl,
  });

  final String profileName;
  final String? profileAvatarUrl;
  final String? sourceProfileName;
  final String? sourceProfileAvatarUrl;

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
          avatarUrl: profileAvatarUrl,
          label: 'By',
        ),
        if (hasSourceProfile) ...[
          SizedBox(width: tokens.spaceLayoutGapMd),
          ProfileLabel(
            displayName: sourceProfileName!,
            avatarUrl: sourceProfileAvatarUrl,
            label: 'Originally By',
            isSourceAuthor: true,
          ),
        ],
      ],
    );
  }
}
