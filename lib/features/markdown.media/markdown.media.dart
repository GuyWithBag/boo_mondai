// It is kept separate from MarkdownImageElementBuilder because it needs to support regular flutter_markdown_plus image and the configurable image
import 'package:boo_mondai/features/markdown.audio_player/markdown.audio_player.barrel.dart';
import 'package:boo_mondai/features/markdown.image/markdown.image.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show MarkdownAttachmentUrlResolver, MediaHelper;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

class MarkdownMedia extends SignalHookWidget {
  const MarkdownMedia({
    super.key,
    required this.uri,
    this.title,
    this.alt,
    this.options,
    this.resolveAttachmentUrl,
    this.contentScale = 1,
    this.imageConstraints,
    this.audioConstraints,
  });

  final Uri uri;
  final String? title;
  final String? alt;
  final String? options;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final double contentScale;
  final BoxConstraints? imageConstraints;
  final BoxConstraints? audioConstraints;

  @override
  Widget build(BuildContext context) {
    final sourceSignal = useFutureSignal(
      () async => await resolveAttachmentUrl?.call(uri) ?? uri.toString(),
      keys: [uri, resolveAttachmentUrl],
    );
    final source = sourceSignal.value.map(
      data: (value) => value,
      error: () => uri.toString(),
      loading: () => null,
    );
    if (source == null) return const SizedBox.shrink();

    if (MediaHelper.isAudio(source)) {
      return MarkdownAudioPlayer(
        uri: uri,
        alt: alt,
        title: title,
        options: options,
        resolveAttachmentUrl: resolveAttachmentUrl,
        contentScale: contentScale,
        constraints: audioConstraints,
      );
    } else if (MediaHelper.isImage(source)) {
      return MarkdownImage(
        uri: uri,
        alt: alt,
        title: title,
        options: options,
        resolveAttachmentUrl: resolveAttachmentUrl,
        constraints: imageConstraints,
        contentScale: contentScale,
      );
    }
    return const SizedBox.shrink();
  }
}
