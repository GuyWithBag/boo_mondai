import 'package:boo_mondai/services/services.barrel.dart';

class Services {
  static late final HiveService hive;
  static late final FsrsService fsrs;

  static void init() {
    hive = HiveService();
    fsrs = FsrsService();
  }
}
