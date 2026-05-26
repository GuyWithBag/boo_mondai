import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        AppTokens,
        ViewDecksOnlineController,
        DeckDiscussionController,
        DeckComment,
        DeckVoteReview,
        HeaderBadge,
        LoadingIndicator,
        Tag,
        MetaLabel,
        surfaceStyle,
        SurfacePadding,
        DeckTile,
        SnackbarTone,
        showSnackbar,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        AuthorAvatarRow,
        ButtonTone,
        Button,
        SurfaceTone,
        SectionEyebrowTone,
        SectionEyebrow;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

Future<void> showViewDeckOnlineSheet(BuildContext context, Deck deck) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider(
      create: (_) => DeckDiscussionController(deck: deck)..load(),
      child: ViewDeckOnlineSheet(deck: deck),
    ),
  );
}

class ViewDeckOnlineSheet extends StatelessWidget {
  const ViewDeckOnlineSheet({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.48,
      maxChildSize: 0.96,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: tokens.backgroundPage,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radius3xl.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(tokens.spacePanelPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 960;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _StoreHeader(deck: deck, isDesktop: isDesktop),
                        SizedBox(height: tokens.spacePanelGapLg),
                        _StoreBody(deck: deck, isDesktop: isDesktop),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.deck, required this.isDesktop});

  final Deck deck;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 6, child: _FeaturedCarousel(deck: deck)),
            SizedBox(width: tokens.spacePanelGapLg),
            Expanded(flex: 4, child: _StoreSummary(deck: deck)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FeaturedCarousel(deck: deck),
        SizedBox(height: tokens.spacePanelGapLg),
        _StoreSummary(deck: deck),
      ],
    );
  }
}

