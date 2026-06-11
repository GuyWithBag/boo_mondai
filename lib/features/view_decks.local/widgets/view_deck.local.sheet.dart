// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck.local.page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/widgets/widgets.barrel.dart';
import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/features/view_decks.local/widgets/view_deck.local.bottom_navbar.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonTone,
        ChipInput,
        CachedProfile,
        ChipTone,
        Deck,
        DeckProfilesLabel,
        DeckTile,
        ErrorState,
        HeaderBadge,
        LocalDB,
        MetaLabel,
        Profile,
        SectionEyebrow,
        SurfacePadding,
        SurfaceShape,
        SurfaceTone,
        TextSize,
        TextTone,
        TextWeight,
        ViewDecksLocalController,
        VisibilityState,
        appChipStyle,
        appTextStyle,
        surfaceStyle,
        useViewDeckLocalSheet;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

Future<void> showViewDeckLocalSheet(BuildContext context, String deckId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ViewDeckLocalSheet(deckId: deckId),
  );
}

class ViewDeckLocalSheet extends HookWidget {
  const ViewDeckLocalSheet({
    super.key,
    required this.deckId,
    this.showCloseButton = true,
  });

  final String deckId;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewDecksLocalController>();
    final sheet = useViewDeckLocalSheet(
      context: context,
      deckId: deckId,
      controller: controller,
    );
    final deck = sheet.deck;

    if (deck == null) {
      return ErrorState(
        exception: Exception('Deck not found.'),
        onRetry: () => context.pop(),
      );
    }
    final studyCards = LocalDB.studyCard.getByDeckId(deckId);
    final templates = LocalDB.cardTemplate.getByDeckId(deckId);

    Future<void> deleteDeckDialog() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete deck?'),
          content: Text('"${sheet.title}" and all its cards will be removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      await controller.deleteDeck(deckId);
      if (!context.mounted) return;

      context.pop();
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: showCloseButton ? 0.9 : 1,
      minChildSize: showCloseButton ? 0.5 : 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Surface(
          style: surfaceStyle.resolve(tokens, const [
            SurfacePadding.none,
            SurfaceTone.muted,
          ]),
          hasClipRRect: true,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: ViewDeckLocalBottomNavbar(deckId: deckId),
            body: _Body(
              deck: deck,
              title: sheet.title,
              coverImageUrl: sheet.coverImageUrl,
              shortDescription: sheet.shortDescription,
              longDescription: sheet.longDescription,
              studyCardCount: studyCards.length,
              templateCount: templates.length,
              showCloseButton: showCloseButton,
              isSavingPublishState: sheet.isSavingPublishState,
              onPublishedChanged: sheet.onPublishedChanged,
              onTagsChanged: sheet.onTagsChanged,
              onBackPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                context.go('/');
              },
              onEditPressed: deck.isEditable
                  ? () => context.push('/decks-local/$deckId/edit')
                  : null,
              onDeletePressed: deleteDeckDialog,
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.deck,
    required this.title,
    required this.coverImageUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.studyCardCount,
    required this.templateCount,
    required this.showCloseButton,
    required this.isSavingPublishState,
    required this.onPublishedChanged,
    required this.onTagsChanged,
    required this.onBackPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final Deck deck;
  final String title;
  final String? coverImageUrl;
  final String shortDescription;
  final String longDescription;
  final int studyCardCount;
  final int templateCount;
  final bool showCloseButton;
  final bool isSavingPublishState;
  final ValueChanged<bool> onPublishedChanged;
  final ValueChanged<List<String>> onTagsChanged;
  final VoidCallback onBackPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final publishChipStyle = appChipStyle.resolve(tokens, [
      deck.isPublished ? ChipTone.filled : ChipTone.hard,
    ]);

    final deckWidth = 150.w.clamp(118.0, 170.0).toDouble();
    final headerHeight = 350.h.clamp(300.0, 390.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: SizedBox(
            height: headerHeight + tokens.radiusSurfaceLg,
            child: BackgroundImageSurface(),
          ),
        ),
        Column(
          children: [
            SizedBox(height: headerHeight),
            SizedBox(
              width: double.infinity,
              child: Surface(
                style: surfaceStyle.resolve(tokens, const [
                  SurfaceShape.topRounded,
                  SurfaceTone.muted,
                  SurfaceBorder.top,
                  SurfaceShadow.none,
                ]),
                child: _DeckDetails(
                  deck: deck,
                  title: title,
                  shortDescription: shortDescription,
                  longDescription: longDescription,
                  studyCardCount: studyCardCount,
                  templateCount: templateCount,
                  onTagsChanged: onTagsChanged,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: tokens.spacePanelPadding,
          right: tokens.spacePanelPadding,
          top: tokens.spacePanelPadding,
          child: Row(
            children: [
              if (showCloseButton)
                Button.icon(icon: Icons.close, onPressed: onBackPressed)
              else
                Button.icon(icon: Icons.arrow_back, onPressed: onBackPressed),
              const Spacer(),
              Button.icon(icon: Icons.edit, onPressed: onEditPressed),
              SizedBox(width: tokens.spacePanelGapSm),
              Button.icon(
                icon: Icons.delete_outline,
                tone: ButtonTone.error,
                onPressed: onDeletePressed,
              ),
            ],
          ),
        ),
        Positioned(
          top: 110.h,
          left: tokens.spacePanelPadding,
          right: tokens.spacePanelPadding,
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: tokens.spacePanelGapSm,
            runSpacing: tokens.spacePanelGapSm,
            children: [
              if (deck.isPremade) const HeaderBadge(label: 'Premade'),
              ChipTheme(
                data: publishChipStyle,
                child: ChoiceChip(
                  avatar: Icon(
                    deck.isPublished
                        ? Icons.public_outlined
                        : Icons.public_off_outlined,
                  ),
                  label: Text(deck.isPublished ? 'Published' : 'Draft'),
                  selected: deck.isPublished,
                  onSelected: isSavingPublishState ? null : onPublishedChanged,
                ),
              ),
              Chip(label: Text(deck.isEditable ? 'Editable' : 'Locked')),
            ],
          ),
        ),
        Positioned(
          right: tokens.spacePanelPadding,
          top: 210.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MetaLabel(
                icon: Icons.new_releases_outlined,
                label: 'v${deck.version}.${deck.buildNumber}',
                tooltip: 'Deck version and build number',
              ),
              SizedBox(height: tokens.spacePanelGapSm),
              MetaLabel(
                icon: Icons.calendar_today_outlined,
                label: _formatDate(deck.createdAt),
                tooltip: 'Created ${_formatDate(deck.createdAt)}',
              ),
              SizedBox(height: tokens.spacePanelGapSm),
              MetaLabel(
                icon: Icons.update_outlined,
                label: _formatDate(deck.updatedAt),
                tooltip: 'Updated ${_formatDate(deck.updatedAt)}',
              ),
            ],
          ),
        ),
        Positioned(
          left: tokens.spacePanelPadding,
          top: headerHeight - (deckWidth / tokens.cardAspectRatio) - 10.h,
          child: DeckTile(deck: deck, width: deckWidth),
        ),
      ],
    );
  }
}

