import 'package:boo_mondai/lib.barrel.dart' show NotificationsController;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewNotificationsController {
  const ViewNotificationsController._();

  static NotificationsController of(BuildContext context) {
    return context.watch<NotificationsController>();
  }
}