class _FeaturedCarousel extends StatelessWidget {
  const _FeaturedCarousel({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final images = _featuredImages(deck);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [SurfacePadding.none]),
        child: ClipRect(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CarouselView(
                itemExtent: constraints.maxWidth,
                itemSnapping: true,
                padding: EdgeInsets.zero,
                children: images.isEmpty
                    ? [_FeaturedFallback(deck: deck)]
                    : [
                        for (final image in images)
                          Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, _) =>
                                _FeaturedFallback(deck: deck),
                          ),
                      ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeaturedFallback extends StatelessWidget {
  const _FeaturedFallback({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ColoredBox(
      color: tokens.softGray,
      child: Center(
        child: DeckTile(deck: deck, width: 150.w),
      ),
    );
  }
}

class _StoreSummary extends StatelessWidget {
  const _StoreSummary({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final listing = deck.listing;
    final title = deck.title.trim().isEmpty ? 'Untitled deck' : deck.title;
    final shortDescription = deck.shortDescription.trim().isEmpty
        ? 'No description yet'
        : deck.shortDescription;
    final authorName = deck.userProfile?.username ?? 'Unknown creator';
    final controller = context.watch<ViewDecksOnlineController>();
    final isDownloading = controller.isDownloadingDeck(deck.id);

    Future<void> downloadDeck() async {
      final downloadedDeck = await controller.downloadDeck(deck);
      if (!context.mounted) return;

      if (downloadedDeck == null) {
        final message =
            controller.error?.toString().replaceFirst('Exception: ', '') ??
            'Deck download failed.';
        showSnackbar(
          context: context,
          message: message,
          leading: const Icon(Icons.error_outline),
          tone: SnackbarTone.error,
        );
        return;
      }

      showSnackbar(
        context: context,
        message: '"${downloadedDeck.title}" downloaded to My Decks.',
        leading: const Icon(Icons.download_done_outlined),
        tone: SnackbarTone.success,
      );
    }

    return Surface(
      style: surfaceStyle.resolve(tokens),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacePanelGapLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: tokens.spacePanelGapSm,
              runSpacing: tokens.spacePanelGapSm,
              children: [
                const HeaderBadge(label: 'Public'),
                if (deck.isPremade) const HeaderBadge(label: 'Premade'),
                HeaderBadge(label: '${deck.cardCount} cards'),
              ],
            ),
            SizedBox(height: tokens.spacePanelGapMd),
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: appTextStyle.resolve(tokens, const [
                TextSize.bodyLarge,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spacePanelGapSm),
            Text(
              shortDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: appTextStyle.resolve(tokens, const [
                TextSize.label,
                TextWeight.body,
                TextTone.secondary,
              ]),
            ),
            SizedBox(height: tokens.spacePanelGapLg),
            AuthorAvatarRow(
              authorName: authorName,
              authorAvatarUrl: deck.userProfile?.avatarUrl,
            ),
            SizedBox(height: tokens.spacePanelGapLg),
            Wrap(
              spacing: tokens.spacePanelGapSm,
              runSpacing: tokens.spacePanelGapSm,
              children: [
                MetaLabel(
                  icon: Icons.download_outlined,
                  label: _formatCount(listing?.downloadsCount ?? 0),
                  tooltip: 'Downloads',
                ),
                MetaLabel(
                  icon: Icons.favorite_border,
                  label: _formatCount(listing?.favoritesCount ?? 0),
                  tooltip: 'Favorites',
                ),
                MetaLabel(
                  icon: Icons.arrow_circle_up_outlined,
                  label: _formatCount(listing?.upvotesCount ?? 0),
                  tooltip: 'Upvotes',
                ),
                MetaLabel(
                  icon: Icons.call_split_outlined,
                  label: _formatCount(listing?.forksCount ?? 0),
                  tooltip: 'Forks',
                ),
                MetaLabel(
                  icon: Icons.rate_review_outlined,
                  label: _formatCount(listing?.reviewsCount ?? 0),
                  tooltip: 'Reviews',
                ),
              ],
            ),
            SizedBox(height: tokens.spacePanelGapLg),
            SizedBox(
              width: double.infinity,
              child: Button(
                tone: ButtonTone.filled,
                leading: isDownloading
                    ? const LoadingIndicator()
                    : const Icon(Icons.download_rounded),
                onPressed: isDownloading ? null : downloadDeck,
                child: Text(isDownloading ? 'Downloading' : 'Download Deck'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreBody extends StatelessWidget {
  const _StoreBody({required this.deck, required this.isDesktop});

  final Deck deck;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final listing = deck.listing;

    final panels = [
      _DescriptionPanel(deck: deck),
      _TagsPanel(tags: deck.tags),
      _FeaturedCardsPanel(cards: listing?.featuredCards ?? const []),
      _DetailsPanel(deck: deck),
      const _ReviewsPanel(),
      const _CommentsPanel(),
    ];

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final panel in panels) ...[
            panel,
            SizedBox(height: tokens.spacePanelGapLg),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DescriptionPanel(deck: deck),
              SizedBox(height: tokens.spacePanelGapLg),
              _FeaturedCardsPanel(cards: listing?.featuredCards ?? const []),
              SizedBox(height: tokens.spacePanelGapLg),
              const _ReviewsPanel(),
              SizedBox(height: tokens.spacePanelGapLg),
              const _CommentsPanel(),
            ],
          ),
        ),
        SizedBox(width: tokens.spacePanelGapLg),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TagsPanel(tags: deck.tags),
              SizedBox(height: tokens.spacePanelGapLg),
              _DetailsPanel(deck: deck),
            ],
          ),
        ),
      ],
    );
  }
}

class _DescriptionPanel extends StatelessWidget {
  const _DescriptionPanel({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final shortDescription = deck.shortDescription.trim();
    final longDescription = deck.longDescription.trim();

    return _Panel(
      title: 'About This Deck',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shortDescription.isNotEmpty)
            Text(
              shortDescription,
              style: appTextStyle.resolve(tokens, const [
                TextSize.labelLarge,
                TextWeight.strong,
                TextTone.primary,
              ]),
            ),
          if (shortDescription.isNotEmpty && longDescription.isNotEmpty)
            SizedBox(height: tokens.spacePanelGapMd),
          Text(
            longDescription.isEmpty
                ? 'No detailed description yet.'
                : longDescription,
            style: appTextStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.body,
              TextTone.secondary,
            ]),
          ),
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
    final tokens = context.themeTokens<AppTokens>();

    return _Panel(
      title: 'Tags',
      child: tags.isEmpty
          ? const MetaLabel(icon: Icons.tag_outlined, label: 'No tags')
          : Wrap(
              spacing: tokens.spacePanelGapSm,
              runSpacing: tokens.spacePanelGapSm,
              children: [for (final tag in tags) HeaderBadge(label: tag.name)],
            ),
    );
  }
}

class _FeaturedCardsPanel extends StatelessWidget {
  const _FeaturedCardsPanel({required this.cards});

