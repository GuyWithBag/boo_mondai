import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        DateHelper,
        EditableTextValue,
        ViewProfileController,
        ProfileAvatar,
        controller;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        Icons,
        MainAxisSize,
        TextAlign,
        Widget,
        CrossAxisAlignment;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:provider/provider.dart' show WatchContext;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

class ProfileCard extends SignalWidget {
  const ProfileCard({super.key, required this.controller});

  final ViewProfileController controller;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    final tokens = context.themeTokens<AppTokens>();

    final profile = controller.profile.value;
    final email = auth.currentEmail;
    final displayName = profile.displayName.trim().isEmpty
        ? 'Guest User'
        : profile.displayName.trim();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceBorder.none,
        SurfaceShape.roundedXsm,
        SurfaceShadow.none,
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: tokens.spaceLayoutGapSm.h,
        children: [
          ProfileAvatar(
            displayName: displayName,
            avatar: controller.pickedAvatarImage.value,
            radius: 66,
            onImagePicked: controller.onImagePicked,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: tokens.spaceLayoutGapXsm,
            children: [
              EditableTextValue(
                value: displayName,
                placeholder: 'Display name',
                textStyle: textStyle.resolve(tokens, const [
                  TextSize.headerLarge,
                ]),
                ensureEditActionsAreVisibleWhenKeyboardVisible: false,
                onSave: controller.upsertDisplayName,
                textAlign: TextAlign.center,
              ),
              MetaLabel(label: '@${profile.username}'),
              if (!profile.isAnonymous && email != null) ...[
                // Text(email, style: textStyle.resolve(tokens, const [])),
                MetaLabel(label: email),
              ],
              MetaLabel(
                label:
                    'Joined at ${DateHelper.formatDateYyyyMmDd(profile.createdAt)}',
                icon: Icons.calendar_month,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
