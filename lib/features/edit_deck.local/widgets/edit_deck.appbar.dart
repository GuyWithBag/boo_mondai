import 'package:flutter/material.dart' hide SliverAppBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:boo_mondai/lib.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckAppbar extends StatelessWidget {
  const EditDeckAppbar({
    required this.titleController,
    required this.onSave,
    this.isSaving = false,
    super.key,
  });

  final TextEditingController titleController;
  final Future<void> Function() onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final horizontalPadding = tokens.spaceLayoutPadding;
    final verticalPadding = tokens.spaceLayoutPadding;

    return SliverAppBar(
      leadingWidth: 100.w,
      title: SizedBox(
        height: 88,
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
                  const HeaderBadge(label: 'Draft Deck'),
                  const MetaLabel(icon: Icons.lock, label: 'Private'),
                ],
              ),
              SizedBox(height: 4.h),
              TextField(
                controller: titleController,
                style: TextStyle(
                  color: tokens.colorTextBaseline,
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
              Button(
                variants: const [ButtonTone.filled],
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