  final List<Map<String, dynamic>> cards;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _Panel(
      title: 'Featured Cards',
      child: cards.isEmpty
          ? const MetaLabel(
              icon: Icons.style_outlined,
              label: 'No featured cards',
            )
          : Wrap(
              spacing: tokens.spacePanelGapMd,
              runSpacing: tokens.spacePanelGapMd,
              children: [
                for (final card in cards.take(4))
                  _FeaturedCardPreview(card: card),
              ],
            ),
    );
  }
}

class _FeaturedCardPreview extends StatelessWidget {
  const _FeaturedCardPreview({required this.card});

  final Map<String, dynamic> card;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final title = _snippetValue(card, const [
      'front',
      'term',
      'question',
      'prompt',
      'title',
    ]);
    final body = _snippetValue(card, const [
      'back',
      'definition',
      'answer',
      'content',
      'translation',
    ]);

    return SizedBox(
      width: 240.w,
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [SurfaceTone.muted]),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacePanelGapMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Featured card',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: appTextStyle.resolve(tokens, const [
                  TextSize.label,
                  TextWeight.heavy,
                ]),
              ),
              if (body != null) ...[
                SizedBox(height: tokens.spacePanelGapSm),
                Text(
                  body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle.resolve(tokens, const [
                    TextSize.label,
                    TextWeight.body,
                    TextTone.secondary,
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _Panel(
      title: 'Details',
      child: Wrap(
        spacing: tokens.spacePanelGapMd,
        runSpacing: tokens.spacePanelGapMd,
        children: [
          MetaLabel(
            icon: Icons.style_outlined,
            label: '${deck.cardCount} cards',
            tooltip: 'Cards in this deck',
          ),
          MetaLabel(
            icon: Icons.new_releases_outlined,
            label: 'v${deck.version}+${deck.buildNumber}',
            tooltip: 'Deck version and build number',
          ),
          MetaLabel(
            icon: Icons.calendar_today_outlined,
            label: _formatDate(deck.createdAt),
            tooltip: 'Published ${_formatDate(deck.createdAt)}',
          ),
          MetaLabel(
            icon: Icons.update_outlined,
            label: _formatDate(deck.updatedAt),
            tooltip: 'Updated ${_formatDate(deck.updatedAt)}',
          ),
        ],
      ),
    );
  }
}

class _ReviewsPanel extends StatelessWidget {
  const _ReviewsPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckDiscussionController>();
    final tokens = context.themeTokens<AppTokens>();

    return _Panel(
      title: 'Reviews',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DiscussionErrorBanner(),
          const _ReviewComposer(),
          SizedBox(height: tokens.spacePanelGapMd),
          if (controller.isLoading)
            const LoadingIndicator()
          else if (controller.reviews.isEmpty)
            const MetaLabel(
              icon: Icons.rate_review_outlined,
              label: 'No reviews yet',
            )
          else
            Column(
              children: [
                for (final review in controller.reviews) ...[
                  _ReviewTile(review: review),
                  SizedBox(height: tokens.spacePanelGapMd),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _CommentsPanel extends StatelessWidget {
  const _CommentsPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckDiscussionController>();
    final tokens = context.themeTokens<AppTokens>();
    final rootComments = controller.comments
        .where((comment) => comment.parentCommentId == null)
        .toList(growable: false);

    return _Panel(
      title: 'Comments',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DiscussionErrorBanner(),
          const _CommentComposer(),
          SizedBox(height: tokens.spacePanelGapMd),
          if (controller.isLoading)
            const LoadingIndicator()
          else if (rootComments.isEmpty)
            const MetaLabel(
              icon: Icons.chat_bubble_outline,
              label: 'No comments yet',
            )
          else
            Column(
              children: [
                for (final comment in rootComments) ...[
                  _CommentThread(comment: comment),
                  SizedBox(height: tokens.spacePanelGapMd),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _ReviewComposer extends StatefulWidget {
  const _ReviewComposer();

  @override
  State<_ReviewComposer> createState() => _ReviewComposerState();
}

class _ReviewComposerState extends State<_ReviewComposer> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  int _voteValue = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckDiscussionController>();
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: tokens.spacePanelGapSm,
          runSpacing: tokens.spacePanelGapSm,
          children: [
            Button(
              tone: ButtonTone.ghost,
              selected: _voteValue == 1,
              leading: const Icon(Icons.arrow_circle_up_outlined),
              onPressed: () => setState(() => _voteValue = 1),
              child: const Text('Upvote'),
            ),
            Button(
              tone: ButtonTone.ghost,
              selected: _voteValue == -1,
              leading: const Icon(Icons.arrow_circle_down_outlined),
              onPressed: () => setState(() => _voteValue = -1),
              child: const Text('Downvote'),
            ),
          ],
        ),
        SizedBox(height: tokens.spacePanelGapSm),
        _DiscussionTextField(
          controller: _titleController,
          hintText: 'Review title',
          maxLines: 1,
        ),
        SizedBox(height: tokens.spacePanelGapSm),
        _DiscussionTextField(
          controller: _bodyController,
          hintText: 'Write a review',
          maxLines: 4,
        ),
        SizedBox(height: tokens.spacePanelGapSm),
        Button(
          tone: ButtonTone.filled,
          leading: controller.isSubmittingReview
              ? const LoadingIndicator()
              : const Icon(Icons.rate_review_outlined),
          onPressed: controller.isSubmittingReview
              ? null
              : () async {
                  final saved = await controller.addReview(
                    voteValue: _voteValue,
                    title: _titleController.text,
                    body: _bodyController.text,
                  );
                  if (!saved || !mounted) return;
                  _titleController.clear();
                  _bodyController.clear();
                },
          child: Text(
            controller.isSubmittingReview ? 'Posting' : 'Post Review',
          ),
        ),
      ],
    );
  }
}

class _CommentComposer extends StatefulWidget {
  const _CommentComposer({this.parentCommentId});

  final String? parentCommentId;

  @override
  State<_CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<_CommentComposer> {
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckDiscussionController>();
    final isReply = widget.parentCommentId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DiscussionTextField(
          controller: _bodyController,
          hintText: isReply ? 'Write a reply' : 'Write a comment',
          maxLines: isReply ? 2 : 3,
        ),
        SizedBox(height: context.themeTokens<AppTokens>().spacePanelGapSm),
        Button(
          tone: isReply ? ButtonTone.ghost : ButtonTone.filled,
          leading: controller.isSubmittingComment
              ? const LoadingIndicator()
              : Icon(isReply ? Icons.reply_outlined : Icons.chat_outlined),
          onPressed: controller.isSubmittingComment
              ? null
              : () async {
                  final saved = await controller.addComment(
                    _bodyController.text,
                    parentCommentId: widget.parentCommentId,
                  );
                  if (!saved || !mounted) return;
                  _bodyController.clear();
                },
          child: Text(
            controller.isSubmittingComment
                ? 'Posting'
                : isReply
                ? 'Reply'
                : 'Post Comment',
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final DeckVoteReview review;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final authorName = review.userProfile?.username ?? 'Unknown user';
    final voteIcon = review.voteValueAtCreation == 1
        ? Icons.arrow_circle_up_outlined
        : Icons.arrow_circle_down_outlined;
    final voteLabel = review.voteValueAtCreation == 1 ? 'Upvote' : 'Downvote';

    return _DiscussionItem(
      authorName: authorName,
      avatarUrl: review.userProfile?.avatarUrl,
      createdAt: review.createdAt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: tokens.spacePanelGapSm,
            runSpacing: tokens.spacePanelGapSm,
            children: [
              MetaLabel(icon: voteIcon, label: voteLabel),
              if (review.title.trim().isNotEmpty)
                Text(
                  review.title.trim(),
                  style: appTextStyle.resolve(tokens, const [
                    TextSize.labelLarge,
                    TextWeight.heavy,
                  ]),
                ),
            ],
          ),
          SizedBox(height: tokens.spacePanelGapSm),
          Text(
            review.body,
            style: appTextStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.body,
              TextTone.secondary,
            ]),
          ),
        ],
      ),
    );
  }
}

class _CommentThread extends StatefulWidget {
  const _CommentThread({required this.comment, this.depth = 0});

  final DeckComment comment;
  final int depth;

  @override
  State<_CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<_CommentThread> {
  bool _isReplying = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckDiscussionController>();
    final tokens = context.themeTokens<AppTokens>();
    final replies = controller.repliesFor(widget.comment.id);

    return Padding(
      padding: EdgeInsets.only(left: widget.depth == 0 ? 0 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DiscussionItem(
            authorName: widget.comment.userProfile?.username ?? 'Unknown user',
            avatarUrl: widget.comment.userProfile?.avatarUrl,
            createdAt: widget.comment.createdAt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment.body,
                  style: appTextStyle.resolve(tokens, const [
                    TextSize.label,
                    TextWeight.body,
                    TextTone.secondary,
                  ]),
                ),
                SizedBox(height: tokens.spacePanelGapSm),
                Button(
                  tone: ButtonTone.ghost,
                  leading: const Icon(Icons.reply_outlined),
                  onPressed: () => setState(() => _isReplying = !_isReplying),
                  child: Text(_isReplying ? 'Cancel' : 'Reply'),
                ),
              ],
            ),
          ),
          if (_isReplying) ...[
            SizedBox(height: tokens.spacePanelGapSm),
            _CommentComposer(parentCommentId: widget.comment.id),
          ],
          if (replies.isNotEmpty) ...[
            SizedBox(height: tokens.spacePanelGapMd),
            for (final reply in replies) ...[
              _CommentThread(comment: reply, depth: widget.depth + 1),
              SizedBox(height: tokens.spacePanelGapSm),
            ],
          ],
        ],
      ),
    );
  }
}

