import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        EditDeckEditorController,
        FormatSelector,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckBottomNavbar extends StatelessWidget {
  const EditDeckBottomNavbar({required this.editor, super.key});

  final EditDeckEditorController editor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

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
          child: FormatSelector(
            selectedIndex: editor.selectedFormatIndex,
            onChanged: editor.setFormatIndex,
          ),
        ),
      ),
    );
  }
}
