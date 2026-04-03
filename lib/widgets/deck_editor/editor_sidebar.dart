// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/editor_sidebar.dart
// PURPOSE: Sidebar listing all templates in the deck with add button
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart'; // Added to ensure template types are visible
import 'package:boo_mondai/shared/shared.barrel.dart';

class EditorSidebar extends StatelessWidget {
  const EditorSidebar({
    super.key,
    required this.templates, // <-- CHANGED
    required this.activeTemplateId, // <-- CHANGED
    required this.isAdding,
    required this.onAdd,
    this.children,
  });

  final List<CardTemplate> templates; // <-- CHANGED
  final String? activeTemplateId; // <-- CHANGED
  final bool isAdding;
  final VoidCallback onAdd;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          right: BorderSide(color: scheme.surfaceContainerHighest),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Cards (N)" + add button
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Cards (${templates.length})', // <-- CHANGED
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: isAdding
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add, size: 18),
                  tooltip: 'Add new card',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: isAdding ? null : onAdd,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: children != null && children!.isNotEmpty
                ? ListView(children: children!)
                : const Center(
                    child: Text(
                      'No cards yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