class _DiscussionItem extends StatelessWidget {
  const _DiscussionItem({
    required this.authorName,
    required this.createdAt,
    required this.child,
    this.avatarUrl,
  });

  final String authorName;
  final String? avatarUrl;
  final DateTime createdAt;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.muted]),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacePanelGapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: avatarUrl == null
                      ? null
                      : NetworkImage(avatarUrl!),
                  child: avatarUrl == null
                      ? Text(authorName.isEmpty ? '?' : authorName[0])
                      : null,
                ),
                SizedBox(width: tokens.spacePanelGapSm),
                Expanded(
                  child: Text(
                    authorName,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle.resolve(tokens, const [
                      TextSize.label,
                      TextWeight.heavy,
                    ]),
                  ),
                ),
                MetaLabel(
                  icon: Icons.calendar_today_outlined,
                  label: _formatDate(createdAt),
                ),
              ],
            ),
            SizedBox(height: tokens.spacePanelGapSm),
            child,
          ],
        ),
      ),
    );
  }
}

class _DiscussionTextField extends StatelessWidget {
  const _DiscussionTextField({
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: appTextStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
      ]),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: tokens.backgroundSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius2xl),
          borderSide: BorderSide(color: tokens.borderNeutralSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius2xl),
          borderSide: BorderSide(color: tokens.borderNeutralSubtle),
        ),
      ),
    );
  }
}

class _DiscussionErrorBanner extends StatelessWidget {
  const _DiscussionErrorBanner();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeckDiscussionController>();
    final error = controller.error;
    if (error == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        bottom: context.themeTokens<AppTokens>().spacePanelGapSm,
      ),
      child: MetaLabel(
        icon: Icons.error_outline,
        label: error.toString().replaceFirst('Exception: ', ''),
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
      style: surfaceStyle.resolve(tokens),
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

List<String> _featuredImages(Deck deck) {
  final values = [
    ...?deck.listing?.featuredImages,
    if (deck.coverImageUrl != null) deck.coverImageUrl!,
  ];

  return values
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet()
      .toList();
}

String? _snippetValue(Map<String, dynamic> card, List<String> keys) {
  for (final key in keys) {
    final value = card[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }

  for (final value in card.values) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }

  return null;
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

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}
