import 'package:boo_mondai/ui/notification.bubble/notification.bubble.dart';
import 'package:flutter/material.dart';

NotificationBubbleHandle showNotificationBubble(OverlayState overlay) {
  final entry = OverlayEntry(
    builder: (_) => const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(bottom: false, child: NotificationBubble()),
    ),
  );

  overlay.insert(entry);
  return NotificationBubbleHandle(entry);
}

class NotificationBubbleHandle {
  const NotificationBubbleHandle(this.entry);

  final OverlayEntry entry;

  void remove() {
    if (entry.mounted) entry.remove();
  }
}
