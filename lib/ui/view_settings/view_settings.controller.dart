import 'package:boo_mondai/lib.barrel.dart'
    show ListHelper, PathHelper, SettingPath, SettingsStore, StringHelper;

class ViewSettingsController {
  const ViewSettingsController({
    required this.settingsStore,
    required this.pagePath,
  });

  final SettingsStore settingsStore;
  final String? pagePath;

  bool get isIndex => pagePath == null;

  String get title {
    final path = pagePath;
    if (path == null) return 'Settings';

    return StringHelper.toTitleCase(
      PathHelper.getLastPathSegmentOrFallback(path, 'settings'),
    );
  }

  List<String> get pagePaths => settingsStore.pagePaths;

  List<MapEntry<String, List<SettingPath>>> get sections {
    final path = pagePath;
    if (path == null) return const [];

    return ListHelper.groupBy<SettingPath, String>(
      settingsStore.pathsForPage(path),
      (settingPath) => settingPath.section,
    ).entries.toList();
  }

  List<SettingPath> visiblePathsForSection(List<SettingPath> paths) {
    return [
      for (final path in paths)
        if (settingsStore.isVisible(path) && settingsStore.hasAccess(path))
          path,
    ];
  }

  String pagePathLabel(String pagePath) => StringHelper.toTitleCase(pagePath);

  String sectionTitle(String section) => StringHelper.toTitleCase(section);

  String locationForPage(String pagePath) {
    return '/settings?page=${Uri.encodeQueryComponent(pagePath)}';
  }
}
