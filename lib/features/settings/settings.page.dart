import 'package:boo_mondai/lib.barrel.dart'
    show
        ListHelper,
        PathHelper,
        StringHelper,
        SettingsController,
        SettingTileEntry,
        SettingsService,
        SettingsTile,
        SettingsSection,
        ListingStatesWrapper,
        AppBar,
        Scaffold,
        AppTokens;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, this.pagePath});

  final String? pagePath;

  @override
  Widget build(BuildContext context) {
    final pagePath = this.pagePath;
    if (pagePath == null) {
      return const _SettingsIndexPage();
    }
    final tokens = context.themeTokens<AppTokens>();
    // Watch so the page rebuilds when any setting changes.
    final controller = context.watch<SettingsController>();
    final entries = SettingsService.uiForPage(pagePath);
    final sections = ListHelper.groupBy<SettingTileEntry<dynamic>, String>(
      entries,
      (entry) => entry.path.section,
    );

    return Scaffold(
      appBar: AppBar(
        title: StringHelper.toTitleCase(
          PathHelper.getLastPathSegmentOrFallback(pagePath, 'settings'),
        ),
      ),
      body: ListingStatesWrapper.list(
        useParentScroll: true,
        padding: EdgeInsets.zero,
        separatorHeight: tokens.spaceLayoutGapSm,
        items: sections.entries.toList(),
        itemBuilder: (context, _, section) {
          return SettingsSection(
            title: StringHelper.toTitleCase(section.key),
            children: [
              for (final entry in section.value)
                if (entry.visibleWhen?.call(controller) ?? true)
                  SettingsTile(
                    settingTileEntry: entry,
                    settingsController: controller,
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsIndexPage extends StatelessWidget {
  const _SettingsIndexPage();

  @override
  Widget build(BuildContext context) {
    final pagePaths = SettingsService.pagePaths;

    return Scaffold(
      appBar: AppBar(title: 'Settings'),
      body: ListingStatesWrapper.list(
        useParentScroll: true,
        separatorHeight: 0,
        items: pagePaths,
        itemBuilder: (context, _, pagePath) {
          return ListTile(
            title: Text(
              StringHelper.toTitleCase(
                PathHelper.getLastPathSegmentOrFallback(pagePath, pagePath),
              ),
            ),
            subtitle: Text(pagePath),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(SettingsService.pageUrl(pagePath)),
          );
        },
      ),
    );
  }
}
