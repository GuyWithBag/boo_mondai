// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/pages/error.page.dart
// PURPOSE: Route-level error page with a recovery action
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/lib.barrel.dart' show StatusLayoutState;

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.exception});

  final Exception exception;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          StatusLayoutState.exception(exception: exception),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
