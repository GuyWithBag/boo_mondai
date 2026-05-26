import 'package:flutter/material.dart';

/// AppPage-route builder signature with access to path/query params.
typedef PageBuilder =
    Widget Function(
      BuildContext context, {
      Map<String, String> pathParameters,
      Map<String, String> queryParameters,
    });

/// Route metadata and typed page builder.
class AppPage {
  const AppPage({
    this.scaffoldHeader,
    required this.url,
    required this.icon,
    required this.name,
    required this.builder,
    this.selectedIcon,
  });

  final Widget? scaffoldHeader;
  final String url;
  final Widget icon;
  final Widget? selectedIcon;
  final Widget name;
  final PageBuilder builder;
}
