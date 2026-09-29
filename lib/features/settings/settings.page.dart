import 'package:boo_mondai/lib.barrel.dart'
    show
        ListHelper,
        PathHelper,
        StringHelper,
        SettingPath,
        SettingsStore,
        SettingsTile,
        SettingsSection,
        ListingStatesWrapper,
        AppBar,
        Scaffold,
        AppTokens;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:theme_variants/theme_variants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, this.pagePath});

  final String? pagePath;

  @override
  Widget build(BuildContext context) {
    final pagePath = this.pagePath;
    if (pagePath == null) return const _SettingsIndexPage();

    final tokens = context.themeTokens<AppTokens>();
    final store = context.read<SettingsStore>();
    return SignalBuilder(
      builder: (context) {
        final paths = store.pathsForPage(pagePath);
        final sections = ListHelper.groupBy<SettingPath, String>(
          paths,
          (path) => path.section,
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
            itemBuilder: (context, _, section) => SettingsSection(
              title: StringHelper.toTitleCase(section.key),
              children: [
                for (final path in section.value)
                  if (store.isVisible(path) && store.hasAccess(path))
                    SettingsTile(path: path, settingsStore: store),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsIndexPage extends StatelessWidget {
  const _SettingsIndexPage();

  @override
  Widget build(BuildContext context) {
    final pagePaths = context.read<SettingsStore>().pagePaths;
    return Scaffold(
      appBar: AppBar(title: 'Settings'),
      body: ListingStatesWrapper.list(
        useParentScroll: true,
        separatorHeight: 0,
        items: pagePaths,
        itemBuilder: (context, _, pagePath) => ListTile(
          title: Text(StringHelper.toTitleCase(pagePath)),
          subtitle: Text(pagePath),
          trailing: const Icon(Icons.chevron_right),
          onTap: () =>
              context.push('/settings/${Uri.encodeComponent(pagePath)}'),
        ),
      ),
    );
  }
}
