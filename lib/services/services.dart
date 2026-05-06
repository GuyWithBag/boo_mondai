import 'package:boo_mondai/services/services.barrel.dart';

class Services {
  static late final HiveService hive;
  static late final FsrsService fsrs;
  static late final ResearchService research;
  static late final AuthService auth;

  static void init() {
    hive = HiveService();
    fsrs = FsrsService();
    research = ResearchService();
    auth = AuthService();
  }
}
