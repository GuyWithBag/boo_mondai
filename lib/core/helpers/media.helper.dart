import 'dart:typed_data';

import 'package:boo_mondai/core/helpers/file.helper.dart';
import 'package:http/http.dart' as http;

enum StoredMediaKind { image, audio, video, unknown }

abstract final class MediaHelper {
  static const imageExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'bmp',
  ];

  static const audioExtensions = <String>[
    'mp3',
    'm4a',
    'aac',
    'wav',
    'ogg',
    'opus',
  ];

  static const videoExtensions = <String>['mp4', 'm4v', 'mov', 'webm'];

  static const supportedExtensions = <String>[
    ...imageExtensions,
    ...audioExtensions,
    ...videoExtensions,
  ];

  static String extensionFromMimeType(String? mimeType) {
    return switch (_normalizedMimeType(mimeType)) {
      'image/jpeg' => 'jpg',
      'image/png' => 'png',
      'image/webp' => 'webp',
      'image/gif' => 'gif',
      'image/bmp' => 'bmp',
      'audio/mpeg' => 'mp3',
      'audio/mp4' => 'm4a',
      'audio/aac' => 'aac',
      'audio/wav' || 'audio/x-wav' => 'wav',
      'audio/ogg' => 'ogg',
      'audio/opus' => 'opus',
      'video/mp4' => 'mp4',
      'video/x-m4v' => 'm4v',
      'video/quicktime' => 'mov',
      'video/webm' => 'webm',
      _ => 'bin',
    };
  }

  static String? mimeTypeFromExtension(String? extension) {
    return switch (_normalizedExtension(extension)) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'bmp' => 'image/bmp',
      'mp3' => 'audio/mpeg',
      'm4a' => 'audio/mp4',
      'aac' => 'audio/aac',
      'wav' => 'audio/wav',
      'ogg' => 'audio/ogg',
      'opus' => 'audio/opus',
      'mp4' => 'video/mp4',
      'm4v' => 'video/x-m4v',
      'mov' => 'video/quicktime',
      'webm' => 'video/webm',
      _ => null,
    };
  }

  static StoredMediaKind kindFromMimeType(String? mimeType) {
    final normalized = _normalizedMimeType(mimeType);
    if (normalized == null) return StoredMediaKind.unknown;
    if (normalized.startsWith('image/')) return StoredMediaKind.image;
    if (normalized.startsWith('audio/')) return StoredMediaKind.audio;
    if (normalized.startsWith('video/')) return StoredMediaKind.video;
    return StoredMediaKind.unknown;
  }

  static StoredMediaKind kindFromExtension(String? extension) {
    return kindFromMimeType(mimeTypeFromExtension(extension));
  }

  static StoredMediaKind kindFromSource(String source) {
    return kindFromExtension(FileHelper.getExtension(source));
  }

  static bool isImage(String filePath) =>
      imageExtensions.contains(FileHelper.getExtension(filePath));

  static bool isAudio(String filePath) =>
      audioExtensions.contains(FileHelper.getExtension(filePath));

  static bool isVideo(String filePath) =>
      videoExtensions.contains(FileHelper.getExtension(filePath));

  static bool isRemoteUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<Uint8List?> getBytesFromUrl(String? url) async {
    if (url == null || url.isEmpty) return null;

    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final response = await http.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }

    return response.bodyBytes;
  }

  static bool isImageMimeType(String? mimeType) =>
      kindFromMimeType(mimeType) == StoredMediaKind.image;

  static bool isAudioMimeType(String? mimeType) =>
      kindFromMimeType(mimeType) == StoredMediaKind.audio;

  static bool isVideoMimeType(String? mimeType) =>
      kindFromMimeType(mimeType) == StoredMediaKind.video;

  static String? _normalizedMimeType(String? mimeType) {
    final value = mimeType?.split(';').first.trim().toLowerCase();
    return value == null || value.isEmpty ? null : value;
  }

  static String? _normalizedExtension(String? extension) {
    final value = extension?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    return value.startsWith('.') ? value.substring(1) : value;
  }
}