class _DeckDetails extends StatelessWidget {
  const _DeckDetails({
    required this.deck,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.studyCardCount,
    required this.templateCount,
    required this.onTagsChanged,
  });

  final Deck deck;
  final String title;
  final String shortDescription;
  final String longDescription;
  final int studyCardCount;
  final int templateCount;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final profile =
        LocalDB.cachedProfile.selectByPk({'id': deck.userId}) ??
        LocalDB.profile.getOrCreate();
    final profileName = switch (profile) {
      CachedProfile(:final username) => username,
      Profile(:final username) => username,
      _ => 'Unknown user',
    };
    final profileAvatarUrl = switch (profile) {
      CachedProfile(:final avatarUrl) => avatarUrl,
      Profile(:final avatarUrl) => avatarUrl,
      _ => null,
    };
    final sourceDeck = deck.sourceDeckId == null
        ? null
        : LocalDB.deck.selectByPk({'id': deck.sourceDeckId});
    final sourceProfile = sourceDeck == null
        ? null
        : LocalDB.cachedProfile.selectByPk({'id': sourceDeck.userId});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DeckProfilesLabel(
              profileName: profileName,
              profileAvatarUrl: profileAvatarUrl,
              sourceProfileName: sourceProfile?.username,
              sourceProfileAvatarUrl: sourceProfile?.avatarUrl,
            ),
          ],
        ),
        Row(
          spacing: tokens.spacePanelGapMd.w,
          children: [
            MetaLabel(
              icon: Icons.visibility_outlined,
              label: _visibilityLabel(deck.visibilityState),
            ),
            MetaLabel(
              icon: Icons.style_outlined,
              label: '${deck.cardCount} cards',
            ),
          ],
        ),

        SizedBox(height: tokens.spacePanelGapLg),
        Text(
          title,
          style: appTextStyle.resolve(tokens, const [
            TextSize.header,
            TextWeight.heavy,
          ]),
        ),
        SizedBox(height: tokens.spacePanelGapMd),
        Text(
          shortDescription,
          style: appTextStyle.resolve(tokens, const [
            TextSize.labelSmall,
            TextWeight.body,
            TextTone.primary,
          ]),
        ),
        SizedBox(height: tokens.spacePanelGapMd),
        Text(
          longDescription,
          style: appTextStyle.resolve(tokens, const [
            TextSize.bodyLarge,
            TextWeight.body,
            TextTone.primary,
          ]),
        ),
        SizedBox(height: tokens.spacePanelGapLg * 2),
        SectionEyebrow('Tags'),
        SizedBox(height: tokens.spacePanelGapMd),
        ChipInput(
          values: deck.tags.map((tag) => tag.name).toList(),
          onChanged: onTagsChanged,
          placeholder: deck.isEditable ? 'Add tags' : 'No tags yet',
          enabled: deck.isEditable,
          chipTone: ChipTone.ghost,
        ),
      ],
    );
  }
}

String _visibilityLabel(VisibilityState state) {
  return switch (state) {
    VisibilityState.private => 'Private',
    VisibilityState.public => 'Public',
    VisibilityState.unlisted => 'Unlisted',
  };
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
