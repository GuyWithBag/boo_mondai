import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        AppTokens,
        PhysicalCardSide,
        MarkdownText,
        SurfaceBorder;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardBackSide extends StatelessWidget {
  const FlashcardBackSide({
    required this.template,
    required this.studyCard,
    this.maxWidth = 460,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return PhysicalCardSide(
      maxWidth: maxWidth,
      surfaceStyleVariants: const [SurfaceBorder.primary],
      child: Center(
        child: Column(
          key: const ValueKey('flashcard-back'),
          mainAxisSize: MainAxisSize.min,
          children: [
            MarkdownText(
              data: template.getQuestion(isReversed: studyCard.isReversed),
            ),
            SizedBox(height: 26.h),
            Container(
              width: 64.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: tokens.colorBorderNeutralSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            SizedBox(height: 32.h),
            MarkdownText(
              data: template.getAnswer(isReversed: studyCard.isReversed),
            ),
          ],
        ),
      ),
    );
  }
}
