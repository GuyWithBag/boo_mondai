/// Parsed representation of a setting key.
///
/// UI-visible setting keys follow:
/// `<page-path>/<section>.<name>`
///
/// Example:
/// `study_session/card_stage.use_card_as_container`
class SettingPath {
  const SettingPath({
    required this.key,
    required this.pagePath,
    required this.section,
    required this.name,
  });

  final String key;
  final String pagePath;
  final String section;
  final String name;

  static SettingPath parse(String key) {
    final slashIndex = key.lastIndexOf('/');
    final pagePath = slashIndex < 0 ? '' : key.substring(0, slashIndex);
    final settingPath = slashIndex < 0 ? key : key.substring(slashIndex + 1);
    final dotIndex = settingPath.indexOf('.');

    if (dotIndex < 0) {
      return SettingPath(
        key: key,
        pagePath: pagePath,
        section: settingPath,
        name: settingPath,
      );
    }

    return SettingPath(
      key: key,
      pagePath: pagePath,
      section: settingPath.substring(0, dotIndex),
      name: settingPath.substring(dotIndex + 1),
    );
  }
}
