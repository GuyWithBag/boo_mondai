import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        Deck,
        DeckCommentWidget,
        DeckTile,
        DeckTileState,
        ErrorState,
        EditableTextValue,
        MetaLabel,
        SectionEyebrow,
        SurfacePadding,
        SurfaceShape,
        SurfaceColor,
        TextSize,
        TextColor,
        TextWeight,
        DeckDetails,
        ProfileLabel,
        MarkdownTextMode,
        ViewDeckOnlineSheetState,
        ViewDecksOnlineController,
        textStyle,
        surfaceStyle,
        useViewDeckOnlineSheet,
        ChangeReviewController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

Future<void> showViewDeckOnlineSheet(BuildContext context, Deck deck) {
  final controller = context.read<ViewDecksOnlineController>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider<ViewDecksOnlineController>.value(
      value: controller,
      child: ViewDeckOnlineSheet(deck: deck),
    ),
  );
}

class ViewDeckOnlineSheet extends HookWidget {
  const ViewDeckOnlineSheet({
    super.key,
    required this.deck,
    this.showCloseButton = true,
  });

  final Deck deck;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewDecksOnlineController>();
    final changeReviewController = context.read<ChangeReviewController>();
    final sheet = useViewDeckOnlineSheet(
      deckId: deck.id,
      initialDeck: deck,
      controller: controller,
      changeReviewController: changeReviewController,
    );
    final sheetDeck = sheet.deck;

