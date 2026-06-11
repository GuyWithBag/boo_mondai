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
        ChipTone,
        Deck,
        DeckProfilesLabel,
        DeckTile,
        HeaderBadge,
        LocalDB,
        MetaLabel,
        SectionEyebrow,
        SurfacePadding,
        SurfaceShape,
        SurfaceTone,
        TextSize,
        TextTone,
        TextWeight,
        ViewDecksLocalController,
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

Future<void> showViewDeckLocalSheet(BuildContext context, Deck deck) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ViewDeckLocalSheet(deck: deck),
  );
}

class ViewDeckLocalSheet extends HookWidget {
  const ViewDeckLocalSheet({
    super.key,
    required this.deck,
    this.showCloseButton = true,
  });

  final Deck deck;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewDecksLocalController>();
    final sheet = useViewDeckLocalSheet(
      context: context,
      initialDeck: deck,
      controller: controller,
    );
    final sheetDeck = sheet.deck;
    final studyCards = LocalDB.studyCard.getByDeckId(sheetDeck.id);
    final templates = LocalDB.cardTemplate.getByDeckId(sheetDeck.id);

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
            bottomNavigationBar: ViewDeckLocalBottomNavbar(
              deckId: sheetDeck.id,
            ),
            body: _Body(
              scrollController: scrollController,
              deck: sheetDeck,
              title: sheet.title,
              coverImageUrl: sheet.coverImageUrl,
              profileName: sheet.profileName,
              profileAvatarUrl: sheet.profileAvatarUrl,
              sourceProfileName: sheet.sourceProfileName,
              sourceProfileAvatarUrl: sheet.sourceProfileAvatarUrl,
              visibilityLabel: sheet.visibilityLabel,
              shortDescription: sheet.shortDescription,
              longDescription: sheet.longDescription,
              studyCardCount: studyCards.length,
              templateCount: templates.length,
              showCloseButton: showCloseButton,
              isSavingPublishState: sheet.isSavingPublishState,
              onPublishedChanged: sheet.onPublishedChanged,
              onTitleChanged: sheet.onTitleChanged,
              onShortDescriptionChanged: sheet.onShortDescriptionChanged,
              onLongDescriptionChanged: sheet.onLongDescriptionChanged,
              onTagsChanged: sheet.onTagsChanged,
              onBackPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                context.go('/');
              },
              onEditPressed: sheetDeck.isEditable
                  ? () => context.push('/decks-local/${sheetDeck.id}/edit')
                  : null,
              onDeletePressed: sheet.onDeletePressed,
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.scrollController,
    required this.deck,
    required this.title,
    required this.coverImageUrl,
    required this.profileName,
    required this.profileAvatarUrl,
    required this.sourceProfileName,
    required this.sourceProfileAvatarUrl,
    required this.visibilityLabel,
    required this.shortDescription,
    required this.longDescription,
    required this.studyCardCount,
    required this.templateCount,
    required this.showCloseButton,
    required this.isSavingPublishState,
    required this.onPublishedChanged,
    required this.onTitleChanged,
    required this.onShortDescriptionChanged,
    required this.onLongDescriptionChanged,
    required this.onTagsChanged,
    required this.onBackPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final ScrollController scrollController;
  final Deck deck;
  final String title;
  final String? coverImageUrl;
  final String profileName;
  final String? profileAvatarUrl;
  final String? sourceProfileName;
  final String? sourceProfileAvatarUrl;
  final String visibilityLabel;
  final String shortDescription;
  final String longDescription;
  final int studyCardCount;
  final int templateCount;
  final bool showCloseButton;
  final bool isSavingPublishState;
  final ValueChanged<bool> onPublishedChanged;
  final Future<void> Function(String value) onTitleChanged;
  final Future<void> Function(String value) onShortDescriptionChanged;
  final Future<void> Function(String value) onLongDescriptionChanged;
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

