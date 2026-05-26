// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/create_deck.local.page.dart
// PURPOSE: Create or edit a deck with title, descriptions, visibility, cover, and publish state.
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        VisibilityState,
        AuthController,
        ViewDecksLocalController,
        AppTextFieldTone,
        SectionEyebrow,
        LocalDB,
        Deck,
        surfaceStyle,
        SurfacePadding,
        TactileButton,
        PanelHeader,
        TactileTone,
        appTextFieldStyle,
        AppTextFieldSize,
        AppTextFieldFrame,
        SectionEyebrowTone,
        SegmentOption,
        SegmentedControl,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        SurfaceTone;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

Future<void> showCreateDeckLocalSheet(BuildContext context, {String? deckId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => CreateDeckSheet(deckId: deckId),
  );
}

class CreateDeckPage extends StatelessWidget {
  const CreateDeckPage({super.key, this.deckId});

  final String? deckId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Scaffold(
      backgroundColor: tokens.backgroundPage,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: CreateDeckSheet(deckId: deckId, showCloseButton: false),
          ),
        ),
      ),
    );
  }
}

class CreateDeckSheet extends HookWidget {
  const CreateDeckSheet({super.key, this.deckId, this.showCloseButton = true});

  final String? deckId;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final titleController = useTextEditingController();
    final shortDescController = useTextEditingController();
    final longDescController = useTextEditingController();
    final coverImageController = useTextEditingController();
    final versionController = useTextEditingController(text: '1.0.0');
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final isPublished = useState(true);
    final wasPublishedInitially = useState(true);
    final visibilityState = useState(VisibilityState.private);

    final auth = context.read<AuthController>();
    final isEdit = deckId != null;
    final deckDB = LocalDB.deck;

    useEffect(() {
      if (!isEdit) return null;

      final existing = deckDB.selectByPk({'id': deckId});
      if (existing == null) return null;

      titleController.text = existing.title;
      shortDescController.text = existing.shortDescription;
      longDescController.text = existing.longDescription;
      coverImageController.text = existing.coverImageUrl ?? '';
      versionController.text = existing.version;
      isPublished.value = existing.isPublished;
      wasPublishedInitially.value = existing.isPublished;
      visibilityState.value = existing.visibilityState;
      return null;
    }, [deckId]);

