import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StudySessionBottomNavBar extends StatelessWidget {
  const StudySessionBottomNavBar({
    required this.studySessionController,
    required this.interactionsController,
    super.key,
  });

  final StudySessionController studySessionController;
  final StudySessionCardStageController interactionsController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 28.h),
      decoration: BoxDecoration(
        color: tokens.backgroundSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        border: Border(
          top: BorderSide(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -10),
            blurRadius: 40,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480.w),
          child: RatingArea(
            studySessionController: studySessionController,
            interactionsController: interactionsController,
          ),
        ),
      ),
    );
  }
}
