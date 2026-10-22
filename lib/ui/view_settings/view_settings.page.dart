import 'package:boo_mondai/lib.barrel.dart'
    show
        SettingsStore,
        SettingsSection,
        SettingsTile,
        ListingStatesWrapper,
        AppBar,
        Scaffold,
        AppTokens,
        ViewSettingsController;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart' show useMemoized;
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewSettingsPage extends SignalHookWidget {
  const ViewSettingsPage({super.key, this.pagePath});

  final String? pagePath;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final store = SettingsStore.instance;
    final controller = useMemoized(
      () => ViewSettingsController(settingsStore: store, pagePath: pagePath),
      [store, pagePath],
    );

    if (controller.isIndex) {
      return Scaffold(
        appBar: AppBar(title: controller.title),
        body: ListingStatesWrapper.list(
          useParentScroll: true,
          separatorHeight: 0,
          items: controller.pagePaths,
          itemBuilder: (context, _, pagePath) => ListTile(
            title: Text(controller.pagePathLabel(pagePath)),
            subtitle: Text(pagePath),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(controller.locationForPage(pagePath)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: controller.title),
      body: ListingStatesWrapper.list(
        useParentScroll: true,
        padding: EdgeInsets.zero,
        separatorHeight: tokens.spaceLayoutGapSm,
        items: controller.sections,
        itemBuilder: (context, _, section) {
          final visiblePaths = controller.visiblePathsForSection(section.value);
          return SettingsSection(
            title: controller.sectionTitle(section.key),
            children: [
              for (final path in visiblePaths)
                SettingsTile(path: path, settingsStore: store),
            ],
          );
        },
      ),
    );
  }
}
