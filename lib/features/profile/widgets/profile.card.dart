import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AuthController, EditableTextValue, AppSpacing, ProfileAvatar;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        SizedBox,
        Theme,
        FontWeight,
        FontStyle,
        CrossAxisAlignment,
        MainAxisSize,
        Text,
        Column,
        Center,
        Expanded,
        Row,
        LayoutBuilder;
import 'package:provider/provider.dart' show WatchContext;
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final tokens = context.themeTokens<AppTokens>();
    final profile = auth.currentProfile;
    final email = auth.currentEmail;
    final displayName = profile.displayName.trim().isEmpty
        ? 'Guest User'
        : profile.displayName.trim();

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        EditableTextValue(
          value: displayName,
          editingValue: profile.displayName,
          placeholder: 'Display name',
          textStyle: textStyle.resolve(tokens, const [TextSize.headerLarge]),
          onSave: auth.updateDisplayName,
        ),
        Text(
          '@${profile.username}',
          style: textStyle.resolve(tokens, const []),
        ),
        if (!profile.isAnonymous && email != null) ...[
          Text(email, style: textStyle.resolve(tokens, const [])),
        ],
        Text(
          'Joined at ${_formatShortDate(profile.createdAt)}',
          style: textStyle.resolve(tokens, const []),
        ),
      ],
    );

    return Surface(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ProfileAvatar(
                    displayName: displayName,
                    avatarUrl: profile.avatarUrl,
                    radius: 66,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                details,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                displayName: displayName,
                avatarUrl: profile.avatarUrl,
                radius: 66,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}

String _formatShortDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
