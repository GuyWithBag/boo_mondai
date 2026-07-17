import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ImageHelper,
        MediaHelper,
        StoredMediaKind,
        StoredMediaPath,
        StoredMediaService,
        StringHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart'
    show
        TextStyle,
        TextDecoration,
        EdgeInsets,
        FontStyle,
        TextAlign,
        TableBorder,
        BorderSide,
        Border,
        BorderRadius,
        BoxDecoration;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart'
    show MarkdownStyleSheet;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

abstract class MarkdownHelper {
  static String? resolveMediaSourceUri(Uri uri) {
    final source = uri.toString().trim();
    if (source.isEmpty) return null;

    if (uri.scheme == 'local') {
      final id = uri.path.isNotEmpty ? uri.path : uri.host;
      return StoredMediaService.getFileById(id)?.path;
    }

    final normalizedSource = normalizeMediaSource(source);
    if (ImageHelper.isRemoteUrl(normalizedSource)) {
      return StoredMediaService.getFileByRemoteUrl(normalizedSource)?.path ??
          normalizedSource;
    }

    return normalizedSource;
  }

  static String normalizeMediaSource(String source) {
    if (ImageHelper.isRemoteUrl(source)) return source;

    final trimmed = source.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.scheme.isNotEmpty) return trimmed;

    final maybeDomain = StringHelper.toTrimmedOrNull(trimmed);
    if (maybeDomain != null && maybeDomain.contains('.')) {
      return 'https://$maybeDomain';
    }

    return trimmed;
  }

  static Future<String?> toPickedFileMediaMarkdownFormat({
    required StoredMediaPath path,
    required PlatformFile file,
    String? remoteUrl,
  }) async {
    final storedMedia = await StoredMediaService.storeFile(
      path: path,
      file: file,
      remoteUrl: remoteUrl,
    );
    if (storedMedia == null) return null;

    final source = 'local:${storedMedia.id}';
    final mimeType = MediaHelper.mimeTypeFromExtension(file.extension);
    final mediaKind = MediaHelper.kindFromMimeType(mimeType);
    return switch (mediaKind) {
      StoredMediaKind.image || StoredMediaKind.audio => toMediaAttachmentFormat(
        label: file.name,
        source: source,
      ),
      _ => toLinkFormat(label: file.name, source: source),
    };
  }

  static String toMediaAttachmentFormat({
    required String label,
    required String source,
  }) {
    final safeLabel = label.replaceAll(RegExp(r'[\]\r\n]'), ' ');
    return '![$safeLabel]($source)';
  }

  static String toLinkFormat({required String label, required String source}) {
    final safeLabel = label.replaceAll(RegExp(r'[\]\r\n]'), ' ');
    return '[$safeLabel]($source)';
  }

  static MarkdownStyleSheet getMarkdownStyleSheet(
    AppTokens tokens,
    TextStyle body,
  ) {
    final bodyFontSize = body.fontSize;
    final strong = body.copyWith(fontWeight: tokens.fontWeightTextStrong);
    final heading = body.copyWith(fontWeight: tokens.fontWeightTextHeavy);
    final code = body.copyWith(
      backgroundColor: tokens.colorMuted,
      color: tokens.colorTextBaseline,
      fontFamily: 'monospace',
      fontSize: tokens.textSizeLabelSmall.sp,
      height: tokens.lineHeightTextBody,
    );

    return MarkdownStyleSheet(
      a: body.copyWith(
        color: tokens.colorPrimary,
        decoration: TextDecoration.underline,
        decorationColor: tokens.colorPrimary,
      ),
      p: body,
      pPadding: EdgeInsets.zero,
      code: code,
      h1: heading.copyWith(
        fontSize: bodyFontSize == null ? null : bodyFontSize * 1.35,
      ),
      h1Padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
      h2: heading.copyWith(
        fontSize: bodyFontSize == null ? null : bodyFontSize * 1.2,
      ),
      h2Padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
      h3: heading.copyWith(
        fontSize: bodyFontSize == null ? null : bodyFontSize * 1.1,
      ),
      h3Padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
      h4: strong,
      h4Padding: EdgeInsets.zero,
      h5: strong,
      h5Padding: EdgeInsets.zero,
      h6: body.copyWith(
        color: tokens.colorTextMuted,
        fontSize: bodyFontSize == null ? null : bodyFontSize * 0.9,
        fontWeight: tokens.fontWeightTextStrong,
      ),
      h6Padding: EdgeInsets.zero,
      em: body.copyWith(fontStyle: FontStyle.italic),
      strong: strong,
      del: body.copyWith(decoration: TextDecoration.lineThrough),
      blockquote: body.copyWith(color: tokens.colorTextMuted),
      img: body,
      checkbox: body.copyWith(color: tokens.colorPrimary),
      blockSpacing: tokens.spaceLayoutGapMd,
      listIndent: tokens.spaceLayoutGapMd,
      listBullet: body,
      listBulletPadding: EdgeInsets.only(right: tokens.spaceLayoutGapSm),
      tableHead: strong,
      tableBody: body,
      tableHeadAlign: TextAlign.left,
      tablePadding: EdgeInsets.only(bottom: tokens.spaceLayoutGapSm),
      tableBorder: TableBorder.all(
        color: tokens.colorBorderNeutralSubtle,
        width: tokens.borderWidthDefault,
      ),
      tableCellsPadding: EdgeInsets.symmetric(
        horizontal: tokens.spaceLayoutGapMd,
        vertical: tokens.spaceLayoutGapSm,
      ),
      blockquotePadding: EdgeInsets.symmetric(
        horizontal: tokens.spaceLayoutGapMd,
        vertical: tokens.spaceLayoutGapSm,
      ),
      blockquoteDecoration: BoxDecoration(
        color: tokens.colorPrimarySoft,
        border: Border(
          left: BorderSide(
            color: tokens.colorPrimary,
            width: tokens.borderWidthDefault * 3,
          ),
        ),
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
      ),
      codeblockPadding: EdgeInsets.all(tokens.spaceLayoutGapMd),
      codeblockDecoration: BoxDecoration(
        color: tokens.colorMuted,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
        border: Border.all(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
      ),
    );
  }
}
