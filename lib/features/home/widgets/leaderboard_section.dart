// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home/leaderboard_section.dart
// PURPOSE: Home page leaderboard preview with current-user rank context
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button, buttonStyle,
        ButtonSize,
        ButtonPadding,
        LeaderboardEntry,
        LeaderboardTileWidget,
        SurfaceBorder,
        SurfaceShape,
        surfaceStyle,
        SurfaceShadow;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({
    super.key,
    required this.entries,
    required this.isLoading,
    required this.currentUserId,
  });

  final List<LeaderboardEntry> entries;
  final bool isLoading;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final previewEntries = _previewEntries(entries, currentUserId);

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceShape.roundedXsm,
        SurfaceBorder.none,
        SurfaceShadow.none,
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: tokens.fontWeightTextHeavy,
                        color: tokens.colorTextBaseline,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Keep your reviews consistent to advance',
                      style: TextStyle(
                        fontSize: tokens.textSizeLabel.sp,
                        fontWeight: tokens.fontWeightTextStrong,
                        color: tokens.colorTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.workspace_premium_outlined,
                color: tokens.colorTextBaseline,
                size: 30.sp,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (previewEntries.isEmpty)
            Text(
              'No scores yet. Complete a drill to appear here.',
              style: TextStyle(
                color: tokens.colorTextMuted,
                fontWeight: tokens.fontWeightTextStrong,
              ),
            )
          else
            ...previewEntries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: LeaderboardTileWidget(
                  rank: entries.indexOf(entry) + 1,
                  entry: entry,
                  isCurrentUser: entry.userId == currentUserId,
                ),
              ),
            ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: Button(
              onPressed: () => context.push('/leaderboard'),

              style: buttonStyle.resolve(tokens, const [ButtonSize.lg, ButtonPadding.lg]),
              child: const Text('SEE ALL RANKINGS'),
            ),
          ),
        ],
      ),
    );
  }

  List<LeaderboardEntry> _previewEntries(
    List<LeaderboardEntry> entries,
    String currentUserId,
  ) {
    if (entries.isEmpty) {
      return const [];
    }

    final currentIndex = entries.indexWhere(
      (entry) => entry.userId == currentUserId,
    );
    if (currentIndex == -1) {
      return [entries.first];
    }

    final result = <LeaderboardEntry>[entries[currentIndex]];
    final behindIndex = currentIndex + 1;
    if (behindIndex < entries.length) {
      result.add(entries[behindIndex]);
    }
    return result;
  }
}
