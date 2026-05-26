// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/error_state.dart
// PURPOSE: Reusable error state with message and optional retry button
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show AppColors, AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.exception, this.onRetry});

  final Exception? exception;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (exception == null) {
      return SizedBox.shrink();
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56.r, color: AppColors.incorrect),
          SizedBox(height: AppSpacing.md.h),
          Text(
            exception.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppSpacing.md.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