    useEffect(() {
      final error = sheet.error;
      if (error == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
        sheet.clearErrors();
      });
      return null;
    }, [sheet.error]);

    if (sheetDeck == null) {
      return ErrorState(
        exception: Exception('Online deck not found.'),
        onRetry: () => context.pop(),
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: showCloseButton ? 0.92 : 1,
      minChildSize: showCloseButton ? 0.55 : 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Surface(
          style: surfaceStyle.resolve(tokens, const [
            SurfacePadding.none,
            SurfaceColor.muted,
          ]),
          hasClipRRect: true,
          child: _Body(
            scrollController: scrollController,
            deck: sheetDeck,
            sheet: sheet,
            showCloseButton: showCloseButton,
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go('/');
            },
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
    required this.sheet,
    required this.showCloseButton,
    required this.onBackPressed,
  });

  final ScrollController scrollController;
  final Deck deck;
  final ViewDeckOnlineSheetState sheet;
  final bool showCloseButton;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroCarousel(imageUrls: sheet.carouselImageUrls),
                  SizedBox(height: tokens.spaceLayoutGapMd),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spaceLayoutPadding,
                    ),
                    child: _InteractionSummary(sheet: sheet),
                  ),
                  SizedBox(height: tokens.spaceLayoutGapMd),
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceShape.topRounded,
                      SurfaceColor.muted,
                      SurfacePadding.none,
                    ]),
                    child: Padding(
                      padding: EdgeInsets.all(tokens.spaceLayoutPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: tokens.spaceLayoutGapMd,
                                  runSpacing: tokens.spaceLayoutGapSm,
                                  children: [
                                    ProfileLabel(
                                      label: 'By',
                                      displayName: sheet.profileName,
                                      avatarUrl: sheet.profileAvatarUrl,
                                    ),
                                    MetaLabel(
                                      icon: Icons.calendar_today_outlined,
                                      label: _formatDate(deck.createdAt),
                                      tooltip:
                                          'Created ${_formatDate(deck.createdAt)}',
                                    ),
                                  ],
                                ),
                              ),
                              _InteractionButton(
                                icon: sheet.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                label: _formatCount(sheet.favoritesCount),
                                selected: sheet.isFavorite,
                                onPressed:
                                    sheet.isBusy ||
                                        sheet.onFavoritePressed == null
                                    ? null
                                    : () {
                                        sheet.onFavoritePressed!();
                                      },
                              ),
                            ],
                          ),
                          SizedBox(height: tokens.spaceLayoutGapMd),
                          _InteractionSummary(sheet: sheet),
                          SizedBox(height: tokens.spaceLayoutGapLg),
                          Center(
                            child: DeckTile(
                              deck: deck,
                              state: DeckTileState.spread,
                              width: 190,
                            ),
                          ),
                          SizedBox(height: tokens.spaceLayoutGapLg),
                          DeckDetails(
                            title: EditableTextValue(
                              value: sheet.title,
                              enabled: false,
                              onSave: (_) async {},
                              textStyle: textStyle.resolve(tokens, const [
                                TextSize.header,
                                TextWeight.heavy,
                              ]),
                            ),
                            metaLabels: Wrap(
                              spacing: tokens.spaceLayoutGapMd,
                              runSpacing: tokens.spaceLayoutGapSm,
                              children: [
                                MetaLabel(
                                  icon: Icons.style_outlined,
                                  label: '${deck.cardCount} cards',
                                ),
                                MetaLabel(
                                  icon: Icons.new_releases_outlined,
                                  label: 'v${deck.version}+${deck.buildNumber}',
                                ),
                                MetaLabel(
                                  icon: Icons.visibility_outlined,
                                  label: _visibilityLabel(deck),
                                ),
                                MetaLabel(
                                  icon: Icons.update_outlined,
                                  label: _formatDate(deck.updatedAt),
                                  tooltip:
                                      'Updated ${_formatDate(deck.updatedAt)}',
                                ),
                              ],
                            ),
                            shortDescription: EditableTextValue(
                              value: sheet.shortDescription,
                              enabled: false,
                              onSave: (_) async {},
                              textStyle: textStyle.resolve(tokens, const [
                                TextSize.label,
                                TextWeight.strong,
                              ]),
                            ),
                            longDescription: EditableTextValue(
                              value: sheet.longDescription,
                              enabled: false,
                              isMarkdown: true,
                              markdownMode: MarkdownTextMode.preview,
                              onSave: (_) async {},
                              textStyle: textStyle.resolve(tokens, const [
                                TextSize.bodyLarge,
                                TextWeight.body,
                              ]),
                            ),
                            tags: deck.tags
                                .map((tag) => tag.name)
                                .toList(growable: false),
                            tagsEnabled: false,
                            tagsPlaceholder: 'No tags yet',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: tokens.spaceLayoutGapLg),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spaceLayoutPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionEyebrow('Featured Cards'),
                        SizedBox(height: tokens.spaceLayoutGapLg),
                        _DiscussionSection(sheet: sheet),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: tokens.spaceLayoutPadding,
          right: tokens.spaceLayoutPadding,
          top: tokens.spaceLayoutPadding,
          child: Row(
            children: [
              Button.icon(
                icon: showCloseButton ? Icons.close : Icons.arrow_back,
                onPressed: onBackPressed,
              ),
              const Spacer(),
              Button.icon(
                icon: sheet.isDownloading
                    ? Icons.sync
                    : Icons.cloud_download_outlined,
                color: ButtonColor.success,
                onPressed:
                    sheet.isDownloading || sheet.onDownloadPressed == null
                    ? null
                    : () {
                        sheet.onDownloadPressed!();
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final height = MediaQuery.sizeOf(context).height * 0.34;

    return SizedBox(
      height: height.clamp(260.0, 380.0),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: tokens.spaceLayoutPadding,
          right: tokens.spaceLayoutPadding,
          top: tokens.spaceLayoutPadding * 3.5,
          bottom: tokens.spaceLayoutPadding,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CarouselView(
              itemExtent: constraints.maxWidth * 0.82,
              shrinkExtent: 64,
              itemSnapping: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.radiusSurface),
              ),
              children: [
                for (final imageUrl in imageUrls)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(tokens.radiusSurface),
                    child: _NetworkImageTile(imageUrl: imageUrl),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NetworkImageTile extends StatelessWidget {
  const _NetworkImageTile({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, _, _) {
        return ColoredBox(
          color: tokens.colorSurfaceBackground,
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 44,
            color: tokens.colorTextMuted,
          ),
        );
      },
    );
  }
}

class _InteractionSummary extends StatelessWidget {
  const _InteractionSummary({required this.sheet});

  final ViewDeckOnlineSheetState sheet;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Wrap(
      spacing: tokens.spaceLayoutGapSm,
      runSpacing: tokens.spaceLayoutGapSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _InteractionButton(
          icon: sheet.voteValue == 1
              ? Icons.arrow_circle_up
              : Icons.arrow_circle_up_outlined,
          label: _formatCount(sheet.upvotesCount),
          selected: sheet.voteValue == 1,
          onPressed: sheet.isBusy || sheet.onUpvotePressed == null
              ? null
              : () {
                  sheet.onUpvotePressed!();
                },
        ),
        _InteractionButton(
          icon: sheet.voteValue == -1
              ? Icons.arrow_circle_down
              : Icons.arrow_circle_down_outlined,
          label: _formatCount(sheet.downvotesCount),
          selected: sheet.voteValue == -1,
          onPressed: sheet.isBusy || sheet.onDownvotePressed == null
              ? null
              : () {
                  sheet.onDownvotePressed!();
                },
        ),
        MetaLabel(
          icon: Icons.cloud_download_outlined,
          label: _formatCount(sheet.downloadsCount),
        ),
        MetaLabel(
          icon: Icons.call_split_outlined,
          label: _formatCount(sheet.forksCount),
        ),
        MetaLabel(
          icon: Icons.rate_review_outlined,
          label: _formatCount(sheet.reviewsCount),
        ),
        MetaLabel(
          icon: Icons.chat_bubble_outline,
          label: _formatCount(sheet.commentsCount),
        ),
      ],
    );
  }
}

class _DiscussionSection extends StatelessWidget {
  const _DiscussionSection({required this.sheet});

  final ViewDeckOnlineSheetState sheet;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow('Reviews'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        _ReviewComposer(
          isSubmitting: sheet.isSubmittingReview,
          onSubmitted: sheet.onReviewSubmitted,
        ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        if (sheet.isLoadingDiscussion)
          const Center(child: CircularProgressIndicator())
        else if (sheet.reviewItems.isEmpty)
          _EmptyDiscussionText(label: 'No reviews yet.')
        else
          for (final review in sheet.reviewItems)
            DeckCommentWidget(
              item: review,
              repliesFor: sheet.reviewRepliesFor,
              onReply: sheet.onReviewReply,
              onEdit: sheet.onReviewEdit,
              canEdit: sheet.canEditReviewItem,
              isSubmitting:
                  sheet.isSubmittingReview || sheet.isSubmittingReviewComment,
            ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        SectionEyebrow('Comments'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        _CommentComposer(
          isSubmitting: sheet.isSubmittingComment,
          onSubmitted: sheet.onCommentSubmitted,
        ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        if (sheet.isLoadingDiscussion)
          const SizedBox.shrink()
        else if (sheet.commentItems.isEmpty)
          _EmptyDiscussionText(label: 'No comments yet.')
        else
          for (final comment in sheet.commentItems)
            DeckCommentWidget(
              item: comment,
              repliesFor: sheet.commentRepliesFor,
              onReply: sheet.onCommentSubmitted,
              onEdit: sheet.onCommentEdit,
              canEdit: sheet.canEditCommentItem,
              isSubmitting: sheet.isSubmittingComment,
            ),
      ],
    );
  }
}

class _ReviewComposer extends HookWidget {
  const _ReviewComposer({
    required this.isSubmitting,
    required this.onSubmitted,
  });

  final bool isSubmitting;
  final Future<bool> Function({
    required int voteValue,
    required String title,
    required String body,
  })
  onSubmitted;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final bodyController = useTextEditingController();
    final voteValue = useState(1);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DiscussionInput(
                controller: titleController,
                hintText: 'Review title',
                minLines: 1,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.thumb_up_alt_outlined),
                ),
                ButtonSegment(
                  value: -1,
                  icon: Icon(Icons.thumb_down_alt_outlined),
                ),
              ],
              selected: {voteValue.value},
              onSelectionChanged: isSubmitting
                  ? null
                  : (values) {
                      voteValue.value = values.first;
                    },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _DiscussionInput(
          controller: bodyController,
          hintText: 'Input',
          minLines: 4,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSubmitting
                ? null
                : () async {
                    final posted = await onSubmitted(
                      voteValue: voteValue.value,
                      title: titleController.text,
                      body: bodyController.text,
                    );
                    if (!posted) return;

                    titleController.clear();
                    bodyController.clear();
                  },
            child: isSubmitting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post Review'),
          ),
        ),
      ],
    );
  }
}

