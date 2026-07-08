import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckDownloadsService,
        FsrsService,
        ProgressCheckpointService,
        ResearchService,
        StreakService;
import 'package:boo_mondai/core/services/service.dart';
import 'package:boo_mondai/core/services/service_registry.dart';

class Services {
  static late final FsrsService fsrs;
  static late final ResearchService research;
  static late final StreakService streak;
  static late final DeckDownloadsService deckDownloads;
  static late final ProgressCheckpointService progressCheckpoint;

  static void init() {
    fsrs = create(FsrsService());
    research = create(ResearchService());
    streak = create(StreakService());
    progressCheckpoint = create(ProgressCheckpointService());
    deckDownloads = create(
      DeckDownloadsService(progressCheckpointService: progressCheckpoint),
    );
  }

  static T create<T extends Service>(T service) {
    return ServiceRegistry.add(service);
  }
}
