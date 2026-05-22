import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import '../../variant_styles/tactile_button.variant.dart';
import '../../widgets/meta_label.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/tactile_button.dart';

class EditDeckAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EditDeckAppbar({
    required this.tokens,
    required this.titleController,
    required this.onSave,
    this.isSaving = false,
    super.key,
  });

  static const double height = 88;

  final AppTokens tokens;
  final TextEditingController titleController;
  final Future<void> Function() onSave;
  final bool isSaving;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = 24.w;
    final verticalPadding = 16.h;

    return AppBar(
      leadingWidth: 100.w,
      leading: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding + 4,
        ),
        child: TactileButton.icon(
          icon: Icons.arrow_back,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/');
          },
        ),
      ),
      title: SizedBox(
        height: preferredSize.height,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const StatusBadge(label: 'Draft Deck'),
                  const MetaLabel(icon: Icons.lock, label: 'Private'),
                ],
              ),
              SizedBox(height: 4.h),
              TextField(
                controller: titleController,
                style: TextStyle(
                  color: tokens.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Deck Title...',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TactileButton(
                tone: TactileTone.filled,
                onPressed: isSaving ? null : onSave,
                child: isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
        SizedBox(width: horizontalPadding),
      ],
    );
  }
}
