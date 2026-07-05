// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/templates/card_template.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        MutableEntity,
        WordScrambleTemplate,
        Tag,
        CardAttachment,
        FlashcardTemplate,
        IdentificationTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchMadnessTemplate,
        TagMapper,
        CardAttachmentMapper,
        FlashcardTemplateMapper,
        IdentificationTemplateMapper,
        MultipleChoiceTemplateMapper,
        FillInTheBlanksTemplateMapper,
        MatchMadnessTemplateMapper,
        MutableEntityMapper,
        WordScrambleTemplateMapper,
        AttachmentUriHelper,
        MutableEntityCopyWith,
        TagCopyWith,
        CardAttachmentCopyWith;
import 'package:dart_mappable/dart_mappable.dart';

part 'card_template.dto.mapper.dart';

@MappableClass(
  discriminatorKey: 'type',
  includeSubClasses: [
    FlashcardTemplate,
    IdentificationTemplate,
    MultipleChoiceTemplate,
    FillInTheBlanksTemplate,
    MatchMadnessTemplate,
    WordScrambleTemplate,
  ],
)
abstract class CardTemplate with CardTemplateMappable implements MutableEntity {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  final String deckId;
  final int sortOrder;

  // ── Provenance (For Git-lite Forks) ──
  final String? sourceTemplateId;

  // Joined from card_template_tags
  final List<Tag> tags;

  // Joined from card_template_attachments
  final List<CardAttachment> attachments;

  const CardTemplate({
    required this.id,
    required this.deckId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.sourceTemplateId,
    this.tags = const [],
    this.attachments = const [],
  });

  String? resolveAttachmentUrl(Uri uri) {
    if (uri.scheme != 'attachment') return uri.toString();

    final attachmentId = uri.path.isNotEmpty ? uri.path : uri.host;
    for (final attachment in attachments) {
      if (attachment.id == attachmentId) {
        return AttachmentUriHelper.resolveAttachmentUri(attachment);
      }
    }
    return null;
  }

  bool checkAnswer(String userAnswer, {bool isReversed = false});
}
