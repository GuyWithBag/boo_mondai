// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck.local.page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
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
    builder: (_) => ViewDeckLocalSheet(deckId: deckId),
  );
}

class ViewDeckLocalPage extends StatelessWidget {
  const ViewDeckLocalPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ViewDeckLocalSheet(deckId: deckId, showCloseButton: false),
      ),
    );
  }
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
    final deck = LocalDB.deck.selectByPk({'id': deckId});

    if (deck == null) {
      return ErrorState(
        exception: Exception('Deck not found.'),
        onRetry: () => context.pop(),
      );
    }

    final controller = context.read<ViewDecksLocalController>();
    final author = LocalDB.cachedProfile.selectByPk({'id': deck.userId});
    final sourceDeck = deck.sourceDeckId == null
        ? null
        : LocalDB.deck.selectByPk({'id': deck.sourceDeckId});
    final sourceAuthor = sourceDeck == null
        ? null
        : LocalDB.cachedProfile.selectByPk({'id': sourceDeck.userId});
    final reviewCards = LocalDB.reviewCard.getByDeckId(deckId);
    final templates = LocalDB.cardTemplate.getByDeckId(deckId);
    // final userId = LocalDB.profile.getOrCreate().userId;
    // final eligibleCards = DrillService.getEligibleDrillCards(deckId, userId);
    // final canDrill = eligibleCards.isNotEmpty;
    // final navigator = Navigator.of(context);

    final title = deck.title.isEmpty ? 'Untitled deck' : deck.title;
    final shortDescription = deck.shortDescription.isEmpty
        ? 'No short description yet.'
        : deck.shortDescription;
    final longDescription = deck.longDescription.isEmpty
        ? 'No long description yet.'
        : deck.longDescription;
    final coverImageUrl = _nonEmptyOrNull(deck.coverImageUrl);

    Future<void> deleteDeckDialog() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete deck?'),
          content: Text('"$title" and all its cards will be removed.'),
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

    final horizontalPadding = 24.w;
    final verticalPadding = 16.h;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: showCloseButton ? 0.9 : 1,
      minChildSize: showCloseButton ? 0.5 : 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Scaffold(
          bottomNavigationBar: _BottomNavBar(deckId: deckId),
          appBar: AppBar(
            actions: [
              TactileButton.icon(
                icon: Icons.edit,
                onPressed: deck.isEditable
                    ? () => context.push('/decks-local/$deckId/edit')
                    : null,
              ),
              SizedBox(width: 10),
              TactileButton.icon(
                icon: Icons.delete,
                tone: TactileTone.error,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/');
                },
              ),
              SizedBox(width: horizontalPadding),
            ],
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
          ),
          body: Surface(
            style: surfaceStyle.resolve(tokens, const [
              SurfaceShape.sharp,
              SurfacePadding.none,
            ]),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                _SheetHero(
                  deck: deck,
                  title: title,
                  coverImageUrl: coverImageUrl,
                ),
                Padding(
                  padding: EdgeInsets.all(tokens.spacePanelPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthorAvatarRow(
                        author: author,
                        sourceAuthor: sourceAuthor,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _MetadataPanel(
                        deck: deck,
                        reviewCardCount: reviewCards.length,
                        templateCount: templates.length,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _TagsPanel(tags: deck.tags),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _DescriptionPanel(
                        shortDescription: shortDescription,
                        longDescription: longDescription,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _nonEmptyOrNull(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return value;
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({super.key, required this.deckId});

  final String deckId;
  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final deck = LocalDB.deck.selectByPk({'id': deckId});
    final userId = LocalDB.profile.getOrCreate().userId;
    final eligibleCards = DrillService.getEligibleDrillCards(deckId, userId);
    final canDrill = eligibleCards.isNotEmpty;
    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceTone.muted,
        SurfaceShape.sharp,
      ]),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: TactileButton(
              tone: TactileTone.ghost,
              child: Text("View Cards"),
            ),
          ),
          Expanded(
            child: _StartDrilButton(
              canDrill: canDrill,
              cardCount: deck!.cardCount,
              eligibleCount: eligibleCards.length,
              onPressed: () => context.push('/decks-local/$deckId/edit'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHero extends StatelessWidget {
  const _SheetHero({
    required this.deck,
    required this.title,
    required this.coverImageUrl,
  });

  final Deck deck;
  final String title;
  final String? coverImageUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverImageUrl != null)
            Image.network(coverImageUrl!, fit: BoxFit.cover)
          else
            ColoredBox(color: tokens.softGray),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(tokens.spacePanelGapMd),
              child: Wrap(
                spacing: tokens.spacePanelGapSm,
                runSpacing: tokens.spacePanelGapSm,
                children: [
                  if (deck.isPremade) const StatusBadge(label: 'Premade'),
                  StatusBadge(label: deck.isPublished ? 'Published' : 'Draft'),
                  StatusBadge(label: deck.isEditable ? 'Editable' : 'Locked'),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(tokens.spacePanelPadding),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DeckTile(deck: deck, width: 150),
                  SizedBox(width: tokens.spacePanelGapLg),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionEyebrow(_visibilityLabel(deck.visibilityState)),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appTextStyle.resolve(tokens, const [
                            TextSize.header,
                            TextWeight.heavy,
                          ]),
                        ),
                        Text(
                          deck.shortDescription,
                          style: appTextStyle.resolve(tokens, const [
                            TextSize.label,
                            TextWeight.base,
                          ]),
                        ),
                      ],
                    ),
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

class _StartDrilButton extends StatelessWidget {
  const _StartDrilButton({
    required this.canDrill,
    required this.eligibleCount,
    required this.cardCount,
    required this.onPressed,
  });

  final bool canDrill;
  final int eligibleCount;
  final int cardCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final drillLabel = cardCount == 0
        ? 'No cards yet'
        : canDrill
        ? 'Start drill ($eligibleCount)'
        : 'Completed';

    return TactileButton(
      tone: TactileTone.filled,
      leading: const Icon(Icons.play_arrow_rounded),
      onPressed: onPressed,
      child: Text(drillLabel),
    );
  }
}

class _MetadataPanel extends StatelessWidget {
  const _MetadataPanel({
    required this.deck,
    required this.reviewCardCount,
    required this.templateCount,
  });

  final Deck deck;
  final int reviewCardCount;
  final int templateCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _Panel(
      title: 'Deck Info',
      child: Wrap(
        spacing: tokens.spacePanelGapMd,
        runSpacing: tokens.spacePanelGapMd,
        children: [
          MetaLabel(
            icon: Icons.style_outlined,
            label: '${deck.cardCount} cards',
          ),
          MetaLabel(
            icon: Icons.layers_outlined,
            label: '$reviewCardCount review cards',
          ),
          MetaLabel(
            icon: Icons.dashboard_customize_outlined,
            label: '$templateCount templates',
          ),
          MetaLabel(
            icon: Icons.new_releases_outlined,
            label: 'v${deck.version}+${deck.buildNumber}',
          ),
          MetaLabel(
            icon: Icons.visibility_outlined,
            label: _visibilityLabel(deck.visibilityState),
          ),
          MetaLabel(
            icon: Icons.calendar_today_outlined,
            label: 'Created ${_formatDate(deck.createdAt)}',
          ),
          MetaLabel(
            icon: Icons.update_outlined,
            label: 'Updated ${_formatDate(deck.updatedAt)}',
          ),
          if (deck.sourceDeckId != null)
            MetaLabel(icon: Icons.call_split_outlined, label: 'Forked deck'),
        ],
      ),
    );
  }
}

class _TagsPanel extends StatelessWidget {
  const _TagsPanel({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Tags',
      child: tags.isEmpty
          ? const MetaLabel(icon: Icons.tag_outlined, label: 'No tags yet')
          : Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [for (final tag in tags) StatusBadge(label: tag.name)],
            ),
    );
  }
}

class _DescriptionPanel extends StatelessWidget {
  const _DescriptionPanel({
    required this.shortDescription,
    required this.longDescription,
  });

  final String shortDescription;
  final String longDescription;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _Panel(
      title: 'Description',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shortDescription,
            style: appTextStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.strong,
              TextTone.secondary,
            ]),
          ),
          SizedBox(height: tokens.spacePanelGapMd),
          Text(
            longDescription,
            style: appTextStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.body,
              TextTone.primary,
            ]),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceShape.sharp]),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacePanelGapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionEyebrow(title, tone: SectionEyebrowTone.primary),
            SizedBox(height: tokens.spacePanelGapMd),
            child,
          ],
        ),
      ),
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
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}
