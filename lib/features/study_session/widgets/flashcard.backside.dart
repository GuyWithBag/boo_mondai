import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        AppTokens,
        SurfaceTone,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        PhysicalCardSide;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardBackSide extends StatelessWidget {
  const FlashcardBackSide({
    required this.template,
    required this.studyCard,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return PhysicalCardSide(
      maxWidth: 460,
      tone: SurfaceTone.primaryOutline,
      child: Center(
        child: Column(
          key: const ValueKey('flashcard-back'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              template.getQuestion(isReversed: studyCard.isReversed),
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, [
                TextSize.cardBackFront,
                TextWeight.heavy,
                TextTone.primary,
              ]),
            ),
            SizedBox(height: 26.h),
            Container(
              width: 64.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: tokens.borderNeutralSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              template.getAnswer(isReversed: studyCard.isReversed),
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, [
                TextSize.cardBackContent,
                TextWeight.heavy,
                TextTone.brand,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
