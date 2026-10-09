import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        surfaceStyle,
        WordScrambleDragPayload;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/scaled_surface_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals/signals_flutter.dart';
import 'package:theme_variants/theme_variants.dart';

class WordInsertTarget extends SignalWidget {
  const WordInsertTarget({
    super.key,
    required this.index,
    required this.locked,
    required this.contentScale,
    required this.onAccept,
  });

  final int index;
  final bool locked;
  final double contentScale;
  final ValueChanged<WordScrambleDragPayload> onAccept;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return DragTarget<WordScrambleDragPayload>(
      onWillAcceptWithDetails: (_) => !locked,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        final resolvedStyle = surfaceStyle.resolve(tokens, [
          active ? SurfaceColor.primarySoft : SurfaceColor.invisible,
          SurfacePadding.none,
          SurfaceShape.roundedXxsm,
          SurfaceShadow.none,
        ]);
        final scaledStyle = scaledSurfaceStyle(
          resolvedStyle.copyWith(width: active ? 10.w : 5.w, height: 42.h),
          contentScale,
        );

        return Surface(
          duration: const Duration(milliseconds: 120),
          style: scaledStyle,
          child: const SizedBox.shrink(),
        );
      },
    );
  }
}
