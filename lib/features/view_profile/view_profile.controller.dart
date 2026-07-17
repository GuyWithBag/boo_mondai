import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        Profile,
        ProfileService,
        StoredMediaPathHelper,
        StoredMediaService;
import 'package:file_picker/file_picker.dart' show PlatformFile;

class ViewProfileController extends Controller {
  Profile get currentProfile => ProfileService.getCurrentProfile();

  String? get currentAvatarUrl =>
      StoredMediaService.getFileByPath(
        StoredMediaPathHelper.profileAvatar(),
      )?.path ??
      currentProfile.avatarUrl;

  Future<void> updateDisplayName(String displayName) async {
    setLoading(true);
    try {
      await ProfileService.updateDisplayName(displayName);
      notifyListeners();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAvatarImage(PlatformFile file) async {
    setLoading(true);
    try {
      await ProfileService.updateAvatarImage(file);
      notifyListeners();
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
