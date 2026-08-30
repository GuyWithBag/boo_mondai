// It is kept separate from MarkdownImageElementBuilder because it needs to support regular flutter_markdown_plus image and the configurable image
import 'package:boo_mondai/features/markdown.audio_player/markdown.audio_player.barrel.dart';
import 'package:boo_mondai/features/markdown.image/markdown.image.dart';
import 'package:boo_mondai/lib.barrel.dart' show MediaHelper;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MarkdownMedia extends HookWidget {
  const MarkdownMedia({
    super.key,
    required this.uri,
    this.title,
    this.alt,
    this.options,
  });

  final Uri uri;
  final String? title;
  final String? alt;
  final String? options;

  @override
  Widget build(BuildContext context) {
    final source = uri.toString();
    if (MediaHelper.isAudio(source)) {
      MarkdownAudioPlayer(uri: uri, alt: alt, title: title, options: options);
    } else if (MediaHelper.isImage(source)) {
      MarkdownImage(uri: uri, alt: alt, title: title, options: options);
    }
    return SizedBox.shrink();
  }
}