    final deckWidth = 160.w;
    final headerHeight = 350.h.clamp(300.0, 390.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: headerHeight + tokens.radiusSurfaceLg,
                    child: BackgroundImageSurface(),
                  ),
                  Column(
                    children: [
                      SizedBox(height: headerHeight),
                      _BodySubSection(
                        tokens: tokens,
                        deck: deck,
                        deckWidth: deckWidth,
                        scrollController: scrollController,
                        collapseDistance: headerHeight * 0.55,
                        profileName: profileName,
                        profileAvatarUrl: profileAvatarUrl,
                        sourceProfileName: sourceProfileName,
                        sourceProfileAvatarUrl: sourceProfileAvatarUrl,
                        visibilityLabel: visibilityLabel,
                        title: title,
                        shortDescription: shortDescription,
                        longDescription: longDescription,
                        studyCardCount: studyCardCount,
                        templateCount: templateCount,
                        onTitleChanged: onTitleChanged,
                        onShortDescriptionChanged: onShortDescriptionChanged,
                        onLongDescriptionChanged: onLongDescriptionChanged,
                        onTagsChanged: onTagsChanged,
                      ),
                    ],
                  ),
                ],
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
              CollapsingHeaderItem(
                scrollController: scrollController,
                collapseDistance: headerHeight * 0.55,
                alignment: Alignment.topLeft,
                child: showCloseButton
                    ? Button.icon(icon: Icons.close, onPressed: onBackPressed)
                    : Button.icon(
                        icon: Icons.arrow_back,
                        onPressed: onBackPressed,
                      ),
              ),
              const Spacer(),
              CollapsingHeaderItem(
                scrollController: scrollController,
                collapseDistance: headerHeight * 0.55,
                alignment: Alignment.topRight,
                child: Button.icon(icon: Icons.edit, onPressed: onEditPressed),
              ),
              SizedBox(width: tokens.spacePanelGapSm),
              CollapsingHeaderItem(
                scrollController: scrollController,
                collapseDistance: headerHeight * 0.55,
                alignment: Alignment.topRight,
                child: Button.icon(
                  icon: Icons.delete_outline,
                  tone: ButtonTone.error,
                  onPressed: onDeletePressed,
                ),
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
              if (deck.isPremade)
                CollapsingHeaderItem(
                  scrollController: scrollController,
                  collapseDistance: headerHeight * 0.55,
                  alignment: Alignment.topRight,
                  child: const HeaderBadge(label: 'Premade'),
                ),
              CollapsingHeaderItem(
                scrollController: scrollController,
                collapseDistance: headerHeight * 0.55,
                alignment: Alignment.topRight,
                child: ChipTheme(
                  data: publishChipStyle,
                  child: ChoiceChip(
                    avatar: Icon(
                      deck.isPublished
                          ? Icons.public_outlined
                          : Icons.public_off_outlined,
                    ),
                    label: Text(deck.isPublished ? 'Published' : 'Draft'),
                    selected: deck.isPublished,
                    onSelected: isSavingPublishState
                        ? null
                        : onPublishedChanged,
                  ),
                ),
              ),
              if (!deck.isEditable)
                CollapsingHeaderItem(
                  scrollController: scrollController,
                  collapseDistance: headerHeight * 0.55,
                  alignment: Alignment.topRight,
                  child: const Chip(label: Text('Locked')),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BodySubSection extends StatelessWidget {
  const _BodySubSection({
    required this.tokens,
    required this.deck,
    required this.deckWidth,
    required this.scrollController,
    required this.collapseDistance,
    required this.profileName,
    required this.profileAvatarUrl,
    required this.sourceProfileName,
    required this.sourceProfileAvatarUrl,
    required this.visibilityLabel,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.studyCardCount,
    required this.templateCount,
    required this.onTitleChanged,
    required this.onShortDescriptionChanged,
    required this.onLongDescriptionChanged,
    required this.onTagsChanged,
  });

  final AppTokens tokens;
  final Deck deck;
  final double deckWidth;
  final ScrollController scrollController;
  final double collapseDistance;
  final String profileName;
  final String? profileAvatarUrl;
  final String? sourceProfileName;
  final String? sourceProfileAvatarUrl;
  final String visibilityLabel;
  final String title;
  final String shortDescription;
  final String longDescription;
  final int studyCardCount;
  final int templateCount;
  final Future<void> Function(String value) onTitleChanged;
  final Future<void> Function(String value) onShortDescriptionChanged;
  final Future<void> Function(String value) onLongDescriptionChanged;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Surface(
            style: surfaceStyle.resolve(tokens, const [
              SurfaceShape.topRounded,
              SurfaceTone.muted,
              SurfaceBorder.top,
              SurfaceShadow.none,
            ]),
            child: _DeckDetails(
              deck: deck,
              profileName: profileName,
              profileAvatarUrl: profileAvatarUrl,
              sourceProfileName: sourceProfileName,
              sourceProfileAvatarUrl: sourceProfileAvatarUrl,
              visibilityLabel: visibilityLabel,
              title: title,
              shortDescription: shortDescription,
              longDescription: longDescription,
              studyCardCount: studyCardCount,
              templateCount: templateCount,
              onTitleChanged: onTitleChanged,
              onShortDescriptionChanged: onShortDescriptionChanged,
              onLongDescriptionChanged: onLongDescriptionChanged,
              onTagsChanged: onTagsChanged,
            ),
          ),
          Positioned(
            left: tokens.spacePanelPadding,
            top:
                -(deckWidth / tokens.cardAspectRatio) +
                (tokens.radiusSurfaceLg - tokens.spacePanelPadding),
            child: CollapsingHeaderItem(
              scrollController: scrollController,
              collapseDistance: collapseDistance,
              alignment: Alignment.bottomLeft,
              child: DeckTile(deck: deck, width: deckWidth),
            ),
          ),
          Positioned(
            right: tokens.spacePanelPadding,
            top: -tokens.radiusSurfaceLg - tokens.spacePanelPadding,
            child: CollapsingHeaderItem(
              scrollController: scrollController,
              collapseDistance: collapseDistance,
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
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
          ),
        ],
      ),
    );
  }
}