class _CommentComposer extends HookWidget {
  const _CommentComposer({
    required this.isSubmitting,
    required this.onSubmitted,
  });

  final bool isSubmitting;
  final Future<bool> Function(String body, {String? parentCommentId})
  onSubmitted;

  @override
  Widget build(BuildContext context) {
    final bodyController = useTextEditingController();

    return Column(
      children: [
        _DiscussionInput(
          controller: bodyController,
          hintText: 'Input',
          minLines: 4,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSubmitting
                ? null
                : () async {
                    final posted = await onSubmitted(bodyController.text);
                    if (posted) bodyController.clear();
                  },
            child: isSubmitting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post Comment'),
          ),
        ),
      ],
    );
  }
}

class _DiscussionInput extends StatelessWidget {
  const _DiscussionInput({
    required this.controller,
    required this.hintText,
    required this.minLines,
    this.maxLines = 6,
  });

  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  const _InteractionButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: selected
          ? tokens.colorPrimary.withValues(alpha: 0.14)
          : null,
      side: BorderSide(
        color: selected ? tokens.colorPrimary : tokens.colorBorderNeutralSubtle,
      ),
    );
  }
}

class _EmptyDiscussionText extends StatelessWidget {
  const _EmptyDiscussionText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Text(
      label,
      style: textStyle.resolve(tokens, const [TextSize.label]),
    );
  }
}

String _visibilityLabel(Deck deck) {
  return switch (deck.visibilityState.name) {
    'public' => 'Public',
    'unlisted' => 'Unlisted',
    _ => 'Private',
  };
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = (local.year % 100).toString().padLeft(2, '0');

  return '$day-$month-$year';
}

String _formatCount(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}m';
  }

  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  }

  return value.toString();
}
