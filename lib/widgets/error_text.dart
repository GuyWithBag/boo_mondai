// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/error_text.dart
// PURPOSE: Selectable error message widget with theme error color
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final Exception? exception;

  const ErrorText(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    if (exception == null) {
      return SizedBox.shrink();
    }
    return SelectableText(
      exception.toString(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