    Future<void> handleSave() async {
      if (!formKey.currentState!.validate()) return;

      final userId = auth.currentProfile.id;
      final coverImageUrl = _nonEmptyOrNull(coverImageController.text);
      final version = _nonEmptyOrNull(versionController.text) ?? '1.0.0';
      String? finalDeckId;

      if (isEdit) {
        final existing = deckDB.selectByPk({'id': deckId});

        if (existing != null) {
          final updated = existing.copyWith(
            title: titleController.text.trim(),
            shortDescription: shortDescController.text.trim(),
            longDescription: longDescController.text.trim(),
            coverImageUrl: coverImageUrl,
            version: version,
            visibilityState: visibilityState.value,
            isPublished: isPublished.value,
            updatedAt: DateTime.now(),
          );
          await deckDB.upsert(updated);
          finalDeckId = existing.id;
        }
      } else {
        final newDeck = Deck.createNow(
          userId: userId,
          title: titleController.text.trim(),
          shortDescription: shortDescController.text.trim(),
          longDescription: longDescController.text.trim(),
          coverImageUrl: coverImageUrl,
          visibilityState: visibilityState.value,
          isPremade: false,
          isPublished: isPublished.value,
          version: version,
        );

        await deckDB.upsert(newDeck);
        finalDeckId = newDeck.id;
      }

      if (!context.mounted) return;

      final beingPublished =
          isPublished.value && (!isEdit || !wasPublishedInitially.value);
      if (beingPublished && finalDeckId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your deck will be published after your next sync.'),
          ),
        );
      }

      context.read<ViewDecksLocalController>().load();
      context.pop();
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: showCloseButton ? 0.9 : 1,
      minChildSize: showCloseButton ? 0.5 : 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Surface(
          style: surfaceStyle.resolve(tokens, const [SurfacePadding.none]),
          child: Form(
            key: formKey,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                PanelHeader(
                  title: isEdit ? 'Edit Deck' : 'Create Deck',
                  trailing: showCloseButton
                      ? TactileButton.icon(
                          icon: Icons.close,
                          onPressed: () => context.pop(),
                        )
                      : null,
                ),
                Padding(
                  padding: EdgeInsets.all(tokens.spacePanelPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TextFieldPanel(
                        title: 'Title',
                        placeholder: 'Deck title',
                        controller: titleController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Title is required'
                            : null,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _TextFieldPanel(
                        title: 'Short Description',
                        placeholder: 'A one-line summary for this deck',
                        controller: shortDescController,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _TextFieldPanel(
                        title: 'Long Description',
                        placeholder:
                            'Add notes, goals, source context, or usage instructions',
                        controller: longDescController,
                        maxLines: 6,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _TextFieldPanel(
                        title: 'Cover Image URL',
                        placeholder: 'https://...',
                        controller: coverImageController,
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _TextFieldPanel(
                        title: 'Version',
                        placeholder: '1.0.0',
                        controller: versionController,
                        tone: AppTextFieldTone.brand,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _VisibilityPanel(
                        value: visibilityState.value,
                        onChanged: (value) => visibilityState.value = value,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      _PublishPanel(
                        value: isPublished.value,
                        onChanged: (value) => isPublished.value = value,
                      ),
                      SizedBox(height: tokens.spacePanelGapLg),
                      TactileButton(
                        tone: TactileTone.filled,
                        leading: Icon(isEdit ? Icons.save : Icons.add),
                        onPressed: handleSave,
                        child: Text(isEdit ? 'Save Deck' : 'Create Deck'),
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
}

class _TextFieldPanel extends StatelessWidget {
  const _TextFieldPanel({
    required this.title,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.tone = AppTextFieldTone.neutral,
  });

  final String title;
  final String placeholder;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final AppTextFieldTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final fieldStyle = appTextFieldStyle.resolve(tokens, [
      AppTextFieldSize.normal,
      AppTextFieldFrame.outline,
      tone,
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow(title, tone: SectionEyebrowTone.primary),
        SizedBox(height: tokens.spacePanelGapMd),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: fieldStyle.textStyle,
          cursorColor: fieldStyle.cursorColor,
          decoration: InputDecoration(
            hintText: placeholder,
          ).applyDefaults(fieldStyle.decorationTheme),
        ),
      ],
    );
  }
}

class _VisibilityPanel extends StatelessWidget {
  const _VisibilityPanel({required this.value, required this.onChanged});

  final VisibilityState value;
  final ValueChanged<VisibilityState> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionEyebrow('Visibility', tone: SectionEyebrowTone.primary),
        SizedBox(height: tokens.spacePanelGapMd.h),
        SegmentedControl<VisibilityState>(
          value: value,
          onChanged: onChanged,
          options: const [
            SegmentOption(value: VisibilityState.private, label: 'Private'),
            SegmentOption(value: VisibilityState.unlisted, label: 'Unlisted'),
            SegmentOption(value: VisibilityState.public, label: 'Public'),
          ],
        ),
        SizedBox(height: tokens.spacePanelGapMd.h),
        Text(
          _visibilityHint(value),
          style: appTextStyle.resolve(tokens, const [
            TextSize.label,
            TextWeight.body,
            TextTone.secondary,
          ]),
        ),
      ],
    );
  }
}

class _PublishPanel extends StatelessWidget {
  const _PublishPanel({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.muted]),
      child: SwitchListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacePanelGapMd,
          vertical: tokens.spacePanelGapSm,
        ),
        value: value,
        onChanged: onChanged,
        secondary: Icon(value ? Icons.public : Icons.lock_outline),
        title: Text(
          'Publish to browser',
          style: appTextStyle.resolve(tokens, const [
            TextSize.labelLarge,
            TextWeight.heavy,
            TextTone.primary,
          ]),
        ),
        subtitle: Text(
          value
              ? 'This deck can be published on the next sync.'
              : 'This deck stays local/private until published.',
          style: appTextStyle.resolve(tokens, const [
            TextSize.label,
            TextWeight.body,
            TextTone.secondary,
          ]),
        ),
      ),
    );
  }
}

String? _nonEmptyOrNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String _visibilityHint(VisibilityState value) {
  return switch (value) {
    VisibilityState.private => 'Only you can see this deck.',
    VisibilityState.unlisted =>
      'Anyone with the link can access it after sync.',
    VisibilityState.public =>
      'Discoverable in the public deck browser after sync.',
  };
}
