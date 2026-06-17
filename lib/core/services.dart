import 'package:boo_mondai/lib.barrel.dart'
    show ResearchService, FsrsService, AuthService;

class Services {
  static late final FsrsService fsrs;
  static late final ResearchService research;

  static void init() {
    fsrs = FsrsService();
    research = ResearchService();
  }
}
