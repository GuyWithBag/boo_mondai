import 'package:boo_mondai/features/markdown_audio_player/markdown_audio_player.dart';
import 'package:boo_mondai/features/stored_media/models/stored_media.dto.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ImageHelper,
        MarkdownHelper,
        MediaHelper,
        StoredMediaKind,
        StoredMediaService;
import 'package:boo_mondai/core/widgets/markdown_attachment_url_resolver.dart';
import 'package:boo_mondai/core/widgets/markdown_image_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

abstract class MarkdownMediaBuilder {
  static MarkdownImageBuilder build(
    AppTokens tokens,
    MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
    double contentScale,
  ) {
    return (Uri uri, String? title, String? alt) {
      final audioSource = resolveAudioSource(uri, resolveAttachmentUrl);
      if (audioSource != null) {
        return MarkdownAudioPlayer(
          source: audioSource,
          label: alt ?? 'Audio',
          contentScale: contentScale,
        );
      }

      final src = resolveAttachmentHref(uri, resolveAttachmentUrl);
      if (src == null) return const SizedBox.shrink();

      final image = ImageHelper.getImageProviderFromSource(src);
      if (image == null) return const SizedBox.shrink();
      final options = MarkdownImageOptions.parse(title);
      final child = ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
        child: Image(
          image: image,
          width: options.pixelWidth,
          height: options.pixelHeight,
          fit: options.fit,
          semanticLabel: alt,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      );

      return Align(
        alignment: options.alignment,
        child: FractionallySizedBox(
          widthFactor: options.widthFactor,
          heightFactor: options.heightFactor,
          child: child,
        ),
      );
    };
  }

  static String? resolveAudioSource(
    Uri uri,
    MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
  ) {
    final storedMedia = _storedMediaFromUri(uri);
    if (storedMedia != null &&
        MediaHelper.isAudioMimeType(storedMedia.mimeType)) {
      return resolveAttachmentHref(uri, resolveAttachmentUrl);
    }

    final resolvedHref = resolveAttachmentHref(uri, resolveAttachmentUrl);
    if (resolvedHref == null) return null;

    final kind = MediaHelper.kindFromSource(resolvedHref);
    return kind == StoredMediaKind.audio ? resolvedHref : null;
  }

  static String? resolveAttachmentHref(
    Uri uri,
    MarkdownAttachmentUrlResolver? resolveAttachmentUrl,
  ) {
    return resolveAttachmentUrl?.call(uri) ??
        MarkdownHelper.resolveMediaSourceUri(uri);
  }

  static StoredMedia? _storedMediaFromUri(Uri uri) {
    if (uri.scheme == 'local') {
      final id = uri.path.isNotEmpty ? uri.path : uri.host;
      return StoredMediaService.getById(id);
    }

    final normalizedSource = MarkdownHelper.normalizeMediaSource(
      uri.toString(),
    );
    return StoredMediaService.getByRemoteUrl(normalizedSource);
  }
}
