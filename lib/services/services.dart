import 'package:boo_mondai/services/supabase/supabase_auth_service.dart';
import 'package:boo_mondai/services/supabase/supabase_card_service.dart';
import 'package:boo_mondai/services/supabase/supabase_deck_service.dart';
import 'package:boo_mondai/services/supabase/supabase_fsrs_service.dart';
import 'package:boo_mondai/services/supabase/supabase_leaderboard_service.dart';
import 'package:boo_mondai/services/supabase/supabase_quiz_service.dart';
import 'package:boo_mondai/services/supabase/supabase_research_service.dart';
import 'package:boo_mondai/services/supabase/supabase_storage_service.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class Services {
  static late final HiveService hive;
  static late final FsrsService fsrs;

  // ── Supabase domain services ──────────────────────────
  static late final SupabaseAuthService auth;
  static late final SupabaseDeckService deck;
  static late final SupabaseCardService card;
  static late final SupabaseQuizService quiz;
  static late final SupabaseFsrsService fsrsSync;
  static late final SupabaseLeaderboardService leaderboard;
  static late final SupabaseResearchService research;
  static late final SupabaseStorageService storage;

  static void init() {
    hive = HiveService();
    fsrs = FsrsService();

    auth = SupabaseAuthService();
    deck = SupabaseDeckService();
    card = SupabaseCardService();
    quiz = SupabaseQuizService();
    fsrsSync = SupabaseFsrsService();
    leaderboard = SupabaseLeaderboardService();
    research = SupabaseResearchService();
    storage = SupabaseStorageService();
  }
}
