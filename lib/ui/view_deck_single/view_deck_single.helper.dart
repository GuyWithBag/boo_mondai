import 'package:boo_mondai/lib.barrel.dart' show StringHelper, VisibilityState;

abstract final class ViewDeckSingleHelper {
  static String getTitle(String? value) {
    return StringHelper.toTrimmedOrFallback(value, 'Untitled deck');
  }

  static String getShortDescription(String? value) {
    return StringHelper.toTrimmedOrFallback(value, 'No short description yet.');
  }

  static String getLongDescription(String? value) {
    return StringHelper.toTrimmedOrFallback(value, 'No long description yet.');
  }

  static String getProfileName(String? name) {
    return StringHelper.toTrimmedOrFallback(name, 'Unknown User');
  }

  static String getVisibilityLabel(VisibilityState state) {
    return switch (state) {
      VisibilityState.private => 'Private',
      VisibilityState.public => 'Public',
      VisibilityState.unlisted => 'Unlisted',
    };
  }
}
