import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        EditDeckController,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        Button,
        useSelectionController,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckBottomNavbar extends HookWidget {
  const EditDeckBottomNavbar({required this.editor, super.key});

  final EditDeckController editor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final formats = [
      (Icons.slideshow_outlined, 'Flashcard'),
      (Icons.list, 'Multiple Choice'),
      (Icons.draw, 'Fill in Blanks'),
      (Icons.shuffle, 'Match Madness'),
    ];
    final selection = useSelectionController<int>(
      selectedValues: [editor.selectedFormatIndex],
      onSelectionChanged: (selected) {
        if (selected.isEmpty) return;
        editor.setFormatIndex(selected.first);
      },
    );

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceBorder.top,
        SurfacePadding.none,
        SurfaceShape.sharp,
        SurfaceShadow.none,
      ]),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceLayoutGapMd,
            vertical: tokens.spaceLayoutGapSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: tokens.spaceLayoutGapSm,
                    children: [
                      for (var index = 0; index < formats.length; index++) ...[
                        Button(
                          leading: Icon(formats[index].$1),
                          selected: selection.isSelected(index),
                          onPressed: () => selection.select(index),
                          child: Text(
                            formats[index].$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(width: tokens.spaceLayoutGapMd),
            ],
          ),
        ),
      ),
    );
  }
}