class _DeckDetails extends StatelessWidget {
  const _DeckDetails({
    required this.deck,
    required this.profileName,
    required this.profileAvatarUrl,
    required this.sourceProfileName,
    required this.sourceProfileAvatarUrl,
    required this.visibilityLabel,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.studyCardCount,
    required this.templateCount,
    required this.onTitleChanged,
    required this.onShortDescriptionChanged,
    required this.onLongDescriptionChanged,
    required this.onTagsChanged,
  });

  final Deck deck;
  final String profileName;
  final String? profileAvatarUrl;
  final String? sourceProfileName;
  final String? sourceProfileAvatarUrl;
  final String visibilityLabel;
  final String title;
  final String shortDescription;
  final String longDescription;
  final int studyCardCount;
  final int templateCount;
  final Future<void> Function(String value) onTitleChanged;
  final Future<void> Function(String value) onShortDescriptionChanged;
  final Future<void> Function(String value) onLongDescriptionChanged;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DeckProfilesLabel(
              profileName: profileName,
              profileAvatarUrl: profileAvatarUrl,
              sourceProfileName: sourceProfileName,
              sourceProfileAvatarUrl: sourceProfileAvatarUrl,
            ),
          ],
        ),
        Row(
          spacing: tokens.spacePanelGapMd.w,
          children: [
            MetaLabel(icon: Icons.visibility_outlined, label: visibilityLabel),
            MetaLabel(
              icon: Icons.style_outlined,
              label: '${deck.cardCount} cards',
            ),
          ],
        ),
        EditableTextValue(
          value: title,
          editingValue: deck.title,
          enabled: deck.isEditable,
          placeholder: 'Deck title',
          onSave: onTitleChanged,
          textStyle: appTextStyle.resolve(tokens, const [
            TextSize.header,
            TextWeight.heavy,
          ]),
        ),
        EditableTextValue(
          value: shortDescription,
          editingValue: deck.shortDescription,
          enabled: deck.isEditable,
          placeholder: 'Short description',
          onSave: onShortDescriptionChanged,
          textStyle: appTextStyle.resolve(tokens, const [
            TextSize.labelSmall,
            TextWeight.body,
            TextTone.primary,
          ]),
        ),
        EditableTextValue(
          value: longDescription,
          editingValue: deck.longDescription,
          enabled: deck.isEditable,
          placeholder: 'Long description',
          maxLines: null,
          onSave: onLongDescriptionChanged,
          textStyle: appTextStyle.resolve(tokens, const [
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

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
